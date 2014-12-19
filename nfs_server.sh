#!/bin/bash

echo "============================="
echo "Configurando Servidor: NFS"

echo "Instalando nfs-common y nfs-kernel-sever...."
apt-get install nfs-common -qq --force-yes -y > /dev/null
apt-get install nfs-kernel-server -qq --force-yes -y > /dev/null

echo "Añadiendo nuevas entradas a /etc/exports"
while read line || [ -n "$line" ]
do 
  folder="$line *(rw,sync,crossmnt,no_subtree_check)"
  #El enunciado no pone con quien compartir los directorios asi que lo hago con todos...
  grep -Fxq "$folder" /etc/exports && echo "El directorio $line ya esta exportado!" || echo $folder >> /etc/exports
done <$1

echo "Reiniciando servicio..."
service nfs-kernel-server restart