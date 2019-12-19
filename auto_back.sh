#! /bin/bash

date=$(date +"%Y%m%d")
echo "$date.tar.gz"
mkdir /backup 2> /dev/null
tar -zPcf /backup/$date.tar.gz /root
ls /backup |grep -v $date.tar.gz|xargs rm -rf
