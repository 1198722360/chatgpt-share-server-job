cd ~
git clone -b deploy --depth=1 https://github.com/xyhelper/chatgpt-share-server-deploy.git chatgpt-share
cd chatgpt-share

# 替换原审计限流
sed -i 's|http://auditlimit:8080/audit_limit|http://chatgpt-job:6777/audit_limit|g' docker-compose.yml

# 下载额外的数据表
wget -P docker-entrypoint-initdb.d/  https://raw.githubusercontent.com/1198722360/chatgpt-share-server-job/refs/heads/main/job.sql

# 部署share
./deploy.sh

# 部署本外挂项目
cd ~
git clone https://github.com/1198722360/chatgpt-share-server-job.git
cd chatgpt-share-server-job
./deploy.sh