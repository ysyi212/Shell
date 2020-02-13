#!/bin/bash
log_path="/usr/local/nginx/logs/"
mv ${log_path}access.log ${log_path}access_$(date -d "yesterday" + "%Y%m%d").log
kill -USR1 `cat /usr/local/nginx/logs/nginx.pid`
