FROM lsiobase/alpine.nginx:3.9

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="alex-phillips"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	curl \
    git \
	unzip && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
    curl \
	ffmpeg \
	mariadb-client \
	php7 \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-exif \
	php7-gd \
	php7-json \
	php7-imagick \
	php7-mbstring \
	php7-opcache \
	php7-openssl \
	php7-pdo_mysql \
	php7-sockets \
	php7-xml \
	php7-zip && \
 echo "**** install ioncube ****" && \
 curl -O http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && \
 tar xvfz ioncube_loaders_lin_x86-64.tar.gz && \
 cp "ioncube/ioncube_loader_lin_7.2.so" /usr/lib/php7/modules && \
 echo "zend_extension=ioncube_loader_lin_7.2.so" >> /etc/php7/conf.d/00_ioncube_loader_lin_7.2.ini && \
 rm -rf /ioncube* && \
 echo "**** install filerun ****" && \
 mkdir -p /app/filerun && \
 curl -o /app/filerun/filerun.zip -L http://tiny.cc/sn7qzz && \
 cd /app/filerun && \
 unzip filerun.zip && \
 rm /app/filerun/filerun.zip && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
VOLUME /config
