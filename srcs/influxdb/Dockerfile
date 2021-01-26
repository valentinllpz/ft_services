FROM alpine:3.12

# OPENRC SETUP (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

# INFLUXDB SETUP
RUN apk update && \
    apk add influxdb --no-cache 
# RUN   service influxdb start && \
 #   influx -execute "CREATE DATABASE metrics" && \
  #  influx -execute "CREATE USER 'vlugand-' WITH PASSWORD 'influxdb@ft_53rv1c35'" && \ 
   # influx -execute "GRANT ALL ON 'influxdb' TO 'vlugand-'" && \
    #influx -execute "FLUSH PRIVILEGES"

# TELEGRAF SETUP
RUN apk add telegraf --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --no-cache && \
    mkdir -p etc/telegraf/

COPY srcs/telegraf.conf etc/telegraf
COPY srcs/init_influxdb.sh tmp

EXPOSE 8086

CMD ["sh", "tmp/init_influxdb.sh"]