FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

#NGINX SETUP
RUN apk update && \
	apk add --no-cache nginx && \
	mkdir -p /run/nginx && \
	rm -f /etc/nginx/conf.d/default.conf

#SSL SETUP
RUN	apk add --no-cache openssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt >/dev/null 2>&1 && \
	openssl dhparam -out /etc/nginx/dhparam.pem 2048 >/dev/null 2>&1

#OPENRC SETUP (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add --no-cache openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

#PHPMYADMIN SETUP
RUN apk add --no-cache wget php7 php7-fpm php7-mysqli php7-mbstring php7-json php7-session php-sockets php7-common php7-opcache php7-zlib php7-curl php7-gd php7-cgi && \
    cd /var/www/localhost/ && wget -q http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz && \
    tar -zxvf phpMyAdmin-5.0.2-all-languages.tar.gz && rm phpMyAdmin-5.0.2-all-languages.tar.gz  && \
    mv phpMyAdmin-5.0.2-all-languages phpmyadmin && \
    chmod -R 777 /var/www/localhost/phpmyadmin/ 

#IMPORT CONFIG
COPY /srcs/server.conf /etc/nginx/conf.d/
COPY /srcs/ssl-params.conf /etc/nginx/
COPY /srcs/config.inc.php /var/www/localhost/phpmyadmin/
COPY /srcs/init_pma.sh /tmp/

#TELEGRAF SETUP
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/
COPY srcs/telegraf.conf etc/telegraf/

EXPOSE 5000

ENTRYPOINT ["sh", "/tmp/init_pma.sh"]