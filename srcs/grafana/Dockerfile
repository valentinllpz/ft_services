FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update

### TELEGRAF SETUP ###
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/ && \
    mkdir -p /var/log/telegraf/ && \
    touch /var/log/telegraf/telegraf.log
COPY /srcs/telegraf.conf /etc/telegraf/

### SSL SETUP ###
RUN apk add --no-cache openssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem >/dev/null 2>&1

### GRAFANA SETUP ###
RUN apk add --no-cache grafana --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
	mv usr/share/grafana/conf/sample.ini usr/share/grafana/conf/custom.ini && \
    sed -i "s/;protocol = http/protocol = https/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;cert_file =/cert_file = \/etc\/ssl\/certs\/cert.pem/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;cert_key =/cert_key = \/etc\/ssl\/private\/key.pem/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;admin_user = admin/admin_user = grafana_vlugand-/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;admin_password = admin/admin_password = Z3JhZmFuYUBmdF81M3J2MWMzNQo=/" /usr/share/grafana/conf/custom.ini
COPY /srcs/init_grafana.sh /tmp/
COPY /srcs/grafana.db /usr/share/grafana/data/

EXPOSE 3000

ENTRYPOINT ["sh", "tmp/init_grafana.sh"]