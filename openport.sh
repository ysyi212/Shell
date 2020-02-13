#!/bin/bash
#搜寻所有开放的端口，把不需要的端口关闭，以防止被攻击
ss -nutlp |awk '{print $1,$5}'|awk -F "[: ]" '{print "协议:"$1,"端口号:"$NF}' |grep "[0-9]" |uniq
