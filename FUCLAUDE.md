##### 1.登录cloudflare，来到KV，创建一个名为IP_EMAIL_MAP的命名空间。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002170944.png"/>

##### 2.进入Workers 和 Pages，创建一个worker
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002165501.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002165645.png"/>

##### 3. 进入这个woker，给它绑定第1步的KV
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241017002848.png"/>

##### 4.编辑worker代码，把这里的代码粘贴进去，把前两行代码中password、shareUrl改成你自己的，然后点击部署
https://github.com/1198722360/chatgpt-share-server-job/blob/main/woker.txt
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002170524.png"/>


##### 5.进入你用来访问claude的域名进行配置
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002171134.png"/>

##### 6.在DNS配置中，添加一个CNAME类型，值为cloudflare.182682.xyz的记录(cloudflare.182682.xyz用于CNAME优选)。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002172318.png"/>

##### 7.来到左侧的Workers路由，添加一个路由，Worker选择刚才创建的那个。如下图所示：
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002171855.png"/>

##### 8.修改本项目中的application.yml，将fuclaude配置中的url改成你刚刚配的dns解析，password改成你worker里设置的password。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002173243.png"/>

##### 9.重新部署本项目：

docker compose down

./deploy.sh。

## 如何添加claude账号？
##### 方法1：直接买带session的claude号，前往/myadmin加号

##### 方法2：到claude官网登录账号，按f12，在这个位置找到session key，复制下来，然后到/myadmin加号
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241017003738.png"/>


##### 方法3：自己部署一个fuclaude，并开启显示session，具体步骤如下：

##### 1.注册huggingface并登录，
<span style="color:red">并记好你的用户名</span>。

##### 2.来到我的huggingface space，并复制我的space：[https://huggingface.co/spaces/xxsxx/fuclaude/tree/main](https://huggingface.co/spaces/xxsxx/fuclaude/tree/main "https://huggingface.co/spaces/xxsxx/fuclaude/tree/main")
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002163837.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002164504.png"/>

##### 3.回到你刚刚在huggingface复制的space，点击files，点击Dockerfile
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002175500.png"/>

##### 4.将这里的false改为true，然后重启space
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002175645.png"/>
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002180823.png"/>

##### 5.访问网址： 你的用户名-fuclaude.hf.space，会进入如下页面：
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002180027.png"/>

##### 6.用claude账号登录，或者输入一个没注册过的邮箱，能直接注册，但是需要国外手机接码。登录之后，访问 你的用户名-fuclaude.hf.space/api/auth/session，即可看到session。
<img src="https://raw.githubusercontent.com/1198722360/picture/main/20241002180654.png"/>

<span style="color:red">[注意]你现在的cf woker里面反代的是我部署的fuclaude，你可以选择把他改成你自己的fuclaude( cf worker的第三行代码改成你的用户名-fuclaude.hf.spacef )，如果改了的话，取完session必须把第4步的true改回false然后重启space，否则用户也能访问/api/auth/session导致你的真实session泄露。由于我的space关了显示真实session，因此你可以选择直接用我的，只不过取session的时候要到你自己的fuclaude去取。</span>