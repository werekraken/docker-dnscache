FROM ubuntu:14.04
MAINTAINER Matt Cover <werekraken@gmail.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    daemontools \
    daemontools-run \
    djbdns \
    ucspi-tcp \
  && rm -rf /var/lib/apt/lists/*

RUN useradd -s /bin/false dnscache \
  && useradd -s /bin/false dnslog

RUN dnsip `dnsqr ns . | awk '/answer:/ { print $5; }' | sort` > /etc/dnsroots.global

RUN dnscache-conf dnscache dnslog /etc/dnscache 0.0.0.0 \
  && ln -s /etc/dnscache /etc/service/dnscache

RUN mkdir /dnscache

EXPOSE 53/udp 53

VOLUME /dnscache

CMD ["svscan", "/etc/service"]
