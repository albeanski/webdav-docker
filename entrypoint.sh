#!/bin/sh

echo "Creating endless sleep loop to persist container. Press CTRL+C to exit" 2>&1

/usr/sbin/httpd

while :; do
  sleep 300
done
