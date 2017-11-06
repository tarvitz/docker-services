#!/bin/bash
docker build --add-host=redis:127.0.0.1 -t nfox/gitlab-build -f Dockerfile .
