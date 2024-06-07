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

## Instalación Contenedor Nagios 

Para ejecutar estas instrucciones, debe copiar el Docker Pull Command docker pull BlackSimon86/nagios

1.- Iniciamos la instalación de Docker Nagios

```
docker pull BlackSimon86/nagios:latest

```

2.- Realizar los parámetros de configuracion de Nagios 

```
docker run --name nagios4 -p 0.0.0.0:8080:80 BlackSimon86/nagios:latest

```

2.- Una vez listo, abra una pestaña para acceder Nagios con el puerto 8888. Las credenciales de interfaz del acceso es Usuario:nagiosadmin y Contraseña:nagios




3. Publica la imagen compilada
   
    ```
    docker push ghcr.io/OWNER/IMAGE_NAME:TAG
    ```
