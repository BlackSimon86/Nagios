1
ARG RELEASE
0 B
2
ARG LAUNCHPAD_BUILD_ARCH
0 B
3
LABEL org.opencontainers.image.ref.name=ubuntu
0 B
4
LABEL org.opencontainers.image.version=22.04
0 B
5
ADD file ... in /
28.17 MB
6
CMD ["/bin/bash"]
0 B
7
MAINTAINER Arnaldo Bravo
0 B
8
ENV NAGIOS_HOME=/opt/nagios
0 B
9
ENV NAGIOS_USER=nagios
0 B
10
ENV NAGIOS_GROUP=nagios
0 B
11
ENV NAGIOS_CMDUSER=nagios
0 B
12
ENV NAGIOS_CMDGROUP=nagios
0 B
13
ENV NAGIOS_FQDN=nagios.example.com
0 B
14
ENV NAGIOSADMIN_USER=nagiosadmin
0 B
15
ENV NAGIOSADMIN_PASS=nagios
0 B
16
ENV APACHE_RUN_USER=nagios
0 B
17
ENV APACHE_RUN_GROUP=nagios
0 B
18
ENV NAGIOS_TIMEZONE=UTC
0 B
19
ENV DEBIAN_FRONTEND=noninteractive
0 B
20
ENV NG_NAGIOS_CONFIG_FILE=/opt/nagios/etc/nagios.cfg
0 B
21
ENV NG_CGI_DIR=/opt/nagios/sbin
0 B
22
ENV NG_WWW_DIR=/opt/nagios/share/nagiosgraph
0 B
23
ENV NG_CGI_URL=/cgi-bin
0 B
24
ENV NAGIOS_BRANCH=nagios-4.5.2
0 B
25
ENV NAGIOS_PLUGINS_BRANCH=release-2.4.10
0 B
26
ENV NRPE_BRANCH=nrpe-4.1.0
0 B
27
ENV NCPA_BRANCH=v3.1.0
0 B
28
ENV NSCA_BRANCH=nsca-2.10.2
0 B
29
ENV NAGIOSTV_VERSION=0.9.2
0 B
30
RUN /bin/sh -c echo postfix
218.91 MB
31
RUN /bin/sh -c ( egrep
815 B
32
RUN /bin/sh -c ( id
1.97 KB
33
RUN /bin/sh -c cd /tmp
548.13 KB
34
RUN /bin/sh -c cd /tmp
3.25 MB
35
RUN /bin/sh -c cd /tmp
3.64 MB
36
RUN /bin/sh -c wget -O
4.08 KB
37
RUN /bin/sh -c cd /tmp
65.01 KB
38
RUN /bin/sh -c cd /tmp
97.33 KB
39
RUN /bin/sh -c cd /tmp
107.03 KB
40
RUN /bin/sh -c cd /opt
10.83 MB
41
RUN /bin/sh -c cd /tmp
805.44 KB
42
RUN /bin/sh -c sed -i.bak
1.06 KB
43
RUN /bin/sh -c export DOC_ROOT="DocumentRoot
1019 B
44
RUN /bin/sh -c mkdir -p
2.38 MB
45
RUN /bin/sh -c sed -i
1.83 KB
46
RUN /bin/sh -c cp /etc/services
6.17 KB
47
RUN /bin/sh -c rm -rf
156 B
48
RUN /bin/sh -c rm -rf
32 B
49
ADD overlay / # buildkit
23.14 KB
50
RUN /bin/sh -c echo "use_timezone=${NAGIOS_TIMEZONE}"
13.04 KB
51
RUN /bin/sh -c mkdir -p
67.83 KB
52
RUN /bin/sh -c find /opt/nagios/etc
46.03 KB
53
RUN /bin/sh -c a2enmod session
448 B
54
RUN /bin/sh -c chmod +x
2.03 KB
55
RUN /bin/sh -c cd /opt/nagiosgraph/etc
28.89 KB
56
RUN /bin/sh -c rm /opt/nagiosgraph/etc/fix-nagiosgraph-multiple-selection.sh
193 B
57
RUN /bin/sh -c ln -s
282 B
58
RUN /bin/sh -c chmod u+s
32.76 KB
59
ENV APACHE_LOCK_DIR=/var/run
0 B
60
ENV APACHE_LOG_DIR=/var/log/apache2
0 B
61
RUN /bin/sh -c echo "ServerName
318 B
62
EXPOSE map[5667/tcp:{} 80/tcp:{}]
0 B
63
VOLUME [/opt/nagios/var /opt/nagios/etc /var/log/apache2 /opt/Custom-Nagios-Plugins
0 B
64
CMD ["/usr/local/bin/start_nagios"]
0 B
