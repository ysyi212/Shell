#!/bin/bash
read -p "请输入虚拟机名称：" name
if virsh domstate $name |grep -q running;then
  echo "破解需要关闭虚拟机"
  virsh destroy $name
fi

mountpoint="/media/virtimage"
[ ! -d $mountpoint ] && mkdir $mountpoint
echo "请稍后..."
if mount |grep -q "$mountpoint";then
  umount $mountpoint
fi

guestmount -d $name -i $mountpoint
#将passwd文件中root的密码占位符x删除，可无密码登录
sed -i "/^root/s/x//" $mountpoint/etc/passwd
