#!/bin/bash
url=http://192.168.4.5/index.html
#-m设置curl最大连接消耗时间5s，超时视为无法访问
#-s设置静默连接，不显示连接时的速度、时间消耗等信息
#-o将下载的页面内容导出到/dev/null
#-w设置curl需显示的内容%{http_code}，指定返回服务器的状态码
check_http(){
  status_code=$(curl -m 5 -s -o /dev/null -w %{http_code} $url)
}
while :
do
  check_http
  date=$(date +%Y%m%d-%H:%M:%S)
  echo "当前时间为：$date
  $url服务器异常，状态码为${status_code}.
  请尽快排查异常." > /tmp/http$$.pid
  if [ $status_code -ne 200 ];then
    mail -s Warning root < /tmp/http$$.pid
  else
    echo "$url 连接正常" >> /var/log/http.log
  fi
  sleep 5
done
