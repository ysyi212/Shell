#!/bin/bash
user=root
passwd=123456
dbname=mysql1
date=$(date + %Y%m%d)
[ ! -d /mysqlbackup ] && mkdir /mysqlbackup
mysqldump -u"$user" -p"$passwd" "$dbname" > /mysqlbackup/"$dbname"-${date}.sql
