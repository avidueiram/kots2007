FROM nephatrine/quake2-q2pro:latest

USER root

RUN apk add --no-cache gcompat mariadb-connector-c \
	&& ln -sf /usr/lib/libmariadb.so.3 /usr/lib/libmysqlclient.so.21
