# ISLE Varnish

## Part of the ISLE Islandora 7.x Docker Images
An optional caching / reverse proxy to use for high traffic, improve the speed of complex MySQL queries, Drupal site pages and SOLR searches.

[Varnish](https://varnish-cache.org/) is an HTTP accelerator designed for content-heavy dynamic web sites as well as APIs. Varnish is focused exclusively on HTTP, unlike other proxy servers that often support FTP, SMTP and other network protocols.


**Please note:** This image is designed to be opt-in for usage by an enduser and not forced by default ISLE. This image is also currently in pre-alpha stage and not for general usage as of yet.

Based on:
  - [ISLE-apache](https://github.com/Islandora-Collaboration-Group/isle-apache)
    - Ubuntu 18.04 "Bionic" (@see [ISLE-ubuntu-basebox](https://cloud.docker.com/u/islandoracollabgroup/repository/docker/islandoracollabgroup/isle-ubuntu-basebox)
      - General Dependencies
      - Oracle Java 8 Server JRE

Contains and Includes:
  - [Varnish](https://varnish-cache.org/releases/index.html) 5.2 an HTTP accelerator

Size: TBD

## Generic Usage

```
docker run -it -p "6081:6081" --rm islandoracollabgroup/isle-varnish bash
```

### Default Login information

* TBD