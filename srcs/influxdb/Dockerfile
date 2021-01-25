FROM alpine:3.12

RUN apk update && \
    apk add influxdb --no-cache

#OPENRC SETUP (FOR SYSTEMS NOT BOOTED BY OPENRC)
RUN apk add openrc && \
    mkdir -p /run/openrc && \
    touch /run/openrc/softlevel && \
    openrc >/dev/null 2>&1

EXPOSE 8086