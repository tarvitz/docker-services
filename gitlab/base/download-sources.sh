#!/bin/bash

if [ -z $1 ]; then
    echo "please sepcify version, for example 10.0.4"
    exit 1
fi
wget -c https://gitlab.com/gitlab-org/gitlab-ce/repository/v${1}/archive.tar.gz
