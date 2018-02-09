FROM php:7.1-fpm

RUN apt-get update && apt-get install -y locales libpng12-dev libjpeg-dev git curl wget libmagickwand-dev --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd pdo_mysql zip opcache \
    
    && curl -sS https://getcomposer.org/installer | php -d detect_unicode=Off \
    && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer \
    && composer self-update

ENV LANG C.UTF-8


RUN DEBIAN_FRONTEND=noninteractive echo " Install imagick:" && pecl install imagick && docker-php-ext-enable imagick 

RUN echo " Add Oracle JRE 8 repository:"  && \
    echo "deb http://www.duinsoft.nl/pkg debs all" | tee /etc/apt/sources.list.d/duinsoft-jre.list  && \
    apt-key adv --keyserver keys.gnupg.net --recv-keys 5CB26B26  && \
    apt-get update && apt-get upgrade -y

RUN echo "deb http://ftp.de.debian.org/debian sid main" >> /etc/apt/sources.list && \ 
    apt-get -qqy update && \
    apt-get -qqy install -y pdf2htmlex

RUN echo " Install Oracle JRE:"  && \
    DEBIAN_FRONTEND=noninteractive  apt-get -o Dpkg::Options::='--force-confnew' -y install update-sun-jre

RUN echo " Install node, npm: " && \ 
    curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
    apt-get install -y nodejs

Run echo "install ghostscript: " \
    && wget https://github.com/luvvien/resources/raw/master/ghostscript-9.22-linux-x86_64.tar.gz \
    && tar -xzvf ghostscript-9.22-linux-x86_64.tar.gz \
    && cd ghostscript-9.22-linux-x86_64 \
    && cp gs-922-linux-x86_64 /usr/local/bin/gs \
    && cp gs-922-linux-x86_64 /usr/bin/gs \
    && rm ../ghostscript-9.22-linux-x86_64.tar.gz \
    && rm -rf ghostscript-9.22-linux-x86_64

RUN echo " Clean up:"  && \
    rm -rf /var/cache/update-sun-jre  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*


