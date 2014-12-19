#!/bin/bash

echo "============================="
echo "Configurando Servidor: NFS CLIENT"

echo "Instalando nfs-common...."
apt-get install nfs-common -qq --force-yes > /dev/null

while read line || [ -n "$line" ]
do 
  $remoteDir=$(echo $line | awk '{print $1}')
  $localDir=$(echo $line | awk '{print $2}')
  echo "Montando $remoteDir en $localDir"
  echo "$remoteDir     $localDir   nfs    rsize=8192,wsize=8192,timeo=14,intr" >> /etc/fstab
done <$1

echo "Recargando fstab..."
mount -t auto