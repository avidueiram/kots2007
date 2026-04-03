FROM alpine:3.23

RUN apk add --no-cache \
    build-base \
    make \
    curl-dev \
    mariadb-connector-c-dev \
    pkgconf \
    git \
    bash \
    && ln -sf /usr/bin/mariadb_config /usr/bin/mysql_config

WORKDIR /workspace

CMD ["bash"]
