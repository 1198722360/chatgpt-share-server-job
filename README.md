# chatgpt-share-server-job
#### 未改主体的可高度自定义的xyhelper旗下的chatgpt-share-server二开。集注册、登录、在线下单、分离plus会员/普通会员、集成claude并获取剩余次数、邀请返利机制、二级分销系统、优惠券发放、激活码发放、公告管理、虚拟车队、审计限流等实用功能于一体。

## 首先向xyhelper致敬 :kissing_heart::kissing_heart::kissing_heart:

#### 快速预览
前端地址：[demo.075114.xyz](https://demo.075114.xyz "demo.075114.xyz")   测试账号：123456  密码：123456

后台地址：[demo.075114.xyz/myadmin](https://demo.075114.xyz/myadmin "demo.075114.xyz/myadmin")  账号：123456 密码：123456

测试分站：[demo.075115.xyz](https://demo.075115.xyz "demo.075115.xyz")  

测试分站后台：[demo.075115.xyz/partner](https://demo.075115.xyz/partner "demo.075115.xyz/partner")   账号：1partner 密码：1partner

[注]为避免测试站密码被改，原版xy后台已隐藏，并禁止对本项目后台作修改，修改报错为正常现象。

## 功能说明
1.注册登录：可选阿里云短信发验证码，或邮箱发验证码。后台可以配置新用户赠送优惠券、plus激活码、普通激活码。 已实现邮箱白名单，有效避免用户白嫖。

2.在线商城：支持支付宝当面付，生成下单二维码，用户可支付宝扫码下单。并可使用优惠券。

3.个人中心：用户可以导入、使用激活码。并可以看到以前导入过的激活码，方便售后。

4.<span style="color:red;">邀请返利</span>：后台设置邀请返利百分比，被邀请者购买后，邀请者获得一定时长的返利。

5.<span style="color:red;">Claude集成</span>：目前不支持单独售卖Claude，Plus会员可使用。已实现了<span style="color:red;">剩余次数记录</span>。

6.<span style="color:red;">二级分销</span>：在后台添加一个分销商账号，并设置对应的域名。在Caddy或Nginx中对这个域名配置一个和主站相同的反向代理配置。 分销商可以通过/partner进入管理页，可自定义公告、商品价格(相对于主站的倍数)等，用户进入分站时，<span style="color:red">显示的是分站的公告、价格</span>。 用户付的钱先到站长那，站长在/myadmin后台可以设置分站返额比例，并可定期向分销商结款。

7.**优惠券发放**：可以设置折扣、门槛、过期时间。可以配置注册赠送优惠券，可以手动向用户发放优惠券、或批量发放优惠券。

8.**激活码发放**：可以指定时长、是否plus、获得方式，向单个用户或指定人群(plus会员、普通会员、非会员、全部人)发放激活码。

9.**激活码生成**：指定时长、是否plus、获得方式批量生成**未使用的**激活码，一键导出，可用于发卡网。

10.公告配置：除了弹窗公告，其它公告均支持element plus标签、html标签、或文本，高度自定义，对非编程人员不友好，可以复制演示站后台的公告，让GPT帮忙修改、或只替换关键部分。

11.<span style="color:red;">虚拟车队</span>：可分别指定plus号的虚拟车数量、普号的虚拟车数量。以假乱真，1个号变100个号。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241003040523.png"/>

12.反监管功能：开启后不登录只显示账号列表，隐藏在线商城。上次被阿里云抽查到了，封了域名，要求我整改或备案。我跟客服扯了一晚上保证这保证那才给我解开。后来不知道是不是开启隐藏商店的原因，再也没找过我。🫥如果给查到，可以开启这个功能半个月，等检查的走了，再关闭。

13.<span style="color:red;">加强版限流器</span>：可分别对普通会员、plus会员的任意模型进行分组次数限制。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241003035842.png"/>


## 部署教程
- chatgpt-share-server部署教程请参考[https://chatgpt-share-server.xyhelper.cn/install](https://chatgpt-share-server.xyhelper.cn/install "https://chatgpt-share-server.xyhelper.cn/install")
- 本项目部署请参考下面两种方式

## ①正在使用share原版

##### 首先确保原版share在跑着

##### 然后执行下面的脚本一键备份+数据迁移+二开部署

##### (本脚本会把userToken转换为激活码，用户注册登陆后，前往个人中心将激活码导入、激活即可恢复原有的时长)

<span style="color:red">【注意】本项目跑起来且运营之后，禁止再次使用这个脚本！拉更新需要到chatgpt-share-server-job文件夹执行./deploy.sh</span>

```shell
bash <(curl -sSfL https://raw.githubusercontent.com/1198722360/chatgpt-share-server-job/refs/heads/main/share2job_init.sh)
```


###### 第一次运行share2job_init.sh，选1，先备份一下原share数据库，运行情况如下
```shell
root@756k52g63vi9d59:~# bash <(curl -sSfL https://raw.githubusercontent.com/1198722360/chatgpt-share-server-job/refs/heads/main/share2job_init.sh)
项目已存在，跳过克隆步骤。
请选择操作：
1. 备份 share 的 MySQL
2. 还原 share 的 MySQL
3. 部署 chatgpt-share-server-job
请输入选项 (1/2/3): 1
正在读取你的docker 容器：
1. chatgpt-share-server-job-chatgpt-job-1
2. chatgpt-share-chatgpt-share-server-1
3. chatgpt-share-watchtower-1
4. chatgpt-share-mysql-1
5. chatgpt-share-redis-1
6. chatgpt-share-auditlimit-1
请选择share的MySQL容器序号: 4
已选择容器: chatgpt-share-mysql-1
您确认要备份 share 数据库吗？(y/n): y
请输入share MySQL用户名 (默认: root): 
请输入share MySQL密码 (默认: 123456): 
请输入数据库名称 (默认: cool): 
正在导出share数据库备份：/root/chatgpt-share-server-job/cool_backup.sql
mysqldump: [Warning] Using a password on the command line interface can be insecure.
数据库已成功备份到 /root/chatgpt-share-server-job/cool_backup.sql
```
###### 再次运行share2job_init.sh，选3，部署chatgpt-share-server-job并完成数据迁移，运行情况如下：
```shell
root@756k52g63vi9d59:~# bash <(curl -sSfL https://raw.githubusercontent.com/1198722360/chatgpt-share-server-job/refs/heads/main/share2job_init.sh)
项目已存在，跳过克隆步骤。
请选择操作：
1. 备份 share 的 MySQL
2. 还原 share 的 MySQL
3. 部署 chatgpt-share-server-job
请输入选项 (1/2/3): 3
正在读取你的docker 容器：
1. chatgpt-share-server-job-chatgpt-job-1
2. chatgpt-share-chatgpt-share-server-1
3. chatgpt-share-watchtower-1
4. chatgpt-share-mysql-1
请选择share的MySQL容器序号: 4
已选择容器: chatgpt-share-mysql-1
SQL脚本位置：/root/chatgpt-share-server-job/job.sql
请输入share MySQL用户名 (默认: root): 
请输入share MySQL密码 (默认: 123456): 
请输入数据库名称 (默认: cool): 
正在推送额外的数据表结构到：chatgpt-share-mysql-1
Successfully copied 35.3kB to chatgpt-share-mysql-1:/tmp/
正在添加二开项目所需的额外数据表，并将userToken剩余时长转换为未使用激活码，之后需要用户注册后到个人中心导入以前的userToken作为激活码...
MySQL登录成功，数据表更新完成
-----------------------------
接下来将配置job二开配置......
请设置一个fuclaude状态更新接口密码: 
请输入授权码(https://075114.xyz有个测试用的授权码0.1元): 08tbss04-1086-4920-bd4h-02a6zmbab9kd
配置文件已更新完毕。
正在启动chatgpt-share-server-job...
项目启动完成。
客户端：http://41.77.123.122:6777/list
管理端：http://41.77.123.122:6777/myadmin
是否现在配置Caddy?(y/n): y
请输入一级域名(不带www): chatshare.xyz
正在更新 /etc/caddy/Caddyfile...
反向代理配置已添加到 /etc/caddy/Caddyfile 末尾，请手动修改 /etc/caddy/Caddyfile 中的旧配置。
客户端：https://chatshare.xyz/list
管理端：https://chatshare.xyz/myadmin
```

##### 2.部署claude。Claude基于始皇的fuclaude，感谢始皇的小玩具，需要准备一个额外域名，必须托管到cloudflare。详见：https://github.com/1198722360/chatgpt-share-server-job/blob/main/FUCLAUDE.md

## ②正在使用夜的二开

##### 首先确保原版share和夜的都在跑着

##### 然后执行下面的脚本数据迁移+二开部署(不影响夜数据库，放心运行)

<span style="color:red">【注意】本项目跑起来且运营之后，禁止再次使用这个脚本！拉更新需要到chatgpt-share-server-job文件夹执行./deploy.sh</span>

```shell
bash <(curl -sSfL https://raw.githubusercontent.com/1198722360/chatgpt-share-server-job/refs/heads/main/ye2job_init.sh)
```

## 其它配置

##### 1.替换share的审计限流：

###### 把share的docker-compose.yml里面的

```shell
http://auditlimit:8080/audit_limit
```

###### 替换成

```shell
http://chatgpt-job:6777/audit_limit
```

<br>

##### 2.开启本地保存对话记录以及无感换车

###### 在share的docker-compose.yml的chatgpt-share-server的environment下面添加以下两行:

```shell
RECORD_CONVERSATION: "true"
ALLOW_CHANGE_CAR_ON_429: "true"
```

<br>

##### 3.执行./deploy.sh，重启一下share

<br>

##### 4.反向代理配置：

- #### caddy：

```shell
你的域名.com www.你的域名.com {
    # 外挂用户端
    reverse_proxy /list 127.0.0.1:6777
    reverse_proxy /mall 127.0.0.1:6777
    reverse_proxy /me 127.0.0.1:6777
    # 外挂后端接口
    reverse_proxy /job/* 127.0.0.1:6777
    # 外挂后台
    reverse_proxy /myadmin* 127.0.0.1:6777
    # 代理商后台
    reverse_proxy /partner 127.0.0.1:6777
    # 其它请求均转发给原share端口
    reverse_proxy 127.0.0.1:8300
}
```
<br>

- #### 1panel openresty：

<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241016152934.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241016153013.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241016153505.png"/>

<br>

<span style="color:red">[注意]</span>配置前端请求路径/list的时候，匹配规则要改成=，否则会把share的换车、语音的js弄没掉，如图：

<img width=300px src="https://raw.githubusercontent.com/1198722360/picture/main/20241016153635.png"/>
<br>

/mall、/me等其它路径的匹配规则不需要改(默认为^~)，其它的如https等配置请自行处理

<br>

- #### 宝塔 nginx配置：

```shell
proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    location = /list {
        proxy_pass http://127.0.0.1:6777; # 外挂用户端
    }
    location /mall {
        proxy_pass http://127.0.0.1:6777; # 在线商城
    }
    location /me {
        proxy_pass http://127.0.0.1:6777; # 个人中心
    }
    location /job/ {
        proxy_pass http://127.0.0.1:6777; # 外挂后端接口
    }
    location /myadmin {
        proxy_pass http://127.0.0.1:6777; # 外挂后台
    }
    location /partner {
        proxy_pass http://127.0.0.1:6777; # 代理商后台
    }
    # 其它请求均转发给原share端口
    location / {
        proxy_pass http://127.0.0.1:8300;
    }
```

### Claude配置

Claude基于始皇的fuclaude，感谢始皇的小玩具

言归正传，需要准备一个额外域名，必须托管到cloudflare，否则无法实现计次。采用huggingface进行部署(免费，免服务器)。详细教程请查看：[https://github.com/1198722360/chatgpt-share-server-job/blob/main/FUCLAUDE.md](https://github.com/1198722360/chatgpt-share-server-job/blob/main/FUCLAUDE.md "https://github.com/1198722360/chatgpt-share-server-job/blob/main/FUCLAUDE.md")

- ### 可免费试用3天，免费帮部署、免费提供咨询服务！请联系作者vx: diagpt 
<img height="200px" src="https://raw.githubusercontent.com/1198722360/picture/main/20241002161540.png"/>

- ### 正式版授权费用：50r/月/授权码，一个授权码只能一个服务使用。在线下单：[https://075114.xyz](https://075114.xyz "https://075114.xyz")  一次付费享全部功能，不按功能额外收费。永久包更新！

### 其它说明
- chatgpt加号仍使用原xy后台进行添加。

- xy后台账号密码与本外挂二开后台相同