FROM alpine:3.13
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update && \
    apk add --no-cache grafana --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/

RUN apk add --no-cache openssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/C=FR/ST=75017/L=Paris/O=42/CN=localhost' -keyout /etc/ssl/private/key.pem -out /etc/ssl/certs/cert.pem >/dev/null 2>&1

RUN mv usr/share/grafana/conf/sample.ini usr/share/grafana/conf/custom.ini && \
    sed -i "s/;protocol = http/protocol = https/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;cert_file =/cert_file = \/etc\/ssl\/certs\/cert.pem/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;cert_key =/cert_key = \/etc\/ssl\/private\/key.pem/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;admin_user = admin/admin_user = grafana_vlugand-/" /usr/share/grafana/conf/custom.ini && \
    sed -i "s/;admin_password = admin/admin_password = grafana@ft_53rv1c35/" /usr/share/grafana/conf/custom.ini

COPY /srcs/init_grafana.sh /tmp/
COPY /srcs/grafana.db /usr/share/grafana/data/

#TELEGRAF SETUP
RUN apk add --no-cache telegraf --repository http://dl-cdn.alpinelinux.org/alpine/v3.13/community/ && \
    mkdir -p etc/telegraf/
COPY /srcs/telegraf.conf /etc/telegraf/

EXPOSE 3000

ENTRYPOINT ["sh", "tmp/init_grafana.sh"]