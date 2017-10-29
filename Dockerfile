FROM alpine:3.6

ARG VERSION=1.3.1
ARG CHECKSUM='f071bbe84f90ba55582289dcef7b70198b81e0aedd4de8422945658bbee3da0b'

RUN apk -U upgrade \
	&& apk add -t build-dependencies \
		openssl \
	&& apk add \
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
	&& if [ "${CHECKSUM}" != "$(sha256sum /tmp/roundcubemail-${VERSION}-complete.tar.gz | awk '{ print $1 }')" ]; then exit 1; fi \
	&& mkdir /roundcubemail \
	&& tar xzf roundcubemail-${VERSION}-complete.tar.gz \
	&& mv /tmp/roundcubemail-${VERSION}/* /roundcubemail \
	&& rm -rf /roundcubemail/installer \
	&& apk del build-dependencies \
	&& rm -rf /var/cache/apk/* /tmp/*

COPY run.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run.sh

EXPOSE 8888
CMD ["tini", "--", "/usr/local/bin/run.sh"]
