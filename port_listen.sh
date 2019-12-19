#! /bin/bash
tcpdump -s 0 -X 'tcp dst port 22'|grep -e "IP.*\[S\]"


