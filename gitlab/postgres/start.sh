#!/bin/bash
docker run -v gitlab-pg:/var/lib/postgresql/data \
        --restart=always --name gitlab-db -d \
        --network gitlab \
        nfox/gitlab-postgres
