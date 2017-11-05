FROM alpine:latest
MAINTAINER Nickolas Fox <tarvitz@blacklibrary.ru>
LABEL com.gitlab="gitlab"

WORKDIR /home/git/gitlab
COPY --from=nfox/gitlab-build /home/git/gitlab-shell/ /home/git/gitlab-shell/
COPY --from=nfox/gitlab-build /home/git/gitlab/ /home/git/gitlab/

RUN set -x \
    && apk --no-cache add ruby-bundler ruby-bigdecimal ruby-irb \
                          ca-certificates git libpq tzdata icu libre2 nodejs

#: configure gitlab environment
RUN set -x \
    && /usr/bin/git config --global core.autocrlf "input" \
    && /usr/bin/git config --global gc.auto 0 \
    && /usr/bin/git config --global repack.writeBitmaps true \
    \
    && mkdir /home/git/secrets \
    && chmod 700 /home/git/secrets \
    && cp .gitlab_workhorse_secret /home/git/secrets \
    && ln -sf /home/git/secrets/.gitlab_workhorse_secret .

VOLUME [ "/home/git/repositories", "/home/git/secrets" ]

COPY configs/* config/
CMD ["bundle", "exec", "unicorn_rails", "-c", "config/unicorn.rb", "-E", "production"]

