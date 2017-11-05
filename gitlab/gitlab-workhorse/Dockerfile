FROM alpine:latest as builder
ARG VERSION=3.2.0
RUN set -x \
    && apk --no-cache add go git make musl-dev

RUN set -x \
    && git clone https://gitlab.com/gitlab-org/gitlab-workhorse.git \
    && cd gitlab-workhorse \
    && git checkout v${VERSION} \
    && make

FROM alpine:latest
MAINTAINER Nickolas Fox <tarvitz@blacklibrary.ru>
LABEL com.gitlab="workhorse"
RUN set -x \
    && apk --no-cache add ca-certificates

WORKDIR /home/git/gitlab-workhorse
COPY --from=builder /gitlab-workhorse/gitlab-workhorse \
    /gitlab-workhorse/gitlab-zip-cat \
    /gitlab-workhorse/gitlab-zip-metadata /bin/

VOLUME ["/home/git/gitlab-workhorse"]
ENTRYPOINT ["gitlab-workhorse"]
