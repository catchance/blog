---
title: VPN和Socks5代理翻墙
toc: true
tags: ["VPN", "翻墙"]
categories: ["翻墙"]
date: 2017-6-3 10:14:48 +08:00
draft: true
---
> Vpn的搭建
> 翻墙技术的实现

<!--more-->  

### 参考文献
- [Ubuntu 下配置 PPTP，IPSec 和 Shadowsocks](http://blog.jimmyis.in/ubuntu-pptp-ipsec-shadowsocks/)

### socks5代理
---
Socks5代理是基于Socks（防火墙安全会话转换协议）协议的一种代理模式。其中，5表示该协议的版本号。它可以让局域网的计算机通过socks5代理服务器，访问外网的内容。由于它工作在传输层，所以支持TCP和UDP的数据传输。
Socks5代理支持多种认证模式，以确认客户端的身份，可以提供较高的安全等级。常见的软件中，openSSH和ShadowSocks都支持Socks5代理模式。
在渗透测试中，通过Socks5代理模式，可以绕开防火墙的限制，传输各种数据，适合跨网渗透。

#### SSH Tunnel隧道转发,使用socks5代理实现翻墙
SSH是一种安全的传输协议，用在连接服务器上比较多。不过其实除了这个功能，它的隧道转发功能更是吸引人。
- 可以访问外网的服务器一台（aws、阿里云、openshift、vps...）
- 客户端可以使用ssh与服务器连接（linxu、mac直接使用ssh windows使用xshell、putty等等）建立隧道设置socks5代理  
  1. Linux
  ```bash
  # -f 输入密码后进入后台模式
  # -N 不执行远程命令,用于端口转发
  # -D socket5代理
  # -L tcp转发
  # -C 使用数据压缩,网速快时会影响速度
  # -i 证书
  # bindaddress ：指定绑定ip地址
  # port ： 指定侦听端口
  # name： ssh服务器登录名
  # server： ssh服务器地址
  $ ssh -f -N -D bindaddress:port name@server  
  $ ssh -f -N -D 127.0.0.1:8888 -i "xxx.pem" name@server
  ```
  2. Windows  
    xshell建立隧道自行搜索  
    putty建立隧道自行搜索  

- 使用
  1. firefox  
    设置 > 高级 > 网络 > 设置  
    填写socks主机，选择Socks v5
  2. chrome 使用SwitchySharp插件配置代理

#### Shadowsocks
[Shadowsocks](https://github.com/shadowsocks) 是一个安全的socks5代理，用于保护网络流量，是一个开源项目。
> [wiki](https://github.com/shadowsocks/shadowsocks/wiki)  
> [参考](https://wiki.archlinux.org/index.php/Shadowsocks_(简体中文)  
> [使用Shadowsocks及Polipo转换HTTP代理](http://www.jianshu.com/p/0a778e6874f1)

**服务端程序配置**
- Step 1 安装shadowsocks服务端程序
```bash
# ubuntu 16.04安装方式
$ sudo apt-get shadowsocks
```
- Step 2 配置 Shadowsocks
```bash
# /etc/shadowsocks/config.json
# 服务端配置0.0.0.0就好了
{  
    "server" : "域名或服务器ip",  
    "server_port" : 443,  
    "local_port" : 1080,  
    "password" : "密码",  
    "timeout" : 600,  
    "method" : "aes-256-cfb",    
    "fast_open" : false,
    "workers" : 1
}
```
> 注：配置文件可以在任意目录，配置文件名也可以随意。
- Step 3 安装 M2Crypto 来提高加密速度
`apt-get install python-m2crypto`
- Step 4 - 在后台启停 Shadowsocks
```bash
# 启动 sudo ssserver -c /etc/shadowsocks/config.json -d start
# 停止 sudo ssserver -c  /etc/shadowsocks/config.json -d stop
# 重启 sudo ssserver -c  /etc/shadowsocks/config.json -d restart
# 若不想加载config.json，可手动运行：
# ssserver -s 监听地址(通常为0.0.0.0) -p 监听端口 -k 密码 -m 加密方法 -t 超时时间（秒）
$ nohup ssserver -s 0.0.0.0 -p 443 -k a29rw4pacnj2ahmf -m aes-256-cfb -t 600 > log &
$ sudo nohup ssserver -c /etc/shadowsocks/config.json &
```

** 客户端程序**
- Mac os
[ShadowsocksX](https://sourceforge.net/projects/shadowsocksgui/)
- Ios
Wingy

### VPN
---

#### PPTP方式（基于AWS VPC ubuntu 16.04）
  > [使用pptpd搭建VPN](https://www.mawenbao.com/note/pptpd.html)  
  > [如何在AWS(基于Amazon Linux)上搭建PPTP VPN](http://blog.csdn.net/kevinojt/article/details/42486839)  

- Step 1 安装pptpd
```bash
$ apt-get install pptpd
```
- Step 2 修改pptpd的配置文件 /etc/pptpd.conf
```bash
localip 192.168.0.1
remoteip 192.168.0.234-238,192.168.0.245
```
- Step 3 修改PPPD DNS配置 /etc/ppp/pptpd-options
```bash
# Google的Public DNS:
ms-dns 8.8.8.8
ms-dns 8.8.4.4
# 修改日志输出位置 需要注意的是，pptpd依然会写系统日志。
logfile /var/log/ppp.log
```
- Step 4 设置VPN用户名和密码 /etc/ppp/chap-secrets
```bash
# * 表示所有IP都可以访问
# 用户名 pptpd 密码 ip
xiaoming pptpd 123 *
```
- Step 5 设置iptables规则
```bash
$ iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
$ iptables -A INPUT -i eth0 -p gre -j ACCEPT
$ iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j  MASQUERADE
# 配置filter表的规则
$ iptables -A FORWARD-i ppp+ -o eth0 -j ACCEPT
$ iptables -A FORWARD-i eth0 -o ppp+ -j ACCEPT
$ service iptables save
$ service iptables restart
# 用命令 iptables -t nat -vnL POSTROUTING 可查看到刚刚在 NAT 表 POSTROUTING 规则链中添加的规则
$ iptables -t nat -vnL POSTROUTING
```
- Step 6 修改sysctl.conf
```bash
# 修改/etc/sysctl.conf
net.ipv4.ip_forward=1
# 重新加载sysctl.conf:
$ sysctl -p
```
- Step 7 重启pptpd服务
```bash
service pptpd restart
service pppd-dns restart
```
- Step 8 配置AWS EC2的网络安全策略  
VPN需要開防火牆的TCP Port 1723 及 IP Protocol GRE(47)
IP Protocol GRE(47) 並不是指要開TCP/UDP 47 Port，而是指VPN Pass Through的功能
登录AWS控制台，在NETWORK& SECURITY的Security Groups里选择需要修改的Security Group
分别在Inbound和Outbound里开通TCP Port 1723 及 IP Protocol GRE(47) 配置
选择刚才安装PPTPD的实例，应用刚才配置的Security Group

#### IPSec/IKEv2 VPN（基于AWS VPC ubuntu 16.04）
> [使用 Strongswan 架设 Ipsec VPN](http://blog.csdn.net/zzsfqiuyigui/article/details/39533479)  
> [StrongSwan 搭建IPsec (IKEv1 and IKEv2)科学上网，Google、Facebook、Youtube等](http://www.jianshu.com/p/5ef779631ea0)  
> [香港云主机CentOS系统上安装strongSwan搭建IPsec VPN服务器](http://bbs.pceva.com.cn/thread-130112-1-1.html)

- Step 1 安装 strongswan 5.3.5
```bash
$ sudo apt-get install Strongswan
```
- Step 2 生成私钥和根证书,并且根证书使用的是自签名形式
```bash
# 这里C表示国家名,O表示组织单位，CN表示通用名字
$ ipsec pki --gen --outform pem > ca.key.pem
$ ipsec pki --self --in ca.key.pem --dn "C=CN, O=MyStrongSwan, CN=MyStrongSwan CA" --ca --lifetime 3650 --outform pem > ca.cert.pem
```
- Step 3 生成服务器证书
```bash
$ ipsec pki --gen --outform pem > server.key.pem
$ ipsec pki --pub --in server.key.pem --outform pem > server.pub.pem
# 服务器这边的CN一定是你网卡的ip，或者你网卡ip对应的域名
# -san 设置设置别名，建议设置两个或者两个以上，分别为你的域名和网卡ip
# –flag serverAuth 表示证书使用用途，不加windows 7会报错
# 非 iOS 的 Mac OS X 要求了“IP 安全网络密钥互换居间（IP Security IKE Intermediate）”这种增强型密钥用法（EKU），–flag ikdeIntermediate;
$ ipsec pki --issue --lifetime 1200 --cacert ca.cert.pem --cakey ca.key.pem --in server.pub.pem --dn "C=CN, O=MyStrongSwan, CN=myDomain.com" --san="myDomain.com" --san="YourIP" --flag serverAuth --flag ikeIntermediate --outform pem > server.cert.pem
```
- Step 4 生成客户端证书 （可选）
```bash
$ ipsec pki --gen --outform pem > client.key.pem
$ ipsec pki --pub --in client.key.pem --outform pem > client.pub.pem
$ ipsec pki --issue --lifetime 1200 --cacert ca.cert.pem --cakey ca.key.pem --in client.pub.pem --dn "C=CN, O=MyStrongSwan, CN=MyDomain.com" --outform pem > client.cert.pem
#以下生成证书需要密码地，请设置密码，因为MAC不能导入密码为空的证书
$ openssl pkcs12 -export -inkey client.key.pem -in client.cert.pem -name "MyStrongSwan Client Cert" -certfile ca.cert.pem -caname "MyStrongSwan CA" -out client.cert.p12
```
- Step 5 安装证书
```bash
$ sudo cp -r ca.key.pem /etc/ipsec.d/private/
$ sudo cp -r ca.cert.pem /etc/ipsec.d/cacerts/
$ sudo cp -r server.cert.pem /etc/ipsec.d/certs/
$ sudo cp -r server.key.pem /etc/ipsec.d/private/
$ sudo cp -r client.cert.pem /etc/ipsec.d/certs/
$ sudo cp -r client.key.pem /etc/ipsec.d/private/
```
- Step 6 配置ipsec.conf
```bash
# /etc/ipsec.conf
config setup
    uniqueids=never #关闭ID唯一性，即允许多个客户端使用同一个证书，多设备同时在线
conn %default #默认配置项，其他conn配置项都会调用此默认项
    compress = yes
    ike=aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes256-aes128-sha256-sha1-modp2048-modp4096-modp1024,aes256-sha1-modp1024,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16-aes256gcm12-aes128gcm16-aes128gcm12-sha256-sha1-modp2048-modp4096-modp1024,3des-sha1-modp1024!
    esp=aes128-aes256-sha1-sha256-modp2048-modp4096-modp1024,aes128-sha1,aes128-sha1-modp1024,aes128-sha1-modp1536,aes128-sha1-modp2048,aes128-sha256,aes128-sha256-ecp256,aes128-sha256-modp1024,aes128-sha256-modp1536,aes128-sha256-modp2048,aes128gcm12-aes128gcm16-aes256gcm12-aes256gcm16-modp2048-modp4096-modp1024,aes128gcm16,aes128gcm16-ecp256,aes256-sha1,aes256-sha256,aes256-sha256-modp1024,aes256-sha256-modp1536,aes256-sha256-modp2048,aes256-sha256-modp4096,aes256-sha384,aes256-sha384-ecp384,aes256-sha384-modp1024,aes256-sha384-modp1536,aes256-sha384-modp2048,aes256-sha384-modp4096,aes256gcm16,aes256gcm16-ecp384,3des-sha1!
    keyexchange = ike
    keyingtries = 1
#for andorid、ios、mac
conn cisco_xauth_psk
    left = %any # 服务器端标识,%any表示任意
    leftid = YourIP or Domain # 服务器端ID标识
    leftauth = psk # 服务器校验方式，使用证书 psk/pubkey/...
    leftfirewall = yes #
    fragmentation = yes #
    leftsubnet = 0.0.0.0/0 #服务器端虚拟ip, 0.0.0.0/0表示通配.
    right = %any # 客户端标识，%any表示任意  
    rightauth = psk # 客户端校验方式，使用证书
    rightauth2 = xauth # 客户端校验方式，使用证书
    rightsourceip = 172.16.6.0/24 # 客户端IP地址分配范围  
    rekey = no
    auto = add     
    dpdaction=clear
#for windows 7/10 , strongswan agent and other ca
conn IKEv2-EAP-Windows
    leftca = "C=CN, O=,MyStrongSwan; CN=YourIP or domain"
    leftcert = server.cert.pem
    leftsendcert = always
    rightsendcert = never
    leftid = YourIP or domain
    left = %any
    right = %any
    leftauth = pubkey   #使用证书形式认证
    rightauth = eap-radius  #认证使用radius
    leftfirewall = yes
    leftsubnet = 0.0.0.0/0  #全部流量走vpn
    rightsourceip = 172.16.7.0/24
    fragmentation = yes  #包重组
    eap_identity = %any
    rekey = no    #不重复检查，用来开启多设备登录
    auto = add
    dpdaction=clear    #断开后清空
```
- Step 7 配置 strongswan.conf
```bash
# /etc/strongswan.conf
charon {
   #配置strongSwan日志级别和路径
    filelog {
               /var/log/strongswan.charon.log {
                   time_format = %b %e %T
                   default = 2
                   append = no
                   flush_line = yes
               }
       }
    load_modular = yes
    duplicheck.enable = no #是为了你能同时连接多个设备，所以要把冗余检查关闭
    compress = yes  #传输启用压缩
    plugins {
        include strongswan.d/charon/*.conf
    }
    dns1 = 8.8.8.8  #给远程端指定DNS服务器
    dns2 = 223.5.5.5
#only for windows
    nbns1 = 8.8.8.8 #指定Windows的WINS服务器
    nbns2 = 223.5.5.5
}
include strongswan.d/*.conf
```
- Step 8 配置 ipsec.secrets
```bash
: RSA server.key.pem
: PSK "visionsrv"
: XAUTH "visionsrv"
 myvpn %any : EAP "123456"
```
- Step 9 配置Firewall和转发
```bash
# 开放端口 firewall方式
firewall-cmd --add-port=500/tcp --permanent
firewall-cmd --add-port=500/udp --permanent
firewall-cmd --add-port=4500/tcp --permanent
firewall-cmd --add-port=4500/udp --permanent
firewall-cmd --add-masquerade --permanent
firewall-cmd --reload
# 编辑 /etc/systcl.conf
net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
# 开启 firewall的转发功能
iptables -t nat -A POSTROUTING -s 172.16.6.0/24 -o ens160 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 172.16.7.0/24 -o ens160 -j MASQUERADE
# iptables配置
sudo iptables -A INPUT -p udp --dport 500 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 4500 -j ACCEPT
sudo iptables -t nat -A POSTROUTING -s 172.16.7.0/24 -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -s 172.16.7.0/24 -j ACCEPT

```
- Step 10 启动服务
```bash
ipsec start
systemctl restart strongswan
# 设置服务开启启动
sudo systemctl enable strongswan.service
# 开始服务
sudo systemctl start strongswan.service
```
