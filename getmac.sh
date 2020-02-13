#!/bin/bash
#awk输出命令结果，如果有以数字开始的行，先显示该行的第2列（网卡名称）
#用getline读取它的下一行数据，判断是否包含link/ether
#如果包含就显示该行的第2列（MAC地址）
#lo回环设备没有MAC，因此屏蔽
ip a s | awk 'BEGIN{print "本机MAC地址信息如下："}/^[0-9]/{print $2;getline;if($0~/link\/ether/){print $2}}' |grep -v lo:
