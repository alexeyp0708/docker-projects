FROM mysql:latest
RUN microdnf -y install gettext net-tools procps-ng
RUN mv /usr/local/bin/docker-entrypoint.sh /usr/local/bin/parent-docker-entrypoint.sh
ENV MYSQL_ROOT_PASSWORD=root
ENV DC_WORK_DIR=/mnt/data/\${HOSTNAME}
ENV STDOUT_LOG_ERROR=NO
ENV STDOUT_LOG_QUERY=NO
ENV STDOUT_LOG_QUERY_SLOW=NO
ENV STDOUT_LOG_TC=NO
ENV STDOUT_LOG_ISAM=NO
COPY ./copy/ /

RUN <<EOF
ln -s /docker_scripts/entrypoint/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
cat <<EOF2 > /docker_scripts/entrypoint/entrypoint-commands.sh
#!/bin/sh
    DC_WORK_DIR="$(/docker_scripts/entrypoint/tplToStr.sh "\$DC_WORK_DIR")"
    mkdir -p \${DC_WORK_DIR}
    if [[ -z "$(cat /etc/passwd | grep '^www-data:')" ]]
    then
        adduser -d \${DC_WORK_DIR} -s /bin/bash -u 82 -g mysql  www-data
    fi
    chown www-data \${DC_WORK_DIR}
    echo "Container work directory - \${DC_WORK_DIR}"
    mkdir -p \${DC_WORK_DIR}/temp/
    chmod 777 \${DC_WORK_DIR}/temp
    chmod 644 /etc/my.cnf
    chmod 644 -R /etc/mysql/conf.d
    if [[ "\$STDOUT_LOG_ERROR" == "YES" ]]
    then
        /docker_scripts/entrypoint/logTail.sh log-error /etc/env_tpls/my.cnf.tpl &
    fi
    if [[ "\$STDOUT_LOG_QUERY" == "YES" ]]
    then
        /docker_scripts/entrypoint/logTail.sh general-log-file /etc/env_tpls/my.cnf.tpl &
    fi
    if [[ "\$STDOUT_LOG_QUERY_SLOW" == "YES" ]]
    then
        /docker_scripts/entrypoint/logTail.sh slow-query-log-file /etc/env_tpls/my.cnf.tpl &
    fi    
    if [[ "\$STDOUT_LOG_TC" == "YES" ]]
    then
        /docker_scripts/entrypoint/logTail.sh log-tc /etc/env_tpls/my.cnf.tpl &
    fi
    if [[ "\$STDOUT_LOG_ISAM" == "YES" ]]
    then
        /docker_scripts/entrypoint/logTail.sh log-isam /etc/env_tpls/my.cnf.tpl &
    fi
EOF2
EOF

#VOLUME ["/mnt/data"]
#VOLUME ["/var/lib/mysql"]

#HEALTHCHECK --interval=5s CMD ["/docker_scripts/healthcheck/test.sh", "mysqld","3306"]