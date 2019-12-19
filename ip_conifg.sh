#! /bin/bash
#####################链路聚合脚本################
#作者:liop
#完成时间:2019.10.7
#链路聚合
##################################################
ifconfig > test.txt
grep 'flag' test.txt > test2.txt
a=`sed -r 's/^(.*):(.*?)/\1/' test2.txt`
read -p '请为team网卡取个名:' team
read -p '请设置ip地址:' ip
echo '请从其中选出你要作为成员的网卡:'
echo $a
read -p 'slave1:' slave1
read -p 'slave2:' slave2
nmcli connection add type team con-name ${team} ifname ${team} autoconnect yes config '{"runner": {"name": "activebackup"}}'
nmcli connection add type team-slave con-name ${team}-1 ifname ${slave1} autoconnect yes master ${team}
nmcli connection add type team-slave con-name ${team}-2 ifname ${slave2} autoconnect yes master ${team}
nmcli connection modify ${team} ipv4.method manual ipv4.addresses "${ip}/24" connection.autoconnect yes

nmcli connection up ${team}
nmcli connection up ${team}-1
nmcli connection up ${team}-2

teamdctl ${team} state
