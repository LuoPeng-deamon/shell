#! /bin/bash
#
#
#
#
#
#基于域名的虚拟主机
virtualweb () {
	baseconf="#基于ServerName server0.example.com的虚拟主机 \n<VirtualHost *:80> \nServerName \nserver0.example.com \nDocumentRoot /var/www/nsd01 \n</VirtualHost>
"
	newconf="`echo $baseconf | sed 's/ServerName server0\.example\.com/ServerName '"$1"'/g'`"
	newconf2="`echo $newconf | sed 's/DocumentRoot \/var\/www\/nsd01/DocumentRoot  \/var\/www\/'"$2"'/g'`"
	mkdir /var/www/$2
	echo -e "$newconf2" >> /etc/httpd/conf.d/liop01.conf
	
}
#安装httpd软件包
yum -y install httpd mod_ssl mod_wsgi
rpm -q httpd mod_ssl mod_wsgi
if [ $? -eq 0 ] 
then
	echo "软件包安装成功" 
else
	echo "软件包安装失败" 
	exit 1
fi
while :
do
	echo "服务名称:
	1.基于域名的虚拟主机
	2.安全加密的web服务
	3.动态web服务"
	read -p "请选择你要安装的服务(1-3,退出q):" n
	case $n in
	1)
		read -p "请输入虚拟主机的域名:" virtual
		read -p "请输入网页存放位置的名称:" droot
		virtualweb $virtual $droot ;;
	2)
		read -p "请输入要安全加密的域名:" wsecuare
		read -p "请输入SSLCertificateFile秘钥位置:" SSLCertificateFile
		read -p "请输入SSLCACertificateFile秘钥位置" SSLCACertificateFile
		read -p "请输入SSLCertificateKeyFile公钥位置" SSLCertificateKeyFile
		sed -i 's/SSLCertificateFile \/etc\/pki\/tls\/certs\/localhost.crt/SSLCertificateFile '"$SSLCertificateFile"''
		sed -i 's/#SSLCACertificateFile \/etc\/pki\/tls\/certs\/ca-bundle.crt/SSLCACertificateFile '"$SSLCACertificateFile"''
		sed -i 's/SSLCertificateKeyFile \/etc\/pki\/tls\/private\/localhost.key/SSLCertificateKeyFile '"$SSLCertificateKeyFile"''
		sed -i 's/#ServerName www.example.com:443/ServerName '"$wsecure"':443/g' /etc/httpd/conf.d/ssl.conf
		sed -i 's/#DocumentRoot "\/var\/www\/html"/DocumentRoot "\/var\/www\/html"/g' /etc/httpd/conf.d/ssl.conf ;;
	3)
		
		echo "正在建设中...";;
	q)
		break ;;
	*)
		continue
	esac
	systemctl restart httpd
done
