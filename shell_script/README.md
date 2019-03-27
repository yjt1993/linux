脚本说明：
getIpHostname.sh：从远程服务器获取主机名，并且与该主机对应的ip地址一一对应，在当前主机生成hosts文件，后续可以上传到所有服务器的/etc/下面。需要ip.txt文件
ip.txt:所有远程主机的ip地址列表。一行一个ip地址
setSshkey.sh：当主机之间不能免密登录的时候，该脚本可以用于使主机之间相互免密。需要ip.txt文件。

注意：
执行上述脚本的时候，需要系统安装expect软件
expect安装方式：
(1)、yum安装：  yum install -y expect
(2)、源码安装：官网下载相应的expect和tcl(源码安装需要同时安装tcl，expect是基于tcl的)软件包，解压安装。
