# webdav-docker
uses alpine:3.12 because of a dbm driver issue. Later versions have removed the
apr-util-dbm_db package. See: https://gitlab.alpinelinux.org/alpine/aports/-/issues/13112


alpine defaults to apache user and group. www-data user does not exist but
www-data group does. we use the default apache user/group


## Docker-compose Examples
### Example of basic configuration
./docker-compose.yml
```yaml
---
version: '3'

services:
  webdav:
    image: albeanski/webdav:latest
    volumes:
      - /path/to/files:/webdav
```

### Example of read-only volume mount
./docker-compose.yml
```yaml
---
version: '3'
services:
  webdav:
    image: albeanski/webdav:latest
    volumes:
      - /path/to/files:/webdav:ro
```

### Example of custom multi user/pass authentication
#### ./docker-compose.yml
```yaml
services:
  webdav:
    image: albeanski/webdav:latest
    environment:
      - WEBDAV_AUTH=myuser1:mypasswd;myuser2:otherpasswd
    volumes:
      - /path/to/files:/webdav:
```

### Example of .env substitution
#### docker-compose.yml
```yaml
---
version: '3'

services:
  webdav:
    image: albeanski/webdav:latest
    environment:
      - WEBDAV_AUTH=${WEBDAV_AUTH}
    volumes:
      - /path/to/files:/webdav
```

#### .env 
```bash
WEBDAV_AUTH=myuser:mypasswd
```
