#! /bin/bash
#####################切换壁纸脚本##############################################
#作者:liop
#完成时间:2019.12.16
#tomcat安装
#请保证你提供的安装包是有效的
#############################################################################
read -p "请输入tomcat安装包路径:" tar_url
if [ ! -f ${tar_url} ]; then
	echo "输入的路径有误!" >&2
	exit 1
fi
tar -xf ${tar_url} -C ~ || unzip ${tar_url} -d ~
if [ $? -ne 0 ]; then
	echo "安装包有误,无法解压!" 
	exit 2
fi
dir_url=`echo "${tar_url}" | awk -F/ '{print $NF}' | sed -r 's/(.*)(\.tar|\.zip)(.*)/\1/'`
echo "installing...."
yum -y install java-1.8.0-openjdk java-1.8.0-openjdk-headless &> /dev/null
mv ~/${dir_url} /usr/local/tomcat
if [ ! -e "/dev/random.bak" ];then
	mv /dev/random /dev/random.bak
	ln -s /dev/urandom /dev/random
fi
echo "finished!"
echo "start tomcat...."
/usr/local/tomcat/bin/startup.sh
echo "finished!"
#------------------------------华丽的分割线------------------------

