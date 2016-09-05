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
