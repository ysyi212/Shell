#!/bin/bash
rotate_line(){
interval=0.1
count="0"
while :
  do
    count=`expr $count + 1`
    case $count in
      "1")
        echo -e "-""\b\c"
        sleep $interval;;
      "2")
        echo -e "\\""\b\c"
        sleep $interval;;
      "3")
        echo -e "|""\b\c"
        sleep $interval;;
      "4")
        echo -e "/""\b\c"
        sleep $interval;;
      *)
        count="0";;
    esac
  done
}
rotate_line
