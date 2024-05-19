FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PHPMYADMIN_VERSION 5.2.0

WORKDIR /var/www/html

RUN apt-get update && apt-get install -y \
  sudo \
  build-essential \
  openssh-server \
  curl \
  zip \
  vim \
  git \
  apache2 \
  php \
  php-mbstring \
  php-mysql \
  php-curl \
  php-ssh2 \
  php-xmlwriter \
  php-zip \
  mariadb-server

# Setup php.ini and apache (configuration for development only)
RUN echo "<Directory /var/www/html>" >> /etc/apache2/conf-enabled/allow-htaccess.conf \
  && echo "AllowOverride All" >> /etc/apache2/conf-enabled/allow-htaccess.conf \
  && echo "</Directory>" >> /etc/apache2/conf-enabled/allow-htaccess.conf \
  && cp /usr/lib/php/8.1/php.ini-development /etc/php/8.1/apache2/php.ini \
  && sed -i 's/display_errors = Off/display_errors = On/g' /etc/php/8.1/apache2/php.ini \
  && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 20M/g' /etc/php/8.1/apache2/php.ini \
  && sed -i 's/;date.timezone =/date.timezone = Asia\/Taipei/g' /etc/php/8.1/apache2/php.ini

# Install php-composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Setup ssh
RUN mkdir -p /run/sshd \
  && echo 'root:root' | chpasswd \
  && sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Setup phpmyadmin
RUN curl https://files.phpmyadmin.net/phpMyAdmin/$PHPMYADMIN_VERSION/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip -o /tmp/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip \
  && unzip /tmp/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages.zip -d /var/www/html \
  && mv /var/www/html/phpMyAdmin-$PHPMYADMIN_VERSION-all-languages /var/www/html/phpmyadmin \
  && mkdir -m 777 -p /var/www/html/phpmyadmin/tmp

# Setup mysql
RUN mkdir -p /docker-entrypoint-initdb.d \
  && mkdir -p /var/run/mysqld \
  && sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf \
  && chown mysql:mysql /var/run/mysqld

# Cleanup and remove unnecessary files
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/cache/apt/* \
  && rm -rf /var/www/html/index.html

EXPOSE 80 443 3306
