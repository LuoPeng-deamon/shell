#! /bin/bash

i=1
j=1
for i in `seq 9`; do
	for j in `seq 9`;	do
		if [ $j -le $i ]; then
			echo -n "$j*$i=$((i*j))	"
		fi
	done
	echo " "
done
