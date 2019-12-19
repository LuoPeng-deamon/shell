#! /bin/bash
#####################http虚拟主机脚本################
#作者:liop
#完成时间:2019.10.7
#三个基于域名的虚拟主机的脚本,分别为server0.example.com,www0.example.com,webapp0.example.com
##################################################
yum -y install httpd
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
echo "<VirtualHost *:80>
 ServerName server0.example.com
 DocumentRoot /var/www/nsd01
</VirtualHost>
<VirtualHost *:80>
 ServerName www0.example.com
 DocumentRoot /var/www/nsd02
</VirtualHost>
<VirtualHost *:80>
 ServerName webapp0.example.com
 DocumentRoot /var/www/nsd03
</VirtualHost>" > /etc/httpd/conf.d/nsd01.conf
cd /var/www/
mkdir nsd01 nsd02 nsd03
echo '<h1>大圣归来' >nsd01/index.html
echo '<h1>大圣又归来' >nsd02/index.html
echo '<h1>大圣累了' >nsd03/index.html
systemctl restart httpd
