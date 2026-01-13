#!/bin/bash
#Actualizamos la lista de paquetes
echo "Actualizando el sistema ------------------------------------------------ "
apt-get update

#Instalamos BIND9
echo "Instalando bind9 ------------------------------------------------ "
apt-get install -y bind9 bind9utils bind9-doc

#Aplicar la configuracion para siempre usar el iPv4
echo "Aplicando configuracion para siempre usar iPv4 ------------------------------------------------ "
cp /vagrant/config/named /etc/default/named

#Configurar la opciones de BIND9
echo "Configurando opciones de BIND9 ------------------------------------------------ "
cp /vagrant/config/named.conf.options /etc/bind/

#Configurar las zonas locales
echo "Configurando zonas locales ------------------------------------------------ "
cp /vagrant/config/named.conf.local /etc/bind/

#Creadno el fichero de la zona directa
echo "Creando el fichero de zona directa ------------------------------------------------ "
cp /vagrant/config/mluna.test.dns /var/lib/bind/

#Creacion del fichera de la zona inversa
echo "Copiando fichero de zona inversa ------------------------------------------------ "
cp /vagrant/config/mluna.test.rev /var/lib/bind/

