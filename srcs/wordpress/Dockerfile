FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update 

### TELEGRAF SETUP ###
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log
COPY /srcs/telegraf.conf /etc/telegraf/

### OPENRC SETUP ###  (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add --no-cache openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

### NGINX SETUP ###
RUN	apk add --no-cache nginx && \
	mkdir -p /run/nginx && \
	rm -f /etc/nginx/conf.d/default.conf
COPY /srcs/server.conf /etc/nginx/conf.d/
COPY /srcs/ssl-params.conf /etc/nginx/
COPY /srcs/wp-config.php /var/www/wordpress/

### SSL SETUP ###
RUN	apk add --no-cache openssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt >/dev/null 2>&1 && \
	openssl dhparam -out /etc/nginx/dhparam.pem 2048 >/dev/null 2>&1

### WORDPRESS SETUP ###
RUN apk add --no-cache wget php7 php7-fpm php7-mysqli php7-mbstring php7-json php7-session php-sockets php7-common php7-opcache php7-zlib php7-curl php7-gd php7-cgi && \
	cd /var/www/ && wget -q http://wordpress.org/latest.tar.gz && \
	tar -xzvf latest.tar.gz && rm latest.tar.gz && \
	chmod -R 755 /var/www/wordpress
COPY /srcs/init_wp.sh /tmp/

EXPOSE 5050

ENTRYPOINT ["sh", "/tmp/init_wp.sh"]