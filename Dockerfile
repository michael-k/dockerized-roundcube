FROM alpine:3.6

ARG VERSION=1.3.2
ARG CHECKSUM='83e4505df8f14a94313f4a8ccc88a0550e85d7798336b680f1040097fe93c50a'

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
