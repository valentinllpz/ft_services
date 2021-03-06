FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update

### TELEGRAF SETUP ###
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log
COPY /srcs/telegraf.conf /etc/telegraf/

### NGINX SETUP ###
RUN	apk add --no-cache nginx && \
	mkdir -p /run/nginx && \
	rm -f /etc/nginx/conf.d/default.conf
COPY /srcs/index.html /var/www/
COPY /srcs/server.conf /etc/nginx/conf.d/
COPY /srcs/ssl-params.conf /etc/nginx/

### SSL SETUP ###
RUN	apk add --no-cache openssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt >/dev/null 2>&1 && \
	openssl dhparam -out /etc/nginx/dhparam.pem 2048 >/dev/null 2>&1

COPY /srcs/init_nginx.sh/ /tmp/

EXPOSE 80 443

ENTRYPOINT ["sh", "/tmp/init_nginx.sh"]