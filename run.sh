#!/bin/sh

GID=${GID:-991}
UID=${UID:-991}

chown $UID:$GID /roundcubemail/temp /roundcubemail/logs
sed -i "s#;date.timezone =#date.timezone = \"${TIMEZONE:-UTC}\"#" /etc/php7/php.ini

exec su-exec $UID:$GID php7 -S 0.0.0.0:8888 -t /roundcubemail
