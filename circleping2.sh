#! /bin/bash
#####################ping某一个网段脚本################
#作者:liop
#完成时间:2019.10.7
#ping一个网段的通断,并将最后结果导入fileurl的路径中
##################################################
my_arry=(0)
export my_arry
myping () {
	ping -c 3 -i 0.2 -W 1 $net.$1 &> /dev/null
	if [ $? -eq 0 ]; then
		echo "$1;1" >> 1.txt
	else
		echo "$1;0" >> 1.txt
	fi
}
i=1
echo -n '' > 1.txt
net="176.130.7"
if [ -n "$1" ]; then
	net="176.130.$1"
fi
fileurl="/home/student/桌面/shell文件/result${net}.txt"
echo "result:" > $fileurl
while  : 
do
	my_arry[$i]=0
	myping $i &
	((i++))
	if [ $i -eq 255 ]; then
		break
	fi
done
wait
#############################################
for i in `cat 1.txt`
do	
	array=(${i//;/ })
	int=${array[0]}
	[ ${array[1]} == '1' ] && my_arry[$int]="1" || my_arry[$int]="0"
done
rm -rf 1.txt
i=1
while :
do
	if [ ${my_arry[i]} == "1" ]
	then
		echo -n "$net.$i is YES    	" >> $fileurl
	else
		echo -n "$net.$i is NO     	" #>> $fileurl
	fi
	if [ $(($i % 4)) -eq 0 ]; then
		echo " " >> $fileurl
	fi
	((i++))
	if [ $i -eq 255 ]; then
		break
	fi
done
