#!/bin/bash
yum makecache &>/dev/null
num=$(yum repolist |awk '/repolist/{print $2}' |sed 's/,//')
if [ $num -lt 0 ];then
  yum -y install httpd mariadb mariadb-server mariadb-devel php php-mysql
else
  echo "未配置yum源..."
fi
