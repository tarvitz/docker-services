#!/bin/bash
docker run -d --name nginx-master --restart always \
           -v ~/www/docker/nginx:/etc/nginx/conf.d -p 80:80 -p 443:443 nfox/nginx
