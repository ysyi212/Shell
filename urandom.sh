#!/bin/bash
#获取十位随机密码，去除特殊字符
tr -dc '_A-Za-z0-9' < /dev/urandom | head -c 10
