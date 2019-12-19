#! /bin/bash
i=1
while :
do
 if [ "$i" -ne "$1" ]; then
		touch /home/student/桌面/$i.html
		echo "<html>
<head><title>this is the $i html</title></head>
<body><h1>this the $i html</h1></body>
<html>" > /home/student/桌面/$i.html
		((i++))
	else
		break
 fi
done
