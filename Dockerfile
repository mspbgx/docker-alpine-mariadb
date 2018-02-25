FROM alpine:latest

MAINTAINER Maximilian Sparenberg <sparenberg@openenv.de>

RUN apk update
RUN apk add mariadb mariadb-client
RUN addgroup mysql mysql
RUN rm -rf /var/cache/apk/*


VOLUME ["/var/lib/mysql"]

COPY ./docker-entrypoint.sh /opt/docker-entrypoint.sh
RUN chmod +x /opt/docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/opt/docker-entrypoint.sh"]
