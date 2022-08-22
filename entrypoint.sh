#!/bin/sh
create_userpass () {
  # Remove %20 spaces for username
  # Substitute back in %20 with spaces for passwords
  user=$(echo "${1}" | sed "s/%20//g")
  pass=$(echo "${2}" | sed "s/%20/ /g")

  if [ -f "${APACHE_PASSWD_PASSWORDS_PATH}" ]; then
    htpasswd -b "${APACHE_PASSWD_PASSWORDS_PATH}" "${user}" "${pass}"
  else
    htpasswd -b -c "${APACHE_PASSWD_PASSWORDS_PATH}" "${user}" "${pass}"
  fi
  echo -n " ${user}" >> "${APACHE_PASSWD_GROUPS_PATH}"
}

# Skip if both auth files exist. Error if only one exists.
if [ -f "${APACHE_PASSWD_PASSWORDS_PATH}" ] &&
   [ -f "${APACHE_PASSWD_GROUPS_PATH}" ]; then
  echo "Found existing files: ${APACHE_PASSWD_PASSWORDS_PATH} and ${APACHE_PASSWD_GROUPS_PATH}. Skipping user/pass creation." 2>&1
  exit 0
elif [ -f "${APACHE_PASSWD_PASSWORDS_PATH}" ]; then
  echo "Error! Found existing file: ${APACHE_PASSWD_PASSWORDS_PATH} but ${APACHE_PASSWD_GROUPS_PATH} is missing. Exiting user/pass creation." 2>&1
  exit 1
elif [ -f "${APACHE_PASSWD_GROUPS_PATH}" ]; then
  echo "Error! Found existing file: ${APACHE_PASSWD_GROUPS_PATH} but ${APACHE_PASSWD_PASSWORDS_PATH} is missing. Exiting user/pass creation." 2>&1
  exit 1
fi

# Create passwd groups file
echo -n "Users:" > "${APACHE_PASSWD_GROUPS_PATH}"

if [ ! -z "${WEBDAV_AUTH}" ]; then
  # First replace spaces with %20
  # then split using ';' delimiter
  logins=$(echo "${WEBDAV_AUTH}" | sed "s/ /%20/g" | sed "s/;/ /g" )
  for login in ${logins}; do
    if ! echo "${login}" | grep ":"; then
      # Ensure user:pass format
      echo "Formatting error with user/pass: Missing ':'. Must be 'user:pass' format " 2>&1
      exit 1
    fi

    create_userpass $(echo "${login}"  | sed "s/:/ /g")

  done
fi

set +x

# Run apache in foreground
./usr/sbin/httpd -D FOREGROUND
