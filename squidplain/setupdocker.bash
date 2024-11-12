#!/bin/bash
#docker stop `docker ps -qaf "name=squid"`
#docker rm `docker ps -qaf "name=squid"`
#docker rmi $(docker images -f "reference=localsameersbn/squid" -q)
docker stop squid
docker rm squid
docker rmi localsameersbn/squid:latest
docker build -t localsameersbn/squid .
docker run --name squid -d --restart=always \
  --publish 3128:3128 \
  --volume /home/services/squidproxy/squid_anon.conf:/etc/squid/squid.conf \
  --volume /home/services/squidproxy/squid_allowed_domains.conf:/etc/squid/squid_allowed_domains.conf \
  --volume /home/services/squidproxy/cache:/var/spool/squid \
  localsameersbn/squid
