#! /bin/bash
#####################ping某一个网段脚本################
#作者:liop
#完成时间:2019.10.7
#ping一个网段的通断,并将最后结果导入fileurl的路径中
##################################################
i=1
net="176.130.7"
if [ -n "$1" ]; then
	net="176.130.$1"
fi
fileurl="/home/student/桌面/shell文件/result${net}.txt"
echo "result:" > $fileurl
while  : 
do
	result=`ping -c 3 -i 0.2 -W 1 $net.$i |grep rtt`
	if [ -n "$result" ]; then
		echo -n "$net.$i is YES    	" >> $fileurl
	else
		echo -n "$net.$i is NO     	" >> $fileurl
	fi
	if [ $(($i % 4)) -eq 0 ]; then
		echo " " >> $fileurl
	fi
	((i++))
	if [ $i -eq 255 ]; then
		break
	fi
done
