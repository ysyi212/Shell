#!/bin/bash
read -p "请输入用户名: " user
if [ -z $user ];then
  echo "您必须输入用户名"
  exit 2
fi

stty -echo
read -p "请输入密码: " password
stty echo
password=${password:-123456}
useradd $user
echo $password | passwd --stdin $user
