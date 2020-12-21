FROM phpmyadmin/phpmyadmin:fpm-alpine
MAINTAINER Naji Mehdi (mnaji@student.42.fr)

RUN apk update && \
	apk add nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint /entrypoint

ENTRYPOINT sh /entrypoint
