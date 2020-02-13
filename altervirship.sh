#!/bin/bash
#安装libguestfs-tools-c可获得guestmount工具
#在不登录虚拟机的情况下修改IP地址
read -p "请输入虚拟机名称:" name
if virsh domstate $name |grep -q running;then
  echo "修改虚拟机ip地址，需关闭虚拟机"
  virsh destroy $name
fi

mountpoint="/media/virtimage"
[ ! -d $mountpoint ] && mkdir $mountpoint
echo "请稍后..."
if mount |grep -q "$mountpoint";then
  umount $mountpoint
fi

guestmount -d $name -i $mountpoint
read -p "请输入需要修改的网卡名称：" dev
read -p "请输入IP地址：" addr

#判断原本网卡配置文件中是否有IP地址，有就修改，没有就添加一个新的IP
if grep -q "IPADDR" $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev;then
  sed -i "/IPADDR/s/=.*/=$addr/" $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
else
  echo "IPADDR=$addr" >> $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
fi

#如果网卡配置文件中有客户配置的IP地址，则提示修改IP完成
awk -F "=" -v x=$addr '$2==x{print "完成..."}' $mountpoint/etc/sysconfig/network-scripts/ifcfg-$dev
