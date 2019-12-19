#! /bin/bash
#####################ftp自动下载脚本################
#作者:liop
#完成时间:2019.10.2
#自动从ftp上下载
#首次运行需要下载ftp软件包,需要root权限
#user 登录名 passwd 登录密码 (匿名登录时随意填写!)
##################################################
inf=`rpm -q ftp |grep ftp-`
if [ -z "$inf" ]; then
if [ $USER == 'root' ]; then

	yum -y install ftp

else
	echo "请确认你的用户是否为root(需安装ftp软件包,第一次运行时需要root权限)"
	exit
fi
else
if [ -e "/home/student/桌面/notenow" ]; then
echo "Ready!!!"
else
mkdir -p /home/student/桌面/notenow
fi
ftp -n -i 176.130.7.174 <<EOF

user anonymous passwd

binary

cd ./Shell笔记

lcd /home/student/桌面/notenow

mget *

bye

EOF

echo "Download from FTP successfully."

fi
