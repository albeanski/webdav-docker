# adapted from: https://www.hiroom2.com/2017/08/22/alpinelinux-3-6-webdav-en/

FROM alpine:3.12

RUN set -x && \
  apk update && \
  apk --no-cache add \
  apache2-webdav \
  apache2-utils \
  apr-util-dbm_db \
  curl

RUN set -x \
  && ln -sf /dev/stdout /var/log/apache2/access.log \
  && ln -sf /dev/stderr /var/log/apache2/error.log

RUN set -x \
  && mkdir -p \
    /var/lib/dav \
    /webdav \
    /usr/uploads \
  && htpasswd -b -c /usr/.userpasswd webdav webdav \
  && chown -R apache:apache \
    /var/lib/dav \
    /webdav \
    /usr/.userpasswd

COPY ./dav.conf /etc/apache2/conf.d/dav.conf
COPY ./httpd.conf /etc/apache2/httpd.conf

#COPY ./entrypoint.sh /
#RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/sbin/httpd", "-D", "FOREGROUND"]
#ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 
