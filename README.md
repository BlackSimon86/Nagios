# Instalacion de Docker y contenedor Nagios 

<p align="left" style="text-align:left;">
  <a href="https://docs.aws.amazon.com/es_es/serverless-application-model/latest/developerguide/install-docker.html">
    <img alt="Pasos de instalacion Docker en AWS" src="img/logo.png" width="1040"/>
  </a>
</p>

## Instalación Docker en AWS CLI

1.-Actualice la caché de paquetes y los paquetes instalados en la instancia.

```
sudo yum update -y
```

2.- Para Amazon Linux 2023, ejecute lo siguiente:

```
sudo yum install -y docker
```

3.- Inicie el servicio Docker.

```
sudo service docker start
```

4.- Agregue el ec2-user al grupo docker para que pueda ejecutar comandos de Docker sin usar sudo.

```
sudo usermod -a -G docker ec2-user
```
5.-Cierre sesión y vuelva a iniciarla para actualizar los nuevos permisos de grupo de docker. Para ello, cierre la ventana de su terminal de SSH actual y vuelva a conectarse a su instancia en una ventana nueva. De esta forma, la nueva sesión de SSH debería tener los permisos de grupo de docker adecuados.

6.-Compruebe que el ec2-user puede ejecutar comandos de Docker sin sudo.

```
docker ps
```
Debería ver el siguiente resultado, lo que confirma que Docker está instalado y en ejecución:

 CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

 ## Crear y construir Nagios con Docker Image

1.- Crear un directorio en /opt

```
mkdir /opt/nagios

```
2.- Crear un directorio en /opt

```
cd /opt/nagios/

```
3.- Descarga version Nagios

```
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.9.tar.gz

```

4.- extrae la fuente

```
tar xzf nagios-4.4.9.tar.gz

```

5.- extrae la fuente

```
tar xzf nagios-4.4.9.tar.gz

```

6.- Verificar directorio nagios

```
ls -d1 */

```
Debe aparecer nagios-4.4.9/

## Construccion de nagios en codigo fuente

1.- Se crea un archivo VIM

```
vim Dockerfile

```
Dentro del archivo debe pegar el siguiente contenido

FROM ubuntu:22.04
RUN apt update -y
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive 
RUN apt install -y \
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
# Building Nagios Core
COPY nagios-4.4.9 /nagios-4.4.9
WORKDIR /nagios-4.4.9
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
# Building Nagios Plugins
COPY nagios-plugins-2.4.2 /nagios-plugins-2.4.2
WORKDIR /nagios-plugins-2.4.2
RUN ./configure --with-nagios-user=nagios --with-nagios-group=nagios && \
    make && \
    make install
# Build and Install NRPE Plugins
COPY nrpe-4.1.0 /nrpe-4.1.0
WORKDIR /nrpe-4.1.0
RUN ./configure && \
    make all && \
    make install-plugin
WORKDIR /root
# Copy the Nagios basic auth credentials set in the env file;
COPY .env /usr/local/nagios/etc/
# Add Nagios and Apache Startup script
ADD start.sh /
RUN chmod +x /start.sh

CMD [ "/start.sh" ]


2.- Crea una variable de entorno en vim 

```
vim .env

```
Debe pegar lo siguiente:

NAGIOSADMIN_USER=nagiosadmin
NAGIOSADMIN_PASSWORD=nagios

3.- Al final de Dockerfile verificar el Scrip de nagios y apache llamado start.sh

```
cat start.sh

```
Verificara el siguiente contenido de configuracion

!/bin/bash
# Load the credentials variables
source /usr/local/nagios/etc/.env

# Override the environment variables if passed as arguments during docker run
if [ -n "$NAGIOSADMIN_USER_OVERRIDE" ]; then
    export NAGIOSADMIN_USER="$NAGIOSADMIN_USER_OVERRIDE"
fi

if [ -n "$NAGIOSADMIN_PASSWORD_OVERRIDE" ]; then
    export NAGIOSADMIN_NAGIOS="$NAGIOSADMIN_NAGIOS_OVERRIDE"
fi

# Update configuration files with the variable values, considering overrides
htpasswd -b -c /usr/local/nagios/etc/htpasswd.users "${NAGIOSADMIN_USER_OVERRIDE:-$NAGIOSADMIN_USER}" "${NAGIOSADMIN_NAGIOS_OVERRIDE:-$NAGIOSADMIN_NAGIOS}"
sed -i "s/nagiosadmin/${NAGIOSADMIN_USER_OVERRIDE:-$NAGIOSADMIN_USER}/g" /usr/local/nagios/etc/cgi.cfg

# Redirect root URL (/) to /nagios
echo 'RedirectMatch ^/$ /nagios' >> /etc/apache2/apache2.conf

# Start Nagios
/etc/init.d/nagios start

#Start Apache
a2dissite 000-default default-ssl
rm -rf /run/apache2/apache2.pid
. /etc/apache2/envvars
. /etc/default/apache-htcacheclean
/usr/sbin/apache2 -DFOREGROUND


4.- Construir la imagen de nagios

```
docker build -t nagios:4.4.9 .

```
verifica el siguiente comando "docker images"

Debe aparecer 

REPOSITORY           TAG       IMAGE ID       CREATED          SIZE
nagios         4.4.9     7c4a7e95a2b0   9 minutes ago   753MB

## Despliegue Nagios como contenedor Docker

Realizar correr Docker con Nagios

1.- Arranca la instalación de Docker Nagios

```
docker run --name nagios-core-4.4.9 -dp 80:80 nagios-core:4.4.9

```

2.- Verificar el funcionamiento del contenedor creado

```
docker container ls

```
3.- Verificar que acceda al portal nagios

http://docker-host-IP-or-hostname:8080/nagios/


4.- Una vez listo, abra una pestaña para acceder Nagios con el puerto 8080. Las credenciales de interfaz del acceso es Usuario:nagiosadmin y Contraseña:nagios





