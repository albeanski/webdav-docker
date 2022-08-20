# adapted from: https://www.hiroom2.com/2017/08/22/alpinelinux-3-6-webdav-en/

FROM alpine:latest

RUN apk update && \
  apk --no-cache add \
  apache2-webdav \
  apache2-utils \
  curl

#RUN ln -sf /dev/stdout /var/log/apache2/access.log \
#    && ln -sf /dev/stderr /var/log/apache2/error.log

RUN set -x \
#    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data

RUN mkdir -p \
    /var/lib/dav \
    /webdav \
    /usr/uploads && \
  chown -R www-data:www-data \
    /var/lib/dav \
    /usr/uploads \
    /webdav \
    /var/www

COPY ./webdav-site.conf /etc/apache2/conf.d/webdav-site.conf
COPY ./dav.conf /etc/apache2/conf.d/dav.conf
COPY ./httpd.conf /etc/apache2/httpd.conf

RUN htpasswd -b -c /usr/.userpasswd webdav webdav && \
  chown www-data:www-data /usr/.userpasswd

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

#CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 80 
