FROM nginx:alpine
MAINTAINER Nickolas Fox <tarvitz@blacklibrary.ru>
LABEL com.gitlab="nginx"
COPY resources/ /etc/nginx/
RUN set -x \
    && rm -f /etc/nginx/conf.d/default.conf
