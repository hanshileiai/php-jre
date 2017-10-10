FROM php:7.1-fpm

RUN apt-get update && apt-get install -y libpng12-dev libjpeg-dev git \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd pdo_mysql zip opcache \
    
    && curl -sS https://getcomposer.org/installer | php -d detect_unicode=Off \
    && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer \
    && composer self-update


RUN echo " Add Oracle JRE 8 repository:"  && \
    echo "deb http://www.duinsoft.nl/pkg debs all" | tee /etc/apt/sources.list.d/duinsoft-jre.list  && \
    apt-key adv --keyserver keys.gnupg.net --recv-keys 5CB26B26  && \
    apt-get update && apt-get upgrade -y

RUN echo " Install Oracle JRE:"  && \
    DEBIAN_FRONTEND=noninteractive  apt-get -o Dpkg::Options::='--force-confnew' -y install update-sun-jre


RUN echo " Clean up:"  && \
    rm -rf /var/cache/update-sun-jre  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*