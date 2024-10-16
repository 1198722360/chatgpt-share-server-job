#!/bin/bash

# 定义全局变量
night_mysql_user=""
night_mysql_password=""
night_database_name=""
night_container=""

share_mysql_user=""
share_mysql_password=""
share_database_name=""
share_container=""

project_dir="$HOME/chatgpt-share-server-job"

# 定义日志文件
LOG_FILE="$project_dir/migration.log"

# 创建项目目录（如果不存在）
# mkdir -p "$project_dir"

# 重定向所有输出和错误到日志文件，同时显示在终端
# exec > >(tee -i "$LOG_FILE") 2>&1

echo "========== 数据迁移脚本开始 =========="

# 定义函数用于克隆 Git 仓库
clone_git_repository() {
    if [ ! -d "$project_dir" ]; then
        echo "正在克隆 chatgpt-share-server-job 到 $project_dir..."
        git clone https://github.com/1198722360/chatgpt-share-server-job.git "$project_dir"
        
        if [ $? -ne 0 ]; then
            echo "克隆仓库失败，脚本停止运行。"
            exit 1
        fi
    else
        echo "项目已存在，跳过克隆步骤。"
    fi
}

# 定义函数用于获取 Docker 容器列表并选择一个容器
select_docker_container() {
    local container_role="$1"
    echo "你的docker容器如下："
    mapfile -t container_list < <(docker ps --format "{{.Names}}")

    if [ ${#container_list[@]} -eq 0 ]; then
        echo "没有运行中的 Docker 容器。"
        exit 1
    fi

    for i in "${!container_list[@]}"; do
        echo "$((i+1)). ${container_list[$i]}"
    done

    while true; do
        read -p "请选择${container_role} MySQL 容器序号: " container_number
        if ! [[ "$container_number" =~ ^[0-9]+$ ]]; then
            echo "无效的序号：请输入数字。"
            continue
        fi
        if [[ $container_number -lt 1 || $container_number -gt ${#container_list[@]} ]]; then
            echo "无效的序号：请确保输入的序号在正确的范围内。"
            continue
        fi
        selected_container=${container_list[$((container_number-1))]}
        echo "已选择容器: $selected_container"
        break
    done
}

# 定义函数用于获取 MySQL 凭证
get_mysql_credentials() {
    local role="$1"
    local user_var="$2"
    local pass_var="$3"
    local db_var="$4"

    read -p "请输入${role} MySQL用户名 (默认: root): " temp_user
    eval $user_var=\${temp_user:-root}

    read -s -p "请输入${role} MySQL密码 (默认: 123456): " temp_pass
    eval $pass_var=\${temp_pass:-123456}
    echo

    read -p "请输入${role} 数据库名称 (默认: cool): " temp_db
    eval $db_var=\${temp_db:-cool}

    # 验证 MySQL 连接
    docker exec "$selected_container" mysql -u"${!user_var}" -p"${!pass_var}" -e "USE ${!db_var};" >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "${role} MySQL 凭证错误或数据库不存在。请重新输入。"
        get_mysql_credentials "$role" "$user_var" "$pass_var" "$db_var"
    fi
}

# 定义函数用于导出 MySQL 表
export_mysql_tables() {
    local container="$1"
    local user="$2"
    local password="$3"
    local database="$4"
    local tables=("${!5}")

    for table in "${tables[@]}"; do
        echo "正在导出表 ${table}..."
        docker exec "$container" sh -c "mysqldump -u$user -p$password $database $table" > "$project_dir/$table.sql"
        if [ $? -ne 0 ]; then
            echo "导出表 ${table} 失败。请检查容器和数据库连接。"
            exit 1
        fi
    done
}

# 定义函数用于导入 MySQL 表
import_mysql_tables() {
    local container="$1"
    local user="$2"
    local password="$3"
    local database="$4"
    local table="$5"
    local temp_table="$6"

    echo "正在导入表 ${table} 到临时表 ${temp_table}..."
    sed "s/`basename $table`/${temp_table}/g" "$project_dir/$table.sql" > "$project_dir/${temp_table}.sql"
    docker cp "$project_dir/${temp_table}.sql" "$container":/tmp/
    docker exec "$container" sh -c "mysql -u$user -p$password $database < /tmp/${temp_table}.sql"
    if [ $? -ne 0 ]; then
        echo "导入临时表 ${temp_table} 失败。请检查 SQL 语法和数据完整性。"
        exit 1
    fi
    rm "$project_dir/${temp_table}.sql"
}

# 定义函数用于删除临时表
delete_temporary_tables() {
    local container="$1"
    local user="$2"
    local password="$3"
    local database="$4"
    local tables=("${!5}")

    for table in "${tables[@]}"; do
        echo "正在删除临时表 ${table}..."
        docker exec "$container" sh -c "mysql -u$user -p$password $database -e \"DROP TABLE IF EXISTS $table;\""
        if [ $? -ne 0 ]; then
            echo "删除临时表 ${table} 失败。请手动检查。"
            exit 1
        fi
    done
}

# 定义函数用于处理数据迁移
process_data_migration() {
    local share_container="$1"
    local share_user="$2"
    local share_password="$3"
    local share_db="$4"

    echo "开始数据迁移..."

    # 导入 job.sql
    sql_file="$project_dir/job.sql"
    if [ ! -f "$sql_file" ]; then
        echo "错误：未找到 job.sql 文件。"
        exit 1
    fi
    echo "正在导入 job.sql..."
    docker cp "$sql_file" "$share_container":/tmp/
    docker exec "$share_container" sh -c "mysql --default-character-set=utf8mb4 -u$share_user -p$share_password $share_db < /tmp/job.sql"
    if [ $? -ne 0 ]; then
        echo "导入 job.sql 失败。请检查 job.sql 文件和数据库连接。"
        exit 1
    fi

    # 导入临时表
    import_mysql_tables "$share_container" "$share_user" "$share_password" "$share_db" "chatgpt_user" "ye_chatgpt_user"
    import_mysql_tables "$share_container" "$share_user" "$share_password" "$share_db" "chatgpt_conversations" "ye_chatgpt_conversations"

    # 验证 ye_chatgpt_conversations.usertoken 是否有 NULL 值
    echo "验证 ye_chatgpt_conversations.usertoken 是否有 NULL 值..."
    null_count=$(docker exec "$share_container" sh -c "mysql -u$share_user -p$share_password $share_db -N -B -e \"SELECT COUNT(*) FROM ye_chatgpt_conversations WHERE usertoken IS NULL;\"")
    echo "ye_chatgpt_conversations.usertoken 中的 NULL 记录数：$null_count"
    if [ "$null_count" -ne 0 ]; then
        echo "错误：ye_chatgpt_conversations.usertoken 中存在 NULL 值。请先清理源数据。"
        exit 1
    fi
    echo "验证通过：ye_chatgpt_conversations.usertoken 无 NULL 值。"

    # 验证 account 表中的 phone 是否与 chatgpt_user.userToken 一致
    echo "验证 account.phone 是否在 chatgpt_user.userToken 中存在对应记录..."
    missing_count=$(docker exec "$share_container" sh -c "mysql -u$share_user -p$share_password $share_db -N -B -e \"SELECT COUNT(*) FROM account a LEFT JOIN chatgpt_user cu ON a.phone = cu.userToken WHERE cu.id IS NULL;\"")
    echo "account.phone 中没有对应 chatgpt_user.userToken 的记录数：$missing_count"
    if [ "$missing_count" -ne 0 ]; then
        echo "错误：存在 account.phone 没有对应的 chatgpt_user.userToken。请先处理这些记录。"
        exit 1
    fi
    echo "验证通过：所有 account.phone 都有对应的 chatgpt_user.userToken。"

    # 创建一个临时 SQL 文件
    temp_sql="$project_dir/temp_migration.sql"

    cat <<EOF > "$temp_sql"
START TRANSACTION;

-- 创建临时表用于存储 account 数据
CREATE TEMPORARY TABLE temp_account (
    id INT,
    register_datetime DATETIME,
    phone VARCHAR(255),
    password VARCHAR(255),
    normal_expire_time DATETIME NOT NULL,
    plus_expire_time DATETIME NOT NULL,
    mail VARCHAR(255),
    inviter_id INT,
    invite_code VARCHAR(6)
);

-- 插入数据到 temp_account，确保 normal_expire_time 和 plus_expire_time 根据条件设置
INSERT INTO temp_account (id, register_datetime, phone, password, normal_expire_time, plus_expire_time, mail, inviter_id, invite_code)
SELECT 
    id,
    createTime,
    userToken AS phone,
    password,
    COALESCE(expireTime, NOW()) AS normal_expire_time,
    CASE 
        WHEN isPlus = 1 THEN COALESCE(expireTime, NOW()) 
        ELSE NOW()
    END AS plus_expire_time,
    email,
    inviterId,
    UPPER(CONCAT(SUBSTRING(MD5(RAND()), 1, 3), SUBSTRING(MD5(RAND()), 1, 3)))
FROM ye_chatgpt_user;

-- 插入数据到 account 表
INSERT INTO account (id, register_datetime, phone, password, normal_expire_time, plus_expire_time, mail, inviter_id, invite_code)
SELECT id, register_datetime, phone, password, normal_expire_time, plus_expire_time, mail, inviter_id, invite_code FROM temp_account;

-- 插入数据到 chatgpt_user 表，并保持 userToken 一致
INSERT INTO chatgpt_user (createTime, updateTime, expireTime, userToken, isPlus)
SELECT NOW(), NOW(), COALESCE(expireTime, NOW()), userToken, isPlus FROM ye_chatgpt_user;

-- 更新 account 表的 chatgpt_user_id
UPDATE account a
JOIN chatgpt_user cu ON a.phone = cu.userToken
SET a.chatgpt_user_id = cu.id;

-- 插入数据到 chatgpt_conversations 表
INSERT INTO chatgpt_conversations (createTime, updateTime, deleted_at, usertoken, convid, title, email, content)
SELECT createTime, updateTime, deleted_at, usertoken, convid, title, email, content FROM ye_chatgpt_conversations;

COMMIT;
EOF

    # 执行临时 SQL 文件并捕获错误
    echo "执行数据迁移的 SQL 语句..."
    docker cp "$temp_sql" "$share_container":/tmp/
    docker exec "$share_container" sh -c "mysql --default-character-set=utf8mb4 -u$share_user -p$share_password $share_db < /tmp/temp_migration.sql" 2>>"$LOG_FILE"
    migration_status=$?
    if [ $migration_status -ne 0 ]; then
        echo "数据迁移过程中发生错误，正在回滚事务。"
        docker exec "$share_container" mysql -u"$share_user" -p"$share_password" "$share_db" -e "ROLLBACK;"
        echo "错误详情请查看日志文件：$LOG_FILE"
        exit 1
    fi

    # 删除临时 SQL 文件
    docker exec "$share_container" rm /tmp/temp_migration.sql
    rm "$temp_sql"

    echo "数据迁移的 SQL 语句执行成功。"

    # 删除临时表 ye_chatgpt_conversations 和 ye_chatgpt_user
    echo "开始删除临时表..."
    temporary_tables=("ye_chatgpt_conversations" "ye_chatgpt_user")
    delete_temporary_tables "$share_container" "$share_user" "$share_password" "$share_db" temporary_tables[@]
    echo "临时表删除成功。"

    echo "数据迁移成功。"
}

# 主脚本流程

# 1. 克隆 Git 仓库
clone_git_repository


echo "即将导出夜的mysql数据"

# 2. 选择并配置“夜的 MySQL”容器
select_docker_container "夜的"
night_container="$selected_container"
get_mysql_credentials "夜的" "night_mysql_user" "night_mysql_password" "night_database_name"

# 3. 导出 chatgpt_user 和 chatgpt_conversations 表
export_tables=("chatgpt_user" "chatgpt_conversations")
export_mysql_tables "$night_container" "$night_mysql_user" "$night_mysql_password" "$night_database_name" export_tables[@]


echo "即将导入夜的mysql数据到share的mysql"

# 4. 选择并配置“share 的 MySQL”容器
select_docker_container "share 的"
share_container="$selected_container"
get_mysql_credentials "share 的" "share_mysql_user" "share_mysql_password" "share_database_name"

# 5. 导入并处理数据
process_data_migration "$share_container" "$share_mysql_user" "$share_mysql_password" "$share_database_name"

# 6. 清理导出的 SQL 文件
echo "清理导出的 SQL 文件..."
rm -f "$project_dir/chatgpt_user.sql" "$project_dir/chatgpt_conversations.sql" "$project_dir/ye_chatgpt_user.sql" "$project_dir/ye_chatgpt_conversations.sql"


echo "========== 数据迁移结束 =========="


deploy_chatgpt_share_server() {
    # 配置文件路径在项目根目录下
    config_file="$project_dir/application.yml"

    # 更新 MySQL 用户名和密码到配置文件
    echo "-----------------------------"
    echo "接下来将配置job二开配置......"
    sed -i "s/username: .*/username: $share_mysql_user/" "$config_file"
    sed -i "s/password: .*/password: $share_mysql_password/" "$config_file"

    # 更新 MySQL 密码（仅修改 spring.datasource.druid.password 的值）
    sed -i "s/^  password: .*/  password: $share_mysql_password/" "$config_file"

    # 设置 FuClaude 状态更新接口密码
    read -s -p "请设置一个fuclaude状态更新接口密码: " fuclaude_password
    echo
    # 更新 fuclaude 配置下的 password 而不是全局替换
    sed -i "/fuclaude:/,/password:/s/password: .*/password: $fuclaude_password/" "$config_file"

    # 设置授权码
    read -p "请输入授权码(https://075114.xyz有个测试用的授权码0.1元): " license_code
    sed -i "s/license: .*/license: $license_code/" "$config_file"

    echo "配置文件已更新完毕。"

    # 提示正在启动项目
    echo "正在启动chatgpt-share-server-job..."

    # 执行 deploy.sh 启动脚本
    cd "$project_dir"
    if [ -f "./deploy.sh" ]; then
        chmod +x ./deploy.sh
        ./deploy.sh
    else
        echo "错误：未找到 deploy.sh 文件，无法启动项目。"
        exit 1
    fi

    # 获取宿主机外网IPv4
    echo "获取宿主机外网IPv4地址..."
    external_ip=$(curl -s http://checkip.amazonaws.com)

    if [ -z "$external_ip" ]; then
        echo "无法获取宿主机的外网IP地址，请检查网络连接。"
        exit 1
    fi

    # 提示客户端和管理端地址
    echo "项目启动完成。"
    echo "客户端：http://$external_ip:6777/list"
    echo "管理端：http://$external_ip:6777/myadmin"

    # 询问是否配置 Caddy
    read -n 1 -p "是否现在配置Caddy?(y/n): " configure_caddy
    echo

    if [[ "$configure_caddy" == "y" || "$configure_caddy" == "Y" ]]; then
        # 获取用户输入的一级域名
        read -p "请输入一级域名(不带www): " domain_name

        # 添加反向代理配置到 /etc/caddy/Caddyfile
        caddyfile="/etc/caddy/Caddyfile"
        echo "正在更新 $caddyfile..."

        # 在 Caddyfile 末尾添加配置，为 domain 和 www.domain 添加反向代理
        cat <<EOL >> "$caddyfile"
$domain_name www.$domain_name {
    reverse_proxy /list 127.0.0.1:6777
    reverse_proxy /mall 127.0.0.1:6777
    reverse_proxy /me 127.0.0.1:6777
    reverse_proxy /job/* 127.0.0.1:6777
    reverse_proxy /myadmin* 127.0.0.1:6777
    reverse_proxy /partner 127.0.0.1:6777
    reverse_proxy /xyhelper* 127.0.0.1:6777
    reverse_proxy 127.0.0.1:8300
}
EOL

        echo "反向代理配置已添加到 $caddyfile 末尾，请手动修改 $caddyfile 中的旧配置。"

        # 重新加载 Caddy 配置
        systemctl reload caddy

        # 提示新的客户端和管理端地址
        echo "客户端：https://$domain_name/list"
        echo "管理端：https://$domain_name/myadmin"
    fi
}

deploy_chatgpt_share_server


echo "脚本执行完毕。"



