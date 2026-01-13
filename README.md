# Práctica: Servidor de Aplicaciones Tomcat y Maven

> Mario Luna López 2ºDAW_B

**Repositorio:** *[github.com/mlunlop-iezv/tomcat-y-maven](https://github.com/mlunlop-iezv/tomcat-y-maven)*

---

## 1. Introducción

En esta práctica instalaremos el servidor de aplicaciones **Apache Tomcat** en una máquina virtual gestionada con Vagrant y utilizaremos **Maven** para el despliegue de aplicaciones Java.

* ### Configuración del Vagrantfile

Mantenemos la configuración de red privada con la IP estática **192.168.56.8** para acceder a los servicios desde el navegador del anfitrión.

* ### Preparación de archivos de la práctica

He creado una carpeta `config/` donde he depositado los archivos entregados por el profesor:
* `tomcat1.war`: Aplicación de prueba.
* `context.xml`: Permisos de acceso.
* `tomcat-users.xml`: Definición de usuarios y roles.

## 2. Instalación del Entorno

* ### Automatización en bootstrap.sh

Actualizamos el script de aprovisionamiento para que instale automáticamente el JDK, el servidor Tomcat y Maven.
```bash
# Instalación de tomcat y maven
echo "Instalando tomcat y maven ------------------------------------------------ "
apt-get install -y default-jdk tomcat9 tomcat9-admin mavenvar

```

* ### Verificación de Java y Tomcat

Tras ejecutar `vagrant up`, comprobamos que el servicio está activo:

`systemctl status tomcat9`

<img src="/doc/img/tomcatStatus.png" />


