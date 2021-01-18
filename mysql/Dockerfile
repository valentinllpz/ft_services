FROM alpine:3.12
LABEL maintainer="vlugand-@student.42.fr"

#MYSQL INSTALLATION
RUN apk update && \
	apk add mysql mysql-client

#OPENRC SETUP (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

COPY srcs/init_mariadb.sh tmp
COPY srcs/wp_conf.sql tmp
COPY srcs/pma_conf.sql tmp

CMD ["sh", "tmp/init_mariadb.sh"]