FROM alpine:3.12
LABEL maintainer="vlugand-@student.42.fr"

#NGINX INSTALLATION
RUN apk update && \
	apk add --no-cache nginx && \
	mkdir -p /run/nginx && \
	rm -f /etc/nginx/conf.d/default.conf

#SSL CONF
RUN	apk add --no-cache openssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt >/dev/null 2>&1 && \
	openssl dhparam -out /etc/nginx/dhparam.pem 2048 >/dev/null 2>&1

#IMPORT NGINX CONF 
COPY /srcs/index.html /var/www/
COPY /srcs/server.conf /etc/nginx/conf.d/
COPY /srcs/ssl-params.conf /etc/nginx

EXPOSE 80 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]