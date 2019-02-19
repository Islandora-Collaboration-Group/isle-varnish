FROM islandoracollabgroup/isle-ubuntu-basebox:serverjre8

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

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en

## tmpreaper - cleanup /tmp on the running container
RUN touch /var/log/cron.log && \
    touch /etc/cron.d/tmpreaper-cron && \
    echo "0 */12 * * * root /usr/sbin/tmpreaper -am 4d /tmp >> /var/log/cron.log 2>&1" | tee /etc/cron.d/tmpreaper-cron && \
    chmod 0644 /etc/cron.d/tmpreaper-cron

ENV VARNISH_PORT=${VARNISH_PORT:-80} \
    VARNISH_BACKEND=${VARNISH_BACKEND:-apache}

## Install Varnish
RUN apt-get update && \
    apt-get install --no-install-recommends -y varnish && \
    ## Cleanup phase.
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
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
EXPOSE 6081 6082 6085

ENTRYPOINT ["/init"]