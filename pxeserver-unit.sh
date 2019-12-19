#! /bin/bash
#####################PXE服务器自动搭建脚本################
#作者:liop
#完成时间:2019.10.25
#PXE自动装机
#######################################################
#-------------------------------------------配置文件-------------------------------------------------------------
local_repo="[development]
name=CentOS
baseurl=\"file:///var/www/html/centos\"
enabled=1
gpgcheck=0"
ks_cfg="#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
rootpw --iscrypted \$1\$j1w/nK42\$xaay9FRw/WxET6ZSg32Nu0
# Use network installation
url --url=\"http://192.168.4.120/centos\"
# System language
lang en_US
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use graphical install
graphical
firstboot --disable
# SELinux configuration
selinux --disabled

# Firewall configuration
firewall --disabled
# Network information
network  --bootproto=dhcp --device=eth0
# Reboot after installation
reboot
# System timezone
timezone Asia/Shanghai
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel
# Disk partitioning information
part / --fstype=\"xfs\" --grow --size=1

%post --interpreter=/bin/bash
echo 'hello world'
%end

%packages
@base

%end"
dhcp_conf="#
# DHCP Server Configuration file.
#   see /usr/share/doc/dhcp*/dhcpd.conf.example
#   see dhcpd.conf(5) man page
#
subnet 192.168.4.0 netmask 255.255.255.0 {
  range 192.168.4.100 192.168.4.200;
  option domain-name-servers 192.168.4.7;
  option routers 192.168.4.254;
  next-server 192.168.4.120;
  filename \"pxelinux.0\";
  default-lease-time 600;
  max-lease-time 7200;
}
"
default_file="label linux
  menu label ^Install CentOS 7
  menu default
  kernel vmlinuz
  append initrd=initrd.img ks=http://192.168.4.120/ks.cfg
"
#-------------------------------------------地址(ip)配置--------------------------------------------------------
read -p '是否要重置本机ip:(y/n)' is_reset
if [ ${is_reset} == "y" ]; then
 read -p '请输入ip地址:' ipaddress
 nmcli connection modify eth0 ipv4.method manual ipv4.addresses ${ipaddress}/24 connection.autoconnect yes
 nmcli connection up eth0
 ippart=`echo ${ipaddress} | sed 's/\.[0-9]\{1,3\}$//g'`
# nmcli connection up eth0
elif [ ${is_reset} == "n" ]; then
 ipaddress=`ifconfig eth0 | grep 'inet' | sed 's/^.*inet//g' | sed 's/netmask.*$//g' | sed 's/[[:space:]]//g'`
 ippart=`echo ${ipaddress} | sed 's/\.[0-9]\{1,3\}$//g'`
 echo "本机ip为:$ipaddress"
else
 echo 'y/n' >&2
 exit 1
fi
#------------------------------------------------光盘挂载------------------------------------------------------------
     mkdir -p /var/www/html/centos
     mount /dev/cdrom /var/www/html/centos/
#------------------------------------------------安装软件包---------------------------------------------------------
#echo 'server.example.com' > /etc/hostname
echo "${local_repo}" > /etc/yum.repos.d/local.repo 
     yum clean all
     yum repolist 
     yum -y install httpd
     yum -y install dhcp
     yum -y install tftp-server
#     yum -y install system-config-kickstart
     systemctl enable httpd.service 
     systemctl enable dhcpd
     systemctl enable tftp
     mkdir /var/lib/tftpboot/pxelinux.cfg

#---------------------------------------------------配置----------------------------------------------------------------
     echo "${dhcp_conf}" | sed 's/192\.168\.4/'"$ippart"'/g' | sed 's/'"$ippart"'\.120/'"$ipaddress"'/g'> /etc/dhcp/dhcpd.conf 
#     yum provides */pxelinux.0
     yum -y install syslinux
     cp /usr/share/syslinux/pxelinux.0 /var/lib/tftpboot/
#cd /var/www/html/centos/isolinux/
     cp /var/www/html/centos/isolinux/initrd.img /var/www/html/centos/isolinux/vesamenu.c32 /var/www/html/centos/isolinux/splash.png /var/lib/tftpboot/
#cd /var/lib/tftpboot/
     cp /var/www/html/centos/isolinux/vmlinuz /var/lib/tftpboot/
#    system-config-kickstart 
#    LANG=en system-config-kickstart
    head -60 /var/www/html/centos/isolinux/isolinux.cfg > /var/lib/tftpboot/pxelinux.cfg/default 
    echo "${default_file}" | sed 's/192\.168\.4\.120/'"$ipaddress"'/g' >> /var/lib/tftpboot/pxelinux.cfg/default 
    echo "${ks_cfg}" | sed 's/192\.168\.4\.120/'"$ipaddress"'/g' > /var/www/html/ks.cfg
#----------------------------------------------------起服务------------------------------------------------------------------
#    vim /var/lib/tftpboot/pxelinux.cfg/default
    systemctl restart httpd.service 
    systemctl restart dhcpd
    systemctl restart tftp
    nmcli connection up eth0

