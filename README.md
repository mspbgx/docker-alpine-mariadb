# docker-alpine-mariadb

[![](https://images.microbadger.com/badges/version/mspbgx/alpine-mariadb.svg)](https://microbadger.com/images/mspbgx/alpine-mariadb "Get your own version badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/mspbgx/alpine-mariadb.svg)](hub)
[![Docker Stars](https://img.shields.io/docker/stars/mspbgx/alpine-mariadb.svg)](hub)

**MAINTAINER:** Maximilian Sparenberg <sparenberg@openenv.de>


## Description
Mariadb in a docker container based on alpine image.
```
FROM alpine:latest
```

## Usage
### Standalone
```
docker run -d --name mariadb -e MYSQL_ROOT_PWD=ABC123xyz -e MYSQL_USER_DB=nextcloud -e MYSQL_USER=nextcloud -e MYSQL_USER_PWD=ABC123xyz -p 3306:3306 mspbgx/alpine-mariadb
```
### Compose
cat docker-compose.yml
```
version: '3.1'

services:

  db:
    image: mspbgx/alpine-mariadb
    restart: always
    environment:
      MYSQL_ROOT_PWD: ABC123xyz
```
### Variables:
```
MYSQL_ROOT_PWD = <mysql root password>
```
```
MYSQL_USER_DB = <database to be created>
```
```
MYSQL_USER = <user to be created>
```
```
MYSQL_USER_PWD = <password to be created>
```
