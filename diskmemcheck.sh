#!/bin/bash
#检查根分区是否小于1G，内存是否小于500M
disk_size=$(df / |awk '/\//{print $4}')
mem_size=$(free |awk '/Mem/{print $4}')
while :
do
  if [ disk_size -le 1024000 ];then
    echo "根分区容量小于1G" | mail -s DiskSizeWarning root
  fi
  if [ mem_size -le 512000 ];then
    echo "可用内存小于500M" | mail -s MemSizeWarning root
  fi
done
