#!/bin/bash
#100以内猜数
num=$(RANDOM%101)
while :
do
  read -p "计算机生成了一个100以内的随机数，你猜是： " ynum
  if [ $ynum -eq $num ];then
    echo "恭喜你猜对了！"
  elif [ $ynum -gt $num ];then
    echo "猜大了"
  else
   echo "猜小了"
  fi
done
