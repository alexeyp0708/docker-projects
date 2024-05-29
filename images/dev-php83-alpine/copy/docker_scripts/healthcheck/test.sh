#!/bin/sh

ps -o pid,ppid,comm|grep -E "\s*[0-9]+\s+0+\s+$1" && \
netstat -an | grep ":$2\s" && \
cgi-fcgi -bind -connect localhost:$2 || \
exit 1