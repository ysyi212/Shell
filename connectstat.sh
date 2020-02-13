#!/bin/bash
#local address第四列是本机的IP和端口信息
#foreign address第五列是远程主机的IP和端口信息
#sort按大小排序，uniq将重复多余的删除，并统计重复次数
netstat -atn | awk '{print $5}' | awk '{print $1}' | sort -nr | uniq -c
