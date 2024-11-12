## Forward Proxy

This is squid configuration and docker container is based on the work from https://medium.com/@salmaan.rashid/multi-mode-squid-proxy-container-running-ssl-bump-622128b8482a

Mode intercepts HTTP traffic and uses CONNECT for HTTPS

### squidproxy
```
- Dockerfile
- entrypoint.sh
- setupdocker.bash
- squid_anon.conf
```


The **squid_anon.conf->squid.conf** file loaded into container will have these specific value for this proxy type:

```
acl localhost src 127.0.0.1/32
acl to_localhost dst 127.0.0.0/8
acl localnet src 10.0.0.0/8	# RFC1918 possible internal network
acl localnet src 172.16.0.0/12	# RFC1918 possible internal network
acl localnet src 192.168.0.0/16	# RFC1918 possible internal network
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT
http_access allow all
http_access allow manager localhost
http_access deny manager
http_access deny !Safe_ports
http_access deny CONNECT !SSL_ports
http_access allow localnet
http_access deny all
icp_access allow localnet
icp_access deny all
htcp_access allow localnet
htcp_access deny all
http_port 3128 
cache_mem 8 MB
access_log /var/log/squid/access.log squid
cache_log /var/log/cache.log
pid_filename /var/run/squid.pid
refresh_pattern ^ftp:		1440	20%	10080
refresh_pattern ^gopher:	1440	0%	1440
refresh_pattern (cgi-bin|\?)	0	0%	0
refresh_pattern .		0	20%	4320
icp_port 3130
coredump_dir /var/cache/squid
redirect_children 5
```

**Launch**

Creates docker image localsammeersbn/squid and starts squid container on \<current host\> :port 3128
```
./setupdocker.bash
```

**Verifying proxy**

Find docker container id:

```sudo docker ps -a```

Connect into container to view logs:

```sudo docker exec -i -t <docker continer id> /bin/bash```

Follow logs:

```tail -f /var/log/squid/access.log```


Then in a new window run both http and https or use a browser and set up proxy for Web Proxy (HTTP) and Secure Web Proxy (HTTPS) to point to this proxy server and port.

```
curl -v -k -x <host ip>:3128 -L http://www.bbc.com
curl -v -k -x <host ip>:3128 -L https://www.bbc.com
```

you should see a GET and CONNECT in logs


[BACK](https://bitbucket.ops.expertcity.com/projects/TPAASE/repos/tpaas-proxies/browse)
