FROM alpine:3.7

ARG VERSION=1.3.5
ARG CHECKSUM='634e98b3e422208d25aba0a0e5adf603833b4b9d32b5db6c1162a122f31b686b'

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
	&& wget -q "https://github.com/roundcube/roundcubemail/releases/download/${VERSION}/roundcubemail-${VERSION}-complete.tar.gz" \
	&& if [ "${CHECKSUM}" != "$(sha256sum /tmp/roundcubemail-${VERSION}-complete.tar.gz | awk '{ print $1 }')" ]; \
	then \
		echo "Checksum does not match!" >&2; \
		exit 1; \
	fi \
	&& mkdir /roundcubemail \
	&& tar xzf roundcubemail-${VERSION}-complete.tar.gz \
	&& mv /tmp/roundcubemail-${VERSION}/* /roundcubemail \
	&& rm -rf /roundcubemail/installer \
	&& apk del .build-dependencies \
	&& rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8888
CMD ["tini", "--", "/usr/local/bin/run.sh"]
