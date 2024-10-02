##### 1.注册huggingface并登录，并记好你的用户名。

##### 2.来到我的huggingface space，并复制我的space：[https://huggingface.co/spaces/xxsxx/fuclaude/tree/main](https://huggingface.co/spaces/xxsxx/fuclaude/tree/main "https://huggingface.co/spaces/xxsxx/fuclaude/tree/main")
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002163837.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002164504.png"/>

##### 3.访问网址： 你的用户名-fuclaude.hf.space，测试能否访问到你刚刚在hf上部署的fuclade。

##### 4.登录cloudflare，进入Workers 和 Pages，创建一个worker
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002165501.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002165645.png"/>

##### 5.点击编辑代码
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002165804.png"/>

##### 6.把这里的代码粘贴进去，把开头几行配置改成你自己的，然后点击部署：https://github.com/1198722360/chatgpt-share-server-job/blob/main/woker.txt
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002170524.png"/>

##### 7.来到KV，创建一个名为IP_EMAIL_MAP的命名空间。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002170944.png"/>

##### 8.进入你用来访问claude的域名进行配置
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002171134.png"/>

##### 9.在DNS配置中，添加一个CNAME类型，值为cloudflare.182682.xyz的记录(cloudflare.182682.xyz用于CNAME优选)。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002172318.png"/>

##### 10.来到左侧的Workers路由，添加一个路由，Worker选择刚才创建的那个。如下图所示：
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002171855.png"/>

##### 11.修改本项目中的application.yml，将fuclaude配置中的url改成你刚刚配的dns解析，password改成你worker里设置的password。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002173243.png"/>

##### 12.重新部署本项目，执行./deploy.sh。

## 如何添加claude账号？
##### 1.回到你刚刚在huggingface复制的space，点击files，点击Dockerfile
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002175500.png"/>

##### 2.临时将这里的false改为true，然后重启space
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002175645.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002180823.png"/>

##### 3.访问你的claude域名，会进入如下页面：
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002180027.png"/>

##### 4.用claude账号登录，或者输入一个没注册过的邮箱，能直接注册，但是需要国外手机接码。登录之后，访问 你的claude域名/api/auth/session，即可看到session。取到session之后，到后台加号即可。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002180654.png"/>

##### 5.加完号之后，一定要把第2步的配置改回false然后重启space。否则其他人能看到。session理论上是永久的。