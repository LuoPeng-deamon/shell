#! /bin/bash
#####################nginx编译安装脚本################
#作者:liop
#完成时间:2019.11.5
#nginx编译安装
##################################################
echo 'install...'
yum -y install gcc openssl-devel pcre-devel &> /dev/null
echo 'complete!'
[ ! -e ./nginx-1.10.3.tar.gz ] && echo "找不到安装包!!" && exit 1
echo -n "解压安装中."
tar -xf nginx-1.10.3.tar.gz &> /dev/null
cd nginx-1.10.3
echo -n "."
./configure &> /dev/null
echo -n "."
make &> /dev/null
echo -n "."
make install &> /dev/null
echo ".."
echo "编译安装完成!!!"
echo "说明:
/usr/local/nginx/conf   配置文件目录
/usr/local/nginx/html   网站页面目录
/usr/local/nginx/logs   Nginx日志目录
/usr/local/nginx/sbin   主程序目录"

