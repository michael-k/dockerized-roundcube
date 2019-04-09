FROM alpine:3.9

ARG VERSION=1.3.8
ARG CHECKSUM='c49e33f9643f98311b700138a1e1a0358c37b1205250e1124bd43d7f9a920d05'

RUN apk add --no-cache --virtual .build-dependencies \
		openssl \
	&& apk add --no-cache \
		ca-certificates \
		php7 \
		php7-dom \
		php7-exif \
		php7-fileinfo \
		php7-iconv \
		php7-imap \
		php7-intl \
		php7-json \
		php7-ldap \
		php7-mbstring \
		php7-openssl \
		php7-pdo_pgsql \
		php7-pgsql \
		php7-session \
		php7-xml \
		su-exec \
		tini \
	&& cd /tmp \
	&& wget -q "https://github.com/roundcube/roundcubemail/releases/download/${VERSION}/roundcubemail-${VERSION}-complete.tar.gz" -O roundcubemail.tar.gz \
	&& if [ "${CHECKSUM}" != "$(sha256sum /tmp/roundcubemail.tar.gz | awk '{ print $1 }')" ]; \
	then \
		echo "Checksum does not match!" >&2; \
		exit 1; \
	fi \
	&& mkdir /roundcubemail \
	&& tar xzf roundcubemail.tar.gz \
	&& mv /tmp/roundcubemail-${VERSION}/* /roundcubemail \
	&& rm -rf /roundcubemail/installer \
	&& apk del .build-dependencies \
	&& rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8888
CMD ["tini", "--", "/usr/local/bin/run.sh"]
