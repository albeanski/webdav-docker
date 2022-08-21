#!/bin/bash
if [ -z "$1" ]; then
  echo "usage: $0 image_tag [options{"
  exit 1
fi

tag=$1

shift

docker build -t albeanski/webdav:${tag} -t albeanski/webdav:latest $@ .
docker push albeanski/webdav:${tag}
docker push albeanski/webdav:latest
