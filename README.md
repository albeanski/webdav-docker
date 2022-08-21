# webdav-docker
uses alpine:3.12 because of a dbm driver issue. Later versions have removed the
apr-util-dbm_db package. See: https://gitlab.alpinelinux.org/alpine/aports/-/issues/13112


alpine defaults to apache user and group. www-data user does not exist but
www-data group does. we use the default apache user/group

 
