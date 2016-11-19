#!/bin/bash

docker run -d --name nginx-master --restart always --network bridge\
           --add-host="master:172.17.0.1"\
           -v ~/www/docker/nginx:/etc/nginx/conf.d -p 80:80 -p 443:443 nfox/nginx
