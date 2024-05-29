FROM nginx:latest

#installing 1 - updates
RUN <<EOF
apt update
apt-get -y install net-tools iputils-ping iptables nano vim lsb-release apt-transport-https 7zip
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
sh -c 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
apt update
EOF

#installing 2- basic php
RUN <<EOF
apt-get -y install php7.4 php7.4-cli php7.4-fpm php7.4-dev \
php8.3 php8.3-cli php8.3-fpm php8.3-dev
EOF

#installing 3 - modules php
RUN <<EOF
apt-get -y install php7.4-json php7.4-bz2 php7.4-curl php7.4-enchant php7.4-gd php7.4-imap \
php7.4-intl php7.4-ldap  php7.4-mbstring php7.4-mysql php7.4-mysqli php7.4-mongodb php7.4-pdo-sqlite \
php7.4-dom  php7.4-xml php7.4-simplexml php7.4-xmlreader php7.4-xmlwriter php7.4-xsl \
php7.4-pgsql php7.4-snmp php7.4-soap php7.4-sqlite3 php7.4-zip php7.4-redis php7.4-amqp php7.4-yaml  php7.4-xdebug php7.4-ds \
php8.3-bz2 php8.3-curl php8.3-enchant php8.3-gd php8.3-imap \
php8.3-intl php8.3-ldap php8.3-mbstring php8.3-mysql php8.3-mysqli php8.3-mongodb php8.3-pdo-sqlite \
php8.3-dom php8.3-xml php8.3-simplexml php8.3-xmlreader php8.3-xmlwriter php8.3-xsl \
php8.3-pgsql php8.3-snmp php8.3-soap php8.3-sqlite3 php8.3-zip php8.3-redis php8.3-amqp php8.3-yaml php8.3-xdebug 
pecl install ds
EOF

#installing 4 git, composer
RUN <<EOF
apt-get -y install git
EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
if [ "$EXPECTED_CHECKSUM" = "$ACTUAL_CHECKSUM" ]; then php composer-setup.php ; fi
rm composer-setup.php; unset EXPECTED_CHECKSUM; unset ACTUAL_CHECKSUM
mv composer.phar /usr/local/bin/composer
EOF

#installing 5 -nodejs pnpm
RUN <<EOF
curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && apt-get install -y nodejs
curl -fsSL https://get.pnpm.io/install.sh | ENV="$HOME/.bashrc" SHELL="$(which bash)" bash -
source /root/.bashrc
corepack enable
EOF
#installing 6
# Configuration PHP
RUN <<EOF
rm -r /etc/php/7.4/mods-available/*
rm -r /etc/php/7.4/fpm/conf.d/*
rm -r /etc/php/7.4/cli/conf.d/*
rm -r /etc/php/8.3/mods-available/*
rm -r /etc/php/8.3/fpm/conf.d/*
rm -r /etc/php/8.3/cli/conf.d/*
EOF

ENV PHP_INI_SCAN_DIR /etc/php/basic-settings:/etc/php/basic-settings/mods-available:
ENV NGINX_ENVSUBST_OUTPUT_DIR=/etc/nginx
ENV CONTAINER_WORK_DIR=/mnt/dev

COPY ./buf/copy/etc/ /etc
COPY ./buf/copy/phpService.sh /
COPY ./buf/copy/mnt/dev /.buf${CONTAINER_WORK_DIR}

# installing 7 - phpmyadmin,adminer
RUN <<EOF
rm -rf /.buf${CONTAINER_WORK_DIR}/www/php/phpmyadmin
composer create-project phpmyadmin/phpmyadmin "/.buf${CONTAINER_WORK_DIR}/www/php/phpmyadmin"
cd /.buf${CONTAINER_WORK_DIR}/www/php/phpmyadmin
composer update
cd /.buf${CONTAINER_WORK_DIR}/www/php/adminer
composer require vrana/adminer
cd /
EOF

COPY ./buf/copy/mnt/dev/www/php/phpmyadmin/ /.buf${CONTAINER_WORK_DIR}/www/php/phpmyadmin/

#finish
RUN <<EOF
#chmod -R 775 ${CONTAINER_WORK_DIR}
cd /etc/ssl/for_dev_web_server
openssl x509 -req -in general.csr -CA rootCA.crt -CAkey keys/rootCA.key -CAcreateserial -out general.crt -days 36500 -extfile general.ext
cd /
cat <<EOF2 >/docker-php-entrypoint.sh
#!/bin/sh
export CONTAINER_WORK_DIR=${CONTAINER_WORK_DIR}/\$HOSTNAME
echo "Container work directory - \$CONTAINER_WORK_DIR"
mkdir -p \$CONTAINER_WORK_DIR/www/ 
mkdir -p \$CONTAINER_WORK_DIR/log/
mkdir -p \$CONTAINER_WORK_DIR/temp/
mkdir -p \$CONTAINER_WORK_DIR/sessions/ 
cp -r -n "/.buf${CONTAINER_WORK_DIR}/"* "\$CONTAINER_WORK_DIR/"
rm -r /.buf
chown -R www-data:www-data \$CONTAINER_WORK_DIR
/phpService.sh start all
exec /docker-entrypoint.sh "\$@"
EOF2
chmod 755 /docker-php-entrypoint.sh
EOF

ENTRYPOINT  ["/docker-php-entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]

