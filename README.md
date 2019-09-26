# ISLE Varnish

## Part of the ISLE Islandora 7.x Docker Images
An optional caching / reverse proxy to use for high traffic, improve the speed of complex MySQL queries, Drupal site pages and SOLR searches.

[Varnish](https://varnish-cache.org/) is an HTTP accelerator designed for content-heavy dynamic web sites as well as APIs. Varnish is focused exclusively on HTTP, unlike other proxy servers that often support FTP, SMTP and other network protocols.


**Please note:** This image is designed to be opt-in for `Production` usage by an enduser and is not forced by default ISLE.

Based on:
  - [Ubuntu 16.04 "Xenial"](https://hub.docker.com/_/ubuntu)
  - General Dependencies

Contains and Includes:
  - [Varnish 4.1.11](https://varnish-cache.org/releases/index.html) an HTTP accelerator

Size: `~337 MB`

## Generic Usage

```
docker run -it -p "6081:6081" --rm islandoracollabgroup/isle-varnish bash
```