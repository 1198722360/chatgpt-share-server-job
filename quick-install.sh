#!/bin/bash
set -e

echo "正在拉取chatgpt-share-server"
cd ~
git clone -b deploy --depth=1 https://github.com/xyhelper/chatgpt-share-server-deploy.git chatgpt-share
cd chatgpt-share

echo "替换原审计限流"
# 替换原审计限流
sed -i 's|http://auditlimit:8080/audit_limit|http://chatgpt-job:6777/audit_limit|g' docker-compose.yml

echo "正在下载额外数据库文件"
# 下载额外的数据表
wget -P docker-entrypoint-initdb.d/  https://raw.githubusercontent.com/1198722360/chatgpt-share-server-job/refs/heads/main/job.sql

echo "正在部署chatgpt-share-server"
# 部署share
./deploy.sh

echo "chatgpt-share-server部署成功"

echo "正在部署chatgpt-share-server-job"
# 部署本外挂项目
cd ~
git clone https://github.com/1198722360/chatgpt-share-server-job.git
cd chatgpt-share-server-job
./deploy.sh

echo "chatgpt-share-server-job部署成功"