#!/bin/bash

echo "============================="
echo "Configurando Servidor: NFS"

echo "Instalando nfs-common y nfs-kernel-sever...."
apt-get install nfs-common -qq --force-yes > /dev/null
apt-get install nfs-kernel-server -qq --force-yes > /dev/null

echo "Añadiendo nuevas entradas a /etc/exports"
while read line || [ -n "$line" ]
do 
  #El enunciado no pone con quien compartir los directorios asi que lo hago con todos...
  "$line *(rw,sync)" >> /etc/exports
done <$1

echo "Reiniciando servicio..."

/etc/init.d/nfs restart