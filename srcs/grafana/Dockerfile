FROM alpine:3.12
LABEL maintainer="vlugand-@student.42.fr"

RUN apk update && \
    apk add grafana --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --no-cache

WORKDIR	/usr/share/grafana

EXPOSE 3000

CMD ["grafana-server"]