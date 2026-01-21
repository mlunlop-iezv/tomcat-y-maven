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

## 3. Configuración de Servidor

* ### Gestión de Usuarios (tomcat-users.xml)

Para poder usar la aplicación web "Manager", necesitamos definir un usuario con los roles `manager-gui` y `admin-gui`. Usamos el archivo proporcionado:
```bash
sudocp /vagrant/config/tomcat-users.xml /etc/tomcat9/tomcat-users.xml

```

* ### Acceso Externo (context.xml)

En Debian, las aplicaciones de administración están en /usr/share/
```bash
sudo cp /vagrant/config/context.xml /usr/share/tomcat9-admin/manager/META-INF/context.xml
sudo cp /vagrant/config/context.xml /usr/share/tomcat9-admin/host-manager/META-INF/context.xml
```

Reiniciamos el servicio
```bash
sudo systemctl restart tomcat9
```

## 4. Despliegue de Aplicaciones

* ### Despliegue de tomcat1.war (Manager App)

Accedemos a http://192.168.56.8:8080/manager/html. Subimos el archivo tomcat1.war y verificamos su ejecución.

<img src="/doc/img/despliegueOk.png" />

* ### Despliegue de Web Estática (tomcat-html.zip)

Además de aplicaciones Java complejas, Tomcat puede servir páginas web estáticas. Hemos descomprimido el archivo tomcat-html.zip y copiado la carpeta resultante al directorio de aplicaciones de Tomcat.

```bash
# Comando añadido al bootstrap.sh o ejecutado manualmente
# Suponiendo que hemos descomprimido el zip en config/tomcat-html
sudo cp -r /vagrant/config/tomcat-html /var/lib/tomcat9/webapps/
```

Podemos verificar que funciona accediendo a http://192.168.56.8:8080/tomcat-html.

<img src="/doc/img/webEstatica.png" />

## 5. Despliegue de "Rock Paper Scissors"

Siguiendo las instrucciones encontradas en la web estática desplegada anteriormente ("Tarea"), procedemos a desplegar una segunda aplicación real obtenida de GitHub.

* ### Clonado y preparación

Clonamos el repositorio y cambiamos a la rama patch-1 tal como se indica:

```bash
git clone https://github.com/cameronmcnz/rock-paper-scissors.git
cd rock-paper-scissors
git checkout patch-1
```

* ### Configuración del pom.xml

Editamos el pom.xml de la aplicación descargada para añadir el plugin de despliegue tomcat7-maven-plugin, configurando las credenciales de nuestro servidor y la ruta de despliegue /juego.

```xml
<plugins>
 <plugin>
    <groupId>org.apache.tomcat.maven</groupId>
    <artifactId>tomcat7-maven-plugin</artifactId>
    <version>2.2</version>
    <configuration>
    <url>http://192.168.56.8:8080/manager/text</url>
    <server>TomcatServer</server>
    <path>/juego</path>
    <username>deploy</username>
    <password>1234</password>
    </configuration>
 </plugin>
</plugins>
```

* ### Despliegue y Verificación

Ejecutamos mvn tomcat7:deploy desde la carpeta del proyecto. Tras el mensaje de éxito, accedemos a http://192.168.56.8:8080/juego.

<img src="/doc/img/juego.png"/>