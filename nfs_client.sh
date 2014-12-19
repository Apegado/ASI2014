#!/bin/bash

echo "============================="
echo "Configurando Servidor: NFS CLIENT"

echo "Instalando nfs-common...."
apt-get install nfs-common -qq --force-yes -y > /dev/null

while read line || [ -n "$line" ]
do 
  remoteFull=$(echo $line | awk '{print $1}')
  
  remoteAddress=$(echo $remoteFull | grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)')
  remoteDir=${remoteFull#$remoteAddress}
  
  localDir=$(echo $line | awk '{print $2}')
  echo "Montando $remoteAddress:$remoteDir en $localDir"  
  mkdir --parents $localDir > /dev/null
  echo "$remoteAddress:$remoteDir     $localDir   nfs    rsize=8192,wsize=8192,timeo=14,intr" >> /etc/fstab

done <$1

echo "Recargando fstab..."
mount -a