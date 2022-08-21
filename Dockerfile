# adapted from: https://www.hiroom2.com/2017/08/22/alpinelinux-3-6-webdav-en/
FROM alpine:3.12

ENV APACHE_PASSWD_PATH=/config/passwd
ENV APACHE_PASSWD_PASSWORDS_PATH=${APACHE_PASSWD_PATH}/passwords
ENV APACHE_PASSWD_GROUPS_PATH=${APACHE_PASSWD_PATH}/groups
ENV WEBDAV_AUTH=webdav:webdav

RUN set -x \
#  && apk update \
  && apk --no-cache add \
    apache2-webdav \
    apache2-utils \
    apr-util-dbm_db \
    curl

RUN set -x \
#  && adduser -S -u 1000 -G www-data www-data \
#  && htpasswd -b -c /usr/.userpasswd webdav webdav \
  && ln -sf /dev/stdout /var/log/apache2/access.log \
  && ln -sf /dev/stderr /var/log/apache2/error.log

RUN set -x \
  && mkdir -p \
    /var/lib/dav \
    /webdav \
    ${APACHE_CONFIG_PATH} \
    ${APACHE_PASSWD_PATH} \
  && chown -R apache:apache \
    /var/lib/dav \
    /webdav \
    ${APACHE_CONFIG_PATH} \
    ${APACHE_PASSWD_PATH}

COPY ./dav.conf /etc/apache2/conf.d/dav.conf

RUN set -x \
  && sed -i 's/#ServerName.*$/ServerName webdav:80/g' /etc/apache2/httpd.conf \
  && sed -i 's,<<APACHE_PASSWD_PASSWORDS_PATH>>,'"${APACHE_PASSWD_PASSWORDS_PATH}"',g' /etc/apache2/conf.d/dav.conf \
  && sed -i 's,<<APACHE_PASSWD_GROUPS_PATH>>,'"${APACHE_PASSWD_GROUPS_PATH}"',g' /etc/apache2/conf.d/dav.conf

#ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 
