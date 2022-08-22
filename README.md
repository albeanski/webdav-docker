# webdav-docker

This is the repo for the [albeanski/webdav](https://hub.docker.com/r/albeanski/webdav) docker image. Easily deploy a container for a webdav server on Apache to share or upload files. 

This image `alpine:3.12` because of a dbm driver issue. Later versions have removed the
`apr-util-dbm_db` package. See: https://gitlab.alpinelinux.org/alpine/aports/-/issues/13112


Alpine also defaults to the `apache` user and group. The `www-data` user does not exist but
`www-data` group does. This image uses the default `apache` user/group.


## Docker-compose Examples
### Basic configuration
./docker-compose.yml
```yaml
---
version: '3'
services:
  webdav:
    image: albeanski/webdav:latest
    ports:
      - 8000:80
    volumes:
      - /path/to/files:/webdav
```

### Read-only volume mount
./docker-compose.yml
```yaml
---
version: '3'
services:
  webdav:
    image: albeanski/webdav:latest
    ports:
      - 8000:80
    volumes:
      - /path/to/files:/webdav:ro
```

### Multi user/pass authentication
./docker-compose.yml
```yaml
---
version: '3' 
services:
  webdav:
    image: albeanski/webdav:latest
    environment:
      - WEBDAV_AUTH=myuser1:mypasswd;myuser2:otherpasswd
    ports:
      - 8000:80
    volumes:
      - /path/to/files:/webdav
```

### Using .env file for substitution

.env 
```bash
WEBDAV_AUTH=myuser:mypasswd
```

docker-compose.yml
```yaml
---
version: '3'
services:
  webdav:
    image: albeanski/webdav:latest
    environment:
      - WEBDAV_AUTH=${WEBDAV_AUTH}
    ports:
      - 8000:80
    volumes:
      - /path/to/files:/webdav
```
