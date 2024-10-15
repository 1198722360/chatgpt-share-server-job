#!/bin/bash

# 定义全局变量保存 MySQL 的相关信息
mysql_user=""
mysql_password=""
database_name=""
selected_container=""

# 定义函数用于获取 MySQL 相关信息
get_mysql_credentials() {
    if [[ -z "$mysql_user" ]]; then
        # 获取 MySQL 用户名，默认为 root
        read -p "请输入share MySQL用户名 (默认: root): " mysql_user
        mysql_user=${mysql_user:-root}

        # 获取 MySQL 密码，默认为 123456
        read -s -p "请输入share MySQL密码 (默认: 123456): " mysql_password
        mysql_password=${mysql_password:-123456}
        echo

        # 获取要执行SQL的数据库名称，默认为 cool
        read -p "请输入数据库名称 (默认: cool): " database_name
        database_name=${database_name:-cool}
    fi
}

# 定义函数用于备份 share 的 MySQL
backup_mysql() {
    # 让用户确认是否继续执行备份
    read -n 1 -p "您确认要备份 share 数据库吗？(y/n): " confirm_backup
    echo
    if [[ "$confirm_backup" != "y" && "$confirm_backup" != "Y" ]]; then
        echo "备份操作已取消。"
        exit 0
    fi

    # 获取 MySQL 相关信息
    get_mysql_credentials

    backup_file="$project_dir/${database_name}_backup.sql"
    echo "正在导出share数据库备份：$backup_file"
    docker exec $selected_container mysqldump -u$mysql_user -p$mysql_password $database_name > "$backup_file"

    if [ $? -ne 0 ]; then
        echo "数据库备份失败，脚本停止运行。"
        exit 1
    fi

    echo "数据库已成功备份到 $backup_file"
}

# 定义函数用于还原 share 的 MySQL
restore_mysql() {
    # 让用户确认是否继续执行还原
    read -n 1 -p "您确认要还原 share MySQL 数据库吗？(y/n): " confirm_restore
    echo
    if [[ "$confirm_restore" != "y" && "$confirm_restore" != "Y" ]]; then
        echo "还原操作已取消。"
        exit 0
    fi

    # 获取 MySQL 相关信息
    get_mysql_credentials

    restore_file="$project_dir/${database_name}_backup.sql"
    if [ ! -f "$restore_file" ]; then
        echo "错误：未找到还原文件 $restore_file。"
        exit 1
    fi

    echo "正在还原数据库..."
    docker exec -i $selected_container mysql -u$mysql_user -p$mysql_password $database_name < "$restore_file"

    if [ $? -ne 0 ]; then
        echo "数据库还原失败，脚本停止运行。"
        exit 1
    fi

    echo "数据库已成功还原。"
}

# 定义函数用于部署 chatgpt-share-server-job
deploy_chatgpt_share_server() {
    # 检查是否存在 job.sql 文件
    sql_file="$project_dir/job.sql"
    if [ ! -f "$sql_file" ]; then
        echo "错误：在克隆的项目中未找到 job.sql 文件。"
        exit 1
    fi

    echo "SQL脚本位置：$sql_file"

    # 获取 MySQL 相关信息
    get_mysql_credentials

    # 将SQL文件推送到容器内
    echo "正在推送额外的数据表结构到：$selected_container"
    docker cp $sql_file $selected_container:/tmp/

    if [ $? -ne 0 ]; then
        echo "推送SQL文件失败，脚本停止运行。"
        exit 1
    fi

    # 执行SQL脚本
    echo "正在添加二开项目所需的额外数据表，并将userToken剩余时长转换为未使用激活码，之后需要用户注册后到个人中心导入以前的userToken作为激活码..."
    docker exec -i $selected_container mysql -u$mysql_user -p$mysql_password $database_name -e "source /tmp/job.sql;" 2>mysql_error.log

    # 捕获 MySQL 命令的退出状态码
    mysql_status=$?

    # 检查退出状态码
    if [ $mysql_status -eq 127 ]; then
      echo "错误：选择的容器中没有找到MySQL登录命令。可能选择了错误的MySQL容器，脚本停止运行。"
      exit 1
    elif [ $mysql_status -eq 0 ]; then
      echo "MySQL登录成功，数据表更新完成"
    else
      echo "错误：MySQL用户名或密码有误，或者SQL脚本执行失败，脚本停止运行。"
      echo "详细错误信息请查看 'mysql_error.log'。"
      cat mysql_error.log
      exit 1
    fi

    # 配置文件路径在项目根目录下
    config_file="$project_dir/application.yml"

    # 更新 MySQL 用户名和密码到配置文件
    echo "-----------------------------"
    echo "接下来将配置job二开配置......"
    sed -i "s/username: .*/username: $mysql_user/" "$config_file"
    sed -i "s/password: .*/password: $mysql_password/" "$config_file"

    # 更新 MySQL 密码（仅修改 spring.datasource.druid.password 的值）
    sed -i "s/^  password: .*/  password: $mysql_password/" "$config_file"

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

# 获取项目目录
project_dir="$HOME/chatgpt-share-server-job"

# 克隆项目到用户主目录
if [ ! -d "$project_dir" ]; then
    echo "正在克隆 chatgpt-share-server-job到 $project_dir..."
    git clone https://github.com/1198722360/chatgpt-share-server-job.git "$project_dir"
    
    if [ $? -ne 0 ]; then
        echo "克隆仓库失败，脚本停止运行。"
        exit 1
    fi
else
    echo "项目已存在，跳过克隆步骤。"
fi

# 主菜单：备份、还原、部署
echo "请选择操作："
echo "1. 备份 share 的 MySQL"
echo "2. 还原 share 的 MySQL"
echo "3. 部署 chatgpt-share-server-job"
read -p "请输入选项 (1/2/3): " user_choice

# 获取所有容器的名称并存储在数组中
mapfile -t container_list < <(docker ps -a --format "{{.Names}}")

# 输出容器名称列表并加上序号
echo "正在读取你的docker 容器："
for i in "${!container_list[@]}"; do
  echo "$((i+1)). ${container_list[$i]}"
done

# 让用户选择容器
read -p "请选择share的MySQL容器序号: " container_number

# 验证输入是否为数字并且在有效范围内
if ! [[ "$container_number" =~ ^[0-9]+$ ]]; then
  echo "无效的序号：请输入数字。"
  exit 1
fi

# 检查输入的序号是否在范围内
if [[ $container_number -lt 1 || $container_number -gt ${#container_list[@]} ]]; then
  echo "无效的序号：请确保输入的序号在正确的范围内。"
  exit 1
fi

# 获取用户选择的容器名称
selected_container=${container_list[$((container_number-1))]}
echo "已选择容器: $selected_container"

# 根据用户选择执行相应的操作
case $user_choice in
  1)
    backup_mysql
    ;;
  2)
    restore_mysql
    ;;
  3)
    deploy_chatgpt_share_server
    ;;
  *)
    echo "无效的选项。脚本停止运行。"
    exit 1
    ;;
esac

