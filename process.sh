#!/bin/bash
running=0
sleeping=0
stopped=0
zombie=0
#在proc目录下所有以数字开始的都是当前计算机正在运行的进程的PID
#每个PID编号的目录下记录有该进程相关的信息
for pid in /proc/[1-9]*
do
  procs=$[procs+1]
  stat=$(awk '{print $3}' $pid/stat)
#每个pid目录下都有一个stat文件，该文件的第3列是该进程的状态信息
  case $stat in
    R)
      running=$[running+1];;
    T)
      stopped=$[stopped+1];;
    S)
      sleeping=$[sleeping+1];;
    Z)
      zombie=$[zombie+1];;
  esac
done
echo "进程统计信息如下"
echo "总进程数量为：$procs"
echo "Running进程数为：$running"
echo "Stopped进程数为：$stopped"
echo "Sleeping进程数为：$sleeping"
echo "Zombie进程数为：$zombie"
