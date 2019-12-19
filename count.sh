#! /bin/bash
#####################倒计时################
#作者:liop
#完成时间:2019.12.17
#三位数以内秒数的倒计时
##########################################
display(){
 case $1 in
   1)
	case $2 in
	1)
		echo "********     ";;
	2)
		echo "********     ";;
	3)
		echo "     ***     ";;
	4)
		echo "     ***     ";;
	5)
		echo "     ***     ";;
	6)
		echo "     ***     ";;
	7)
		echo "     ***     ";;
	8)
		echo "     ***     ";;
	9)
		echo "     ***     ";;
	10)
		echo "     ***     ";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
   2)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "          ***";;
	4)
		echo "          ***";;
	5)
		echo "          ***";;
	6)
		echo "*************";;
	7)
		echo "*************";;
	8)
		echo "***          ";;
	9)
		echo "***          ";;
	10)
		echo "***          ";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
   3)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "          ***";;
	4)
		echo "          ***";;
	5)
		echo "          ***";;
	6)
		echo "*************";;
	7)
		echo "*************";;
	8)
		echo "          ***";;
	9)
		echo "          ***";;
	10)
		echo "          ***";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
  4)
	case $2 in
	1)
		echo "***       ***";;
	2)
		echo "***       ***";;
	3)
		echo "***       ***";;
	4)
		echo "***       ***";;
	5)
		echo "***       ***";;
	6)
		echo "*************";;
	7)
		echo "*************";;
	8)
		echo "          ***";;
	9)
		echo "          ***";;
	10)
		echo "          ***";;
	11)
		echo "          ***";;
	12)
		echo "          ***";;
	*)
		echo ""
	esac;;
   5)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "***          ";;
	4)
		echo "***          ";;
	5)
		echo "***          ";;
	6)
		echo "*************";;
	7)
		echo "*************";;
	8)
		echo "          ***";;
	9)
		echo "          ***";;
	10)
		echo "          ***";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
   6)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "***          ";;
	4)
		echo "***          ";;
	5)
		echo "***          ";;
	6)
		echo "*************";;
	7)
		echo "*************";;
	8)
		echo "***       ***";;
	9)
		echo "***       ***";;
	10)
		echo "***       ***";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
   7)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "          ***";;
	4)
		echo "          ***";;
	5)
		echo "          ***";;
	6)
		echo "          ***";;
	7)
		echo "          ***";;
	8)
		echo "          ***";;
	9)
		echo "          ***";;
	10)
		echo "          ***";;
	11)
		echo "          ***";;
	12)
		echo "          ***";;
	*)
		echo ""
	esac;;
   8)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "***       ***";;
	4)
		echo "***       ***";;
	5)
		echo "***       ***";;
	6)
		echo "*************";;
	7)
		echo "*************";;
	8)
		echo "***       ***";;
	9)
		echo "***       ***";;
	10)
		echo "***       ***";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
   9)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "***       ***";;
	4)
		echo "***       ***";;
	5)
		echo "***       ***";;
	6)
		echo "*************";;
	7)
		echo "*************";;
	8)
		echo "          ***";;
	9)
		echo "          ***";;
	10)
		echo "          ***";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
   0)
	case $2 in
	1)
		echo "*************";;
	2)
		echo "*************";;
	3)
		echo "***       ***";;
	4)
		echo "***       ***";;
	5)
		echo "***       ***";;
	6)
		echo "***       ***";;
	7)
		echo "***       ***";;
	8)
		echo "***       ***";;
	9)
		echo "***       ***";;
	10)
		echo "***       ***";;
	11)
		echo "*************";;
	12)
		echo "*************";;
	*)
		echo ""
	esac;;
   *)
	echo ''
   esac
}
#for i in {1..12}
#do
#	echo "$(display 1 $i)     $(display 2 $i)     $(display 3 $i)"
#done

c1=$[$1%10]
if [ $1 -gt 99 ];then
	c2=$[$[$1/10]%10]
	c3=$[$[$1/10]/10]
elif [ $1 -gt 9 ];then
	c2=$[$[$1/10]%10]
	c3=0
else
	c2=0
	c3=0
fi
while :
do
	while :
	do
		while :
		do
			if [ $c1 -lt 0 ];then
				c1=9
				break
			else
				for i in {1..5}
				do
					echo ""
				done
				echo "                                   倒计时:"
				echo ""
				echo ""
				echo ""
				for i in {1..12}
				do
				        echo -e "\e[31m                                          $(display $c3 $i)     $(display $c2 $i)     $(display $c1 $i)\e[0m"
				done
				sleep 1
				let c1--
				clear
			fi
		done
		if [ $c2 -eq 0 ];then
			c2=9
			break
		else
			let c2--
		fi
	done
	if [ $c3 -eq 0 ];then
		echo "时间到!!"
		exit
	else
		let c3--
	fi
done










