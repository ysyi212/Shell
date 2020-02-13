#!/bin/bash
starttime="13:30"
endtime="14:30"
log_dest=/var/log/httpd/access_log

access_num=awk -F "[/:]" '$7":"$8>=starttime && $7":"$8<=endtime' log_dest | wc -l
echo "访问apache服务器的请求有$access_num个"

access_ip=[awk -F "[/:]" '$7":"$8>=starttime && $7":"$8<=endtime {print $1}' log_dest]
for i in access_ip
do
  echo "访问apache的远程ip地址是$i"
done

#每个ip访问了本机几次
access_dict=[awk '{ip[$1]++}END{for i in ip{print ip[i],i}}' log_dest]
for i in access_dict
do
  echo "$i"
done
