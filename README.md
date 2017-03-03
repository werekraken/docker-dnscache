# dnscache

[![Build Status](https://travis-ci.org/werekraken/docker-dnscache.svg?branch=master)](https://travis-ci.org/werekraken/docker-dnscache)

## Overview

Dockerfile for dnscache, part of the [djbdns](http://cr.yp.to/djbdns/dnscache.html) project.

## Usage

### Start a dnscache instance (recursive)

```console
$ docker run \
    --name some-dnscache \
    -p 192.168.0.254:53:53/udp \
    -p 192.168.0.254:53:53 \
    -v /docker/host/dir/empty_file:/etc/dnscache/root/ip/192.168.0:ro \
    -d werekraken/dnscache
```

### Use a `Dockerfile` instead of volumes (recursive)

```dockerfile
FROM werekraken/dnscache

RUN touch /etc/dnscache/root/ip/192.168.0
```

### Start a dnscache instance (forwarding)

```console
$ docker run \
    --name some-dnscache \
    -p 192.168.0.254:53:53/udp \
    -p 192.168.0.254:53:53 \
    -v /docker/host/dir/empty_file:/etc/dnscache/root/ip/192.168.0:ro \
    -v /docker/host/dir/@:/etc/dnscache/root/servers/@:ro \
    -v /docker/host/dir/FORWARDONLY:/etc/dnscache/env/FORWARDONLY:ro \
    -d werekraken/dnscache
```

### Use a `Dockerfile` instead of volumes (forwarding)

```dockerfile
FROM werekraken/dnscache

RUN touch /etc/dnscache/root/ip/192.168.0
RUN echo '8.8.8.8' > /etc/dnscache/root/servers/@
RUN echo '1' > /etc/dnscache/env/FORWARDONLY
```
