FROM alpine:latest

MAINTAINER Maximilian Sparenberg <sparenberg@openenv.de>

RUN apk update
RUN apk add mariadb mariadb-client
RUN addgroup mysql mysql && \
RUN rm -rf /var/cache/apk/*


VOLUME ["/var/lib/mysql"]

COPY ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

EXPOSE 3306

ENTRYPOINT ["/opt/startup.sh"]
