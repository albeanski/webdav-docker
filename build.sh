#!/bin/bash
if [ -z "$1" ]; then
  echo "usage: $0 image_tag"
  exit 1
fi

docker build --no-cache -t albeanski/webdav:$1 -t albeanski/webdav:latest .
docker push albeanski/webdav:$1
docker push albeanski/webdav:latest
