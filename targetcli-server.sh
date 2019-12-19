#! /bin/bash
#####################ISCSI脚本################
#作者:liop
#完成时间:2019.10.7
#iscsi服务端搭建
##################################################
if [ $# -eq 0 ]; then
 echo "请输入要共享的磁盘" >&2
 exit 1
elif [ -e  "$1" ]; then
 echo "OK"
else
 echo "请确保它是一个磁盘,如/dev/vdb" >&2
 exit 2
fi
firewall-cmd --set-default-zone=trusted &> /dev/null
rpm -q targetcli &> /dev/null
if [ $? -ne 0 ]; then
 yum -y install targetcli &> /dev/null
fi
targetcli <<EOF
backstores/block create dev=$1 name=nsd2
exit
EOF
targetcli <<EOF
iscsi/ create iqn.2019-10.com.example:server0
iscsi/iqn.2019-10.com.example:server0/tpg1/luns create /backstores/block/nsd2
iscsi/iqn.2019-10.com.example:server0/tpg1/acls create iqn.2019-10.com.example:tc
iscsi/iqn.2019-10.com.example:server0/tpg1/portals create 0.0.0.0
exit
EOF
systemctl restart target
systemctl enable target
