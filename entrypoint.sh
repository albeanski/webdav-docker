#!/bin/sh
create_userpass () {
  user=$(echo "${1}" | sed "s/%20//g")
  pass=$(echo "${2}" | sed "s/%20/ /g")
  if [ -f "${APACHE_PASSWD_PASSWORDS_PATH}" ]; then
    htpasswd -b "${APACHE_PASSWD_PASSWORDS_PATH}" "${user}" "${pass}"
  else
    htpasswd -b -c "${APACHE_PASSWD_PASSWORDS_PATH}" "${user}" "${pass}"
  fi
  echo -n " ${user}" >> "${APACHE_PASSWD_GROUPS_PATH}"
}

echo -n "Users:" > "${APACHE_PASSWD_GROUPS_PATH}"

if [ ! -z "${WEBDAV_AUTH}" ]; then
  logins=$(echo "${WEBDAV_AUTH}" | sed "s/ /%20/g" | sed "s/;/ /g" )
  for login in ${logins}; do
    if ! echo "${login}" | grep ":"; then
      echo "Formatting error with user/pass: Missing ':'. Must be 'user:pass' format " 2>&1
      exit 1
    fi
    create_userpass $(echo "${login}"  | sed "s/:/ /g")
  done
fi

set +x
./usr/sbin/httpd -D FOREGROUND

