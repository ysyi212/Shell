#!/bin/bash
clear
mountpoint="/media/virtimage"
[ ! -d $mountpoint ] && mkdir $mountpoint
echo "请稍后..."
if mount |grep -q "$mountpoint";then
  umount $mountpoint
fi

guestmount -d $name -i $mountpoint
echo
echo "----------------------------------------------"
echo -e "\033[32m$name 虚拟机中网卡列表如下:\033[0m"
dev=$(ls /media/virtimage/etc/sysconfig/network-scripts/ifcfg-* |awk -F "[/-]" '{print $9}')
echo $dev
echo "----------------------------------------------"
echo
echo
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "\033[32m 网卡IP信息如下:\033[0m"
for i in $dev
do
  echo -n "$i:"
  grep -q "IPADDR" /media/virtimage/etc/sysconfig/network-scripts/ifcfg-$i || echo "未配置IP地址"
  awk -F= '/IPADDR/{print $2}' /media/virtimage/etc/sysconfig/network-scripts/ifcfg-$i
done
echo "++++++++++++++++++++++++++++++++++++++++++++++"
