#! /bin/bash
firewall-cmd --set-default-zone=trusted &> /dev/null
rpm -q iscsi-initiator-utils &> /dev/null
if [ $? -ne 0 ]; then
 yum -y install iscsi-initiator-utils &> /dev/null
fi
echo 'InitiatorName=iqn.2019-10.com.example:tc' > /etc/iscsi/initiatorname.iscsi
systemctl restart iscsid
iscsiadm --mode discoverydb --type sendtargets --portal 172.25.0.11 --discover
systemctl restart iscsi
