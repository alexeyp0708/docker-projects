#!/bin/sh

ps -ef |grep -E ".+\s*[0-9]+\s+0+\s+[0-9]+.+\s+.+\s+.+\s$1\s*$" && \
netstat -an | grep ":$2\s" && \
mysqladmin ping -h localhost -u root --password=$MYSQL_ROOT_PASSWORD |grep 'mysqld is alive' && \
mysql --user=root --password=$MYSQL_ROOT_PASSWORD --execute "SHOW DATABASES;" || \
exit 1