FROM ubuntu:xenial

## General Dependencies
RUN GEN_DEP_PACKS="software-properties-common \
    language-pack-en-base \
    tmpreaper \
    cron \
    xz-utils \
    zip \
    bzip2 \
    openssl \
    openssh-client \
    curl \
    file" && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get install --no-install-recommends -y $GEN_DEP_PACKS && \
    ## CONFD
    curl -L -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 && \
    chmod +x /usr/local/bin/confd && \
    ## Cleanup phase.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

## S6-Overlay
# @see: https://github.com/just-containers/s6-overlay
ENV S6_OVERLAY_VERSION=${S6_OVERLAY_VERSION:-2.2.0.3}
ADD https://github.com/just-containers/s6-overlay/releases/download/v$S6_OVERLAY_VERSION/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer && \
    /tmp/s6-overlay-amd64-installer /

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en

## Install Varnish && Varnish Agent
# @see: https://packagecloud.io/varnishcache/varnish41
RUN BUILD_DEPS="gnupg-agent" && \
    VARNISH_DEPS="libmicrohttpd10" && \
    apt-get update && \
    apt-get install --no-install-recommends -y $BUILD_DEPS $VARNISH_DEPS && \
    curl -s https://packagecloud.io/install/repositories/varnishcache/varnish41/script.deb.sh | os=ubuntu dist=xenial bash && \
    apt-get update && \
    apt-get install --no-install-recommends -y varnish varnish-agent=4.1.3-12~xenial && \
    ## Cleanup phase.
    apt-get purge -y $BUILD_DEPS --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="ISLE Varnish Image" \
      org.label-schema.description="Optional ISLE Varnish Image." \
      org.label-schema.url="https://islandora-collaboration-group.github.io" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/Islandora-Collaboration-Group/isle-varnish" \
      org.label-schema.vendor="Islandora Collaboration Group (ICG) - islandora-consortium-group@googlegroups.com" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0" \
      traefik.port="6081" \
      traefik.frontend.entryPoints=http,https

COPY rootfs /

## Exposes ports for Varnish, admin panel and agent (if warranted)
EXPOSE 6081 6082

ENTRYPOINT ["/init"]
