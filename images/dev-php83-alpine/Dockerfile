FROM php:8.3-fpm-alpine

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN install-php-extensions ds mongodb redis amqp yaml xdebug bz2 gd imap intl ldap mysqli pdo_mysql pdo_pgsql pgsql simplexml xsl  snmp soap zip enchant
RUN install-php-extensions @composer

ENV DC_WORK_DIR=/mnt/data/php

COPY ./copy /

# installing 7 - phpmyadmin,adminer
# Note:When creating an image, a buffer of applicationss is created, which, when the container starts, is copied to the mounted volume
RUN <<EOF
composer create-project phpmyadmin/phpmyadmin "/.buf/www/phpmyadmin"
EOF
RUN <<EOF
composer create-project vrana/adminer "/.buf/www/adminer"
EOF

RUN cp -rf /.buf/.www/* /.buf/www
RUN <<EOF
mkdir -p /entrypoint
cat <<EOF2 >/entrypoint/init.sh
#!/bin/sh

mkdir -p "\${DC_WORK_DIR}/www"
if [[ ! -d "\${DC_WORK_DIR}/www/phpinfo/" ]]
then
 mv "/.buf/www/phpinfo" "\${DC_WORK_DIR}/www/phpinfo"
 mv "/.buf/www/_to_static.php" "\${DC_WORK_DIR}/www"
fi
mv "/.buf/www/phpinfo" "\${DC_WORK_DIR}/www/phpinfo"
if [[ ! -d "\${DC_WORK_DIR}/www/phpmyadmin/" ]]
then
    mv "/.buf/www/phpmyadmin" "\${DC_WORK_DIR}/www/phpmyadmin"
fi

if [[ ! -d "\${DC_WORK_DIR}/www/adminer/" ]]
then
    mv "/.buf/www/adminer" "\${DC_WORK_DIR}/www/adminer"
fi
rm -r "/.buf/"
chown -R www-data:www-data "\${DC_WORK_DIR}"
#chmod -R 775 "\${DC_WORK_DIR}"
exec php-fpm $@
EOF2
chmod 755 /entrypoint/init.sh
EOF
RUN apk add fcgi

ENTRYPOINT ["/entrypoint/init.sh"]

#HEALTHCHECK --interval=5s CMD ["/docker_scripts/healthcheck/test.sh","php-fpm","9000"]