# adapted from: https://www.hiroom2.com/2017/08/22/alpinelinux-3-6-webdav-en/
FROM alpine:3.12

ENV APACHE_PASSWD_PATH=/config/passwd
ENV APACHE_PASSWD_PASSWORDS_PATH=${APACHE_PASSWD_PATH}/passwords
ENV APACHE_PASSWD_GROUPS_PATH=${APACHE_PASSWD_PATH}/groups
ENV WEBDAV_AUTH=webdav:webdav

# install necessary packages
RUN set -x \
  && apk --no-cache add \
    apache2-webdav \
    apache2-utils \
    apr-util-dbm_db \
    curl

# symlink apache logs to stdout and stderr 
RUN set -x \
  && ln -sf /dev/stdout /var/log/apache2/access.log \
  && ln -sf /dev/stderr /var/log/apache2/error.log

# create all directories and set permissions
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

# set server name in httpd &
# set htpassword file and group file paths inside dav.conf
RUN set -x \
  && sed -i 's/#ServerName.*$/ServerName webdav:80/g' /etc/apache2/httpd.conf \
  && sed -i 's,<<APACHE_PASSWD_PASSWORDS_PATH>>,'"${APACHE_PASSWD_PASSWORDS_PATH}"',g' /etc/apache2/conf.d/dav.conf \
  && sed -i 's,<<APACHE_PASSWD_GROUPS_PATH>>,'"${APACHE_PASSWD_GROUPS_PATH}"',g' /etc/apache2/conf.d/dav.conf

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 
