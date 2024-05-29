FROM nginx:1.26.0-alpine

ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx
ENV DC_WORK_DIR=/mnt/data
ENV UPSTREAM_LIST=php83:9000
ENV SERV_CONFIG=
COPY ./copy /

RUN <<EOF
    mkdir -p $DC_WORK_DIR
    adduser -H -D -s /sbin/nologin -G www-data -u 82 www-data
EOF

RUN <<EOF
apk add fcgi
chmod -R 755 /docker_scripts
mv /docker-entrypoint.sh /docker_scripts/entrypoint/parent-docker-entrypoint.sh
ln -s /docker_scripts/entrypoint/docker-entrypoint.sh /docker-entrypoint.sh
EOF
#HEALTHCHECK --start-interval=5s --start-period=1m CMD ["/docker_scripts/healthcheck/test.sh"]

