FROM ubuntu:bionic-20181204
LABEL maintainer="sameer@damagehead.com"

ENV SQUID_VERSION=3.5.27 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=proxy

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    net-tools \
    dnsutils \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y squid=${SQUID_VERSION}* \
 && apt-get -y install apache2-utils \
 && mv /etc/squid/squid.conf /etc/squid/squid.conf.dist \
 && rm -rf /var/lib/apt/lists/*

RUN ["apt-get", "update"]
RUN ["apt-get", "install", "-y", "vim"]


COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
