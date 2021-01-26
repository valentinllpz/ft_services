FROM alpine:3.12
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update && \
    apk add grafana --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --no-cache

#RUN	apk add openssl && \
#	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem >/dev/null 2>&1 && \
#	openssl dhparam -out /etc/nginx/dhparam.pem 2048 >/dev/null 2>&1

WORKDIR	/usr/share/grafana

EXPOSE 3000

#CMD ["grafana-server"]