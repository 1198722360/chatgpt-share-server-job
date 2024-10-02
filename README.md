# chatgpt-share-server-job
#### 未改主体的可高度自定义的xyhelper旗下的chatgpt-share-server二开。集注册、登录、在线下单、分离plus会员/普通会员、集成claude并获取剩余次数、邀请返利机制、二级分销系统、优惠券发放、激活码发放、公告管理、虚拟车队、审计限流等实用功能于一体。

#### 预览
前端地址：[demo.075114.xyz](https://demo.075114.xyz "demo.075114.xyz")
后台地址：[demo.075114.xyz/myadmin](https://demo.075114.xyz/myadmin "demo.075114.xyz/myadmin")

## 功能说明
1.注册登录：可选阿里云短信发验证码，或邮箱发验证码。后台可以配置新用户赠送优惠券、plus激活码、普通激活码。 已实现邮箱白名单，有效避免用户白嫖。

2.一个用户绑定两个初始UserToken，一个为plus的，一个为普通的，有不同的到期时间。续费或使用激活码会将这两个UserToken上延期，从而保留老对话记录。

3.在线商城：支持支付宝当面付，生成下单二维码，用户可支付宝扫码下单。并可使用优惠券。

4.个人中心：用户可以导入、使用激活码。并可以看到以前导入过的激活码，方便售后。

5.<span style="color:red;">邀请返利</span>：后台设置邀请返利百分比，被邀请者购买后，邀请者获得一定时长的返利。

6.<span style="color:red;">Claude集成</span>：目前不支持单独售卖Claude，Plus会员可使用。已实现了<span style="color:red;">剩余次数记录</span>。

7.<span style="color:red;">二级分销</span>：在后台添加一个分销商账号，并设置对应的域名。在Caddy或Nginx中对这个域名配置一个和主站相同的解析。 分销商可以通过/partner进入管理页，可自定义公告、商品价格(相对于主站的倍数)、收款码等，用户进入分站时，<span style="color:red">显示的是分站的公告、价格</span>。 站长在/myadmin后台可以设置分站返额比例，并向分销商结款。

8.**优惠券发放**：可以设置折扣、门槛、过期时间。可以配置注册赠送优惠券，可以手动向用户发放优惠券、或批量发放优惠券。

9.**激活码发放**：可以指定时长、是否plus、获得方式，向单个用户或指定人群(plus会员、普通会员、非会员、全部人)发放激活码。

10.**激活码生成**：指定时长、是否plus、获得方式批量生成**未使用的**激活码，一键导出，可用于发卡网。

11.公告配置：除了弹窗公告，其它公告均支持element plus标签、html标签、或文本，高度自定义，对非编程人员不友好，可以复制演示站后台的公告，让GPT帮忙修改、或只替换关键部分。

12.<span style="color:red;">虚拟车队</span>：可分别指定plus号的虚拟车数量、普号的虚拟车数量。以假乱真，1个号变100个号。

13.反监管功能：开启后不登录只显示账号列表，隐藏在线商城。上次被阿里云抽查到了，封了域名，要求我整改或备案。我跟客服扯了一晚上保证这保证那才给我解开。后来不知道是不是开启隐藏商店的原因，再也没找过我。🫥如果给查到，可以开启这个功能半个月，等检查的走了，再关闭。

14.<span style="color:red;">超强限流器</span>：可分别对普通会员、plus会员的任意模型进行分组次数限制。

#### 部署教程
&emsp;&emsp;首先确保部署了原版chatgpt-share-server(直达连接：[https://chatgpt-share-server.xyhelper.cn/install](https://chatgpt-share-server.xyhelper.cn/install "https://chatgpt-share-server.xyhelper.cn/install"))，或者没有改动过原share数据库表的二开。<span style="color:red;">需要将原share的docker-compose.yml中的AUDIT_LIMIT_URL改成
```yaml
http://chatgpt-job:6777/audit_limit
```
</span>
<div style="text-align:center">
<img  src="https://raw.githubusercontent.com/1198722360/picture/main/1727844465259.jpg"/ height="300px">
</div>