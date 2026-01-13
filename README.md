# Práctica DNS: Configuración de un servidor
> Mario Luna López 2ºDAW_B

**Repositorio:** [_github.com/mlunlop/dns-paso-a-paso_](https://github.com/mlunlop/dns-paso-a-paso)

# Índice

1. [Introducción](#1-introducción)  
   - [Configuración inicial Vagrantfile](#configuracion-inicial-vagrantfile)  
   - [Creación bootstrap.sh](#creacion-_bootsrap.sh_)  
   - [Creación del directorio config/](#creacion-del-directorio-config)  
   - [Primer levantamiento de la máquina](#primer-levantamiento-de-la-maquina)

2. [Instalación y Configuración de BIND9](#2-instalación-y-configuración-de-bind9)  
   - [Instalación de paquetes](#instalacion-de-paquetes)  
   - [Ajuste inicial para IPv4](#ajuste-inicial-para-ipv4)  
   - [Configuración de Opciones (named.conf.options)](#configuración-de-opciones-namedconfoptions)  
   - [Configuración de Zonas Locales (named.conf.local)](#configuración-de-zonas-locales-namedconflocal)  
   - [Creación del Fichero de Zona Directa](#creacion-del-fichero-de-zona-directa)  
   - [Creación de la Zona Inversa](#creación-de-la-zona-inversa)  
     - [Primera parte (Modificación de named.conf.local)](#primer-parte-modificacion-de-namedconflocal)  
     - [Segunda parte (Creación de la zona inversa)](#segunda-parte-creacion-de-la-zona-inversa)

3. [Comprobaciones con dig y nslookup](#3-comprobaciones-con-dig-y-nslookup)  
   - [Comprobación con dig](#comprobacion-con-dig)  
   - [Comprobación con nslookup](#comprobacion-con-nslookup)

4. [Cuestiones finales](#4-cuestiones-finales)


## 1. Introducción
- ### Configuracion inicial Vagrantfile

  Al Vagrantfile le hemos echo la configuracion neceserio para su correcto funcionamiento, qué imagen base utilizara, una ip estatica y la vinculacion con el bootstrap.sh
  
  <img width="500" alt="image" src="/doc/img/vagrantfileConfig.png" />
>[!IMPORTANT]
> Al poner la ip estatica tenemos que tener claro al 100% que esta totalmente libre y disponible en nuestra red

- ### Creacion _bootsrap.sh_

Ahora crearemos el archivo _bootstrap.sh_ en el que iremos segun vaya avanzando la practica los comandos necesarios

- ### Creacion del directorio config/

Necesitamos crear el directorio config/, en el iremos guardando los ficheros necesarios para el servicio

- ### Primer levantamiento de la maquina

Ahora que tenemos todo listo podemos hacer el primer _vagrant up_

## 2. Instalación y Configuración de BIND9

Una vez hemos echo el primer up y con la maquina creada accederemos por SSH _(vagrant ssh)_. Cada paso que funciona se añade al _bootstrap.sh_

- ### Instalacion de paquetes

  Lo primero es instalar los paquetes de BIND9. Añadimos los siguientes comandos al _bootstrap.sh_

  <img width="500" alt="image" src="/doc/img/instalacionBind.png" />

  Ahora tenemos que iniciar de nuevo la maquina, y conectarnod a ella por ssh para hacer un _vagrant provision_ para que se inicie con el _bootstrap.sh_, puedo comprobar que se ha instaldo BIND9 de manera correcta porque al hacer el comando _dpkg -l | grep bind9_ puedo ver que se ha instalado correctamente

- ### Ajuste inicial para IPv4

  Configuramos BIND para que funcione exclusivamente con IPv4, como pide la practica, modificando el fichero _/etc/default/named_

  <img width="500" alt="image" src="/doc/img/modificarNamed.png" />

  Ahora copiamos el archivo _named_ en nuestra carpeta config para despues automatizarlo en el _bootstrap.sh_

  <img width="500" alt="image" src="/doc/img/automatizariPv4.png" />

- ### Configuración de Opciones (named.conf.options)

  Ahora procedemos a configurar el fichero /etc/bind/named.conf.options. Aquí definimos una ACL para nuestra red y ajustamos las directivas listen-on y allow-recursion para que el servidor sea más seguro y solo responda a nuestra red.

  <img width="500" alt="image" src="/doc/img/checkconfOptions.png" />

  >[!IMPORTANT]
  > Previamente es muy recomendable haber realizado una copia de seguridad

  Finalmente, copiamos el archivo named.conf.options ya validado a nuestra carpeta config/ para después añadirlo al bootstrap.sh y así automatizar el proceso.

  <img width="500" alt="image" src="/doc/img/automatizarOptions.png" />

- ### Configuración de Zonas Locales (named.conf.local)

  En este paso declaramos nuestra zona directa 'mluna.test' dentro del fichero _/etc/bind/named.conf.local_. Esto le indica a nuestro servidor BIND que es el "maestro" de esta zona y que la configuración de la misma se encuentra en el fichero _/var/lib/bind/mluna.test.dns_

  <img width="500" alt="image" src="/doc/img/configurarLocal.png" />

  Tras verificar que la sintaxis es correcta con _sudo named-checkconf_, procedemos a copiar el fichero _named.conf.local_ a nuestra carpeta _config/_ para poder automatizar su despliegue en el _bootstrap.sh_

  <img width="500" alt="image" src="/doc/img/automatizarLocal.png" />

- ### Creacion del Fichero de Zona Directa

  Siguiendo la configuración del paso anterior, ahora creamos el fichero /var/lib/bind/mluna.test.dns. Este fichero contiene los registros DNS esenciales, como el SOA (que define la autoridad de la zona) y el registro A, que es el más importante porque traduce el nombre debian.mluna.test a nuestra dirección IP.

  <img width="500" alt="image" src="/doc/img/crearZonaDirecta.png" />

  Una vez creado, es fundamental verificar que la sintaxis del fichero de zona es correcta. Para ello, utilizamos el comando sudo named-checkzone mluna.test /var/lib/bind/mluna.test.dns. La respuesta "OK" nos confirma que todo está en orden.

  <img width="500" alt="image" src="/doc/img/checkzoneDirecta.png.png" />

  Con el fichero ya validado, lo copiamos a la carpeta config/ y añadimos el comando correspondiente en el bootstrap.sh para completar su automatización.

  <img width="500" alt="image" src="/doc/img/automatizarZonaDirecta.png" />

- ### Creación de la Zona Inversa

  - **Primer parte (Modificacion de named.conf.local)**

    Ahora debemos indicarle a BIND que también será el responsable de la zona de resolución inversa. Para ello, volvemos a editar el fichero /etc/bind/named.conf.local y añadimos la declaración de la zona 56.168.192.in-addr.arpa, especificando que su configuración estará en el fichero /var/lib/bind/mluna.test.rev.

    <img width="500" alt="image" src="/doc/img/editarLocal.png" />

    Como siempre, después de guardar el cambio, comprobamos que la sintaxis general del fichero sigue siendo correcta con sudo named-checkconf. Luego, actualizamos nuestra copia del fichero named.conf.local en la carpeta config/ para mantener nuestra automatización al día

    <img width="500" alt="image" src="/doc/img/reautomatizarLocal.png" />

  - **Segunda parte (Creacion de la zona inversa)**

    Ahora creamos el fichero /var/lib/bind/mluna.test.rev que definimos en el paso anterior. El registro más importante aquí es el PTR, que se encarga de hacer la "traduccion" inversa: mapea el último número de nuestra IP (el 8) al nombre de nuestro servidor _debian.mluna.test_

    <img width="500" alt="image" src="/doc/img/crearZonaInversa.png" />

    Validamos este nuevo fichero con el comando sudo named-checkzone 56.168.192.in-addr.arpa /var/lib/bind/mluna.test.rev. Es crucial usar el nombre completo de la zona inversa para que la comprobación funcione. La respuesta "OK" nos indica que es correcto

    <img width="500" alt="image" src="/doc/img/checkzoneInversa.png" />

    Para finalizar, copiamos el fichero _mluna.test.rev_ a nuestra carpeta config/ y añadimos el comando final a nuestro _bootstrap.sh_, completando así toda la automatización de la configuración de BIND

    <img width="500" alt="image" src="/doc/img/automatizarZonaInversaRev.png" />

## 3. Comprobaciones con _dig_ y _nslookup_

- ### Comprobacion con _dig_

  Una vez hemos configurado todo vamos a comprobar que funcione usando _dig_

  Desde el anfrition lanzamos una consila _dig_ apuntando a la IP de nuestro DNS para verificar la resolucion directa

  <img width="500" alt="image" src="/doc/img/comprobacionDig.png" />

  > Como podemos comprobar el _dig_ ha funcionado

- ### Comprobacion con _nslookup_

  Ahora vamos a comprobarlo con _nslookup_ para ver si tambien funciona

  <img width="500" alt="image" src="/doc/img/comprobacionNslookup.png" />

  > Como podemos comprobar con el _nslookup_ tambien ha funcionado

## 4. Cuestiones finales

  1. **¿Qué pasará si un cliente de una red diferente a la tuya intenta hacer uso de tu DNS de alguna**
  **manera, le funcionará? ¿Por qué, en qué parte de la configuración puede verse?** <br>
  No le funcionará para hacer consultas recursivas.  En el fichero _named.conf.options_, la directiva _allow-recursion { confiables; };_ restringe esta función solo a las IPs definidas en la ACL confiables (nuestra red local)
  2. **Por qué tenemos que permitir las consultas recursivas en la configuración?**<br>
  Para que nuestro servidor DNS pueda resolver nombres de dominios que no conoce preguntando a otros servidores DNS en Internet en nombre de nuestros clientes locales
  3. **El servidor DNS que acabáis de montar, ¿es autoritativo?¿Por qué?**<br>
  Sí, es autoritativo para el dominio mluna.test. Lo es porque en el fichero _named.conf.local_, hemos definido la zona con la directiva _type master;_, lo que significa que este servidor es la fuente primaria y oficial de información para ese dominio.
  4. **¿Dónde podemos encontrar la directiva $ORIGIN y para qué sirve?**<br>
  Se define al principio de un fichero de zona. Sirve para autocompletar los nombres de dominio que no terminan en un punto
  5. **¿Una zona es idéntico a un dominio?**<br>
  No, un dominio es un nombre lógico (ej. marca.es), mientras que una zona es la parte del espacio de nombres de dominio que está gestionada por un servidor DNS espcifico 
  6. **¿Cuántos servidores raíz existen?**<br>
  Existen 13 servidores raíz lógicos, nombrados con las letras de la A a la M pero físicamente hay cientos de servidores distribuidos por todo el mundo que usan estas 13 direcciones IP para garantizar la redundancia y rapidez
  7. **¿Qué es una consulta iterativa de referencia?**<br>
  Es una consulta en la que el servidor DNS no da la respuesta final, sino que refiere al cliente a otro servidor DNS que podría tener la respuesta
  8. **En una resolución inversa, ¿a qué nombre se mapearía la dirección IP 172.16.34.56?**<br>
  Se mapearia al nombre 56.34.16.172.in-addr.arpa