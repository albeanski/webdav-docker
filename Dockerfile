FROM nginx

RUN apt update && apt install -y \
  nginx-extras \
  libnginx-mod-http-dav-ext \
  libnginx-mod-http-auth-pam

RUN mkdir -p /var/dav/webdav_root && \
  chown -R www-data:www-data /var/dav/


