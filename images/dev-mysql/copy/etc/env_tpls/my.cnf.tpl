# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/8.3/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M

# Remove leading # to revert to previous value for default_authentication_plugin,
# this will increase compatibility with older clients. For background, see:
# https://dev.mysql.com/doc/refman/8.3/en/server-system-variables.html#sysvar_default_authentication_plugin
# default-authentication-plugin=mysql_native_password
host-cache-size=0
skip-name-resolve
datadir=${DC_WORK_DIR}/DB
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=${DC_WORK_DIR}/files
general-log=true
general-log-file=${DC_WORK_DIR}/log/query.log
slow-query-log=true
slow-query-log-file=${DC_WORK_DIR}/log/query-slow.log
log-error=${DC_WORK_DIR}/log/errors.log
log-isam=${DC_WORK_DIR}/log/isam.log
log-tc=${DC_WORK_DIR}/log/tc.log
tmpdir=${DC_WORK_DIR}/temp/
user=www-data

pid-file=/var/run/mysqld/mysqld.pid
[client]
socket=/var/run/mysqld/mysqld.sock

!includedir /etc/mysql/conf.d/
