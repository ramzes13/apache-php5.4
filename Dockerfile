FROM nimmis/ubuntu:12.04

MAINTAINER ramzes13 <petru.darii@gmail.com>

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install make

RUN yes | apt-get install python-software-properties \
    && add-apt-repository ppa:ondrej/php5-oldstable \
    && apt-get update \
    && apt-get install -y php5 libapache2-mod-php5  \
    php5-fpm php5-cli php5-mysqlnd php5-pgsql php5-sqlite \
    php5-intl php5-imagick php5-mcrypt php5-json php5-gd php5-curl && \
    rm -rf /var/lib/apt/lists/* && \
    cd /tmp && curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN a2enmod rewrite \
    && echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 \
    && echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list \
    && apt-get update \
    && apt-get install mongodb-10gen

RUN yes | apt-get install imagemagick

RUN yes | apt-get install php5-dev \
    && yes | apt-get install php-pear  \
    && yes | apt-get install libcurl3-openssl-dev

# decline to install ssl connection to mongo
RUN no | pecl install mongo \
    && echo "extension=$(find /usr/lib/php5/ -name mongo.so)" >> /etc/php5/apache2/php.ini \
    && echo "extension=$(find /usr/lib/php5/ -name mongo.so)" >> /etc/php5/cli/php.ini

RUN yes | pecl install xdebug \
    && echo "zend_extension=$(find /usr/lib/php5/ -name xdebug.so)" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_enable=1" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_handler=dbgp" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_mode=req" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_port=9000" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.max_nesting_level=300" >> /etc/php5/apache2/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /etc/php5/apache2/php.ini \
    && echo "zend_extension=$(find /usr/lib/php5/ -name xdebug.so)" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_enable=1" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_handler=dbgp" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_mode=req" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_port=9000" >> /etc/php5/cli/php.ini \
    && echo "xdebug.max_nesting_level=300" >> /etc/php5/cli/php.ini \
    && echo "xdebug.remote_connect_back=1" >> /etc/php5/cli/php.ini
# put your ip for debugging
#RUN echo "xdebug.remote_host=<local ip>" >> /etc/php5/apache2/php.ini
#RUN echo "xdebug.remote_host=<local ip>" >> /etc/php5/cli/php.ini