#!/bin/bash
pack{
while :
do
  ifconfig $1 | grep "RX pack" | awk '{print $5}'
  ifconfig $1 | grep "TX pack" | awk '{print $5}'
  sleep 1
done
}
read -p "请输入需要监控的网卡: " netcard
pack $netcard
