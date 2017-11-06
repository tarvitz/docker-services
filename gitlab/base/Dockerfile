FROM alpine:latest
MAINTAINER Nickolas Fox <tarvitz@blacklibrary.ru>
ARG GITLAB_SOURCES=archive.tar.gz

ENV BIN_DEPS="zlib yaml libressl gdbm libre2 readline libffi curl \
              tzdata libxml2 libxslt icu git gettext libpq go gcc g++" \
    BUILD_DEPS="make musl-dev zlib-dev yaml-dev libressl-dev gdbm-dev libre2-dev \
                readline-dev libffi-dev libxml2-dev libxslt-dev icu-dev\
                py2-docutils cmake ruby-dev postgresql-dev linux-headers" \
    RUBY_DEPS="ruby-bundler ruby-bigdecimal ruby-irb ruby-rake" \
    NODEJS_DEPS="nodejs yarn"
ADD ${GITLAB_SOURCES} /home/git/

#: heavy ruby dependencies
RUN set -x \
    && echo "renaming artifact to gitlab" \
    \
    && mv /home/git/gitlab-ce-*/ /home/git/gitlab

WORKDIR /home/git/gitlab
RUN set -x \
    && apk update && apk upgrade \
    && apk add ${BIN_DEPS} ${BUILD_DEPS} ${RUBY_DEPS} ${NODEJS_DEPS}

RUN set -x \
    && /usr/bin/git config --global core.autocrlf "input" \
    && /usr/bin/git config --global gc.auto 0 \
    && /usr/bin/git config --global repack.writeBitmaps true

RUN set -x \
    && bundle install --deployment --without development test mysql aws kerberos \
    \
    cp lib/support/init.d/gitlab /etc/init.d/gitlab

#: config which are needed to configure image, real configs should go after
#: setup is ready
COPY setup/* config/

RUN set -x \
    && echo "setup temporary runtime environment dependencies" \
    && apk add redis \
    && redis-server&

#: install frontend dependencies
RUN set -x \
    && yarn install --production --pure-lockfile \
    \
    && echo "a hotfix" \
    && yarn add ajv@4.11.2

RUN set -x \
    && bundle exec rake gitlab:assets:compile RAILS_ENV=production NODE_ENV=production

RUN set -x \
    && bundle exec rake gitlab:shell:install REDIS_URL=redis://redis:6379 \
                                             RAILS_ENV=production \
                                             SKIP_STORAGE_VALIDATION=true

