FROM ubuntu:22.04
RUN apt-get update
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive 
RUN apt-get install -y \
	autoconf \
	gcc \
	libc6 \
	make \
	wget \
	unzip \
	apache2 \
	apache2-utils \
	php \
	libapache2-mod-php \
	libgd-dev \
	libssl-dev \
	libmcrypt-dev \
	bc \
	gawk \
	dc \
	build-essential \
	snmp \
	libnet-snmp-perl \
	gettext \
	fping \
    iputils-ping \
	qstat \
	dnsutils \
	smbclient

RUN useradd nagios
# Building Nagios Core
WORKDIR /nagios
RUN wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.5.2.tar.gz
RUN tar xzf nagios-4.5.2.tar.gz
WORKDIR /nagios/nagios-4.5.2
RUN ./configure --with-httpd-conf=/etc/apache2/sites-enabled && \
    make all && \
    make install-groups-users && \
    usermod -aG nagios www-data && \
    make install && \
    make install-init && \
    make install-daemoninit && \
    make install-commandmode && \
    make install-config && \
    make install-webconf && \
    a2enmod rewrite cgi

RUN htpasswd -b -c /usr/local/nagios/etc/htpasswd.users nagiosadmin admin

RUN a2enmod rewrite
RUN a2enmod cgi

RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /usr/local/nagios/share|' /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80

CMD service nagios start && apachectl -D FOREGROUND
