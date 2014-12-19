#!/bin/bash

#Este script lee el fichero de configuracion principal y copia el fichero de configuracion especifico en la 
#maquina destino, copia y ejecuta el script correspondiente y borra ambos ficheros de la maquina remota.

echo "leyendo fichero de configuracion $1"
while read line || [ -n "$line" ]
do 
  case "$line" in \#*) continue ;; esac #Saltarse comentarios
  
  #Lectura de parametros de linea (mejor usar awk para hacer funcion de trimming)
  remoteAddress=$(echo $line | awk '{print $1}')
  serviceName=$(echo $line | awk '{print $2}')
  serviceFile=$(echo $line | awk '{print $3}')
  
  if [ -z "$remoteAddress" ] || [ -z "$serviceName" ] || [ -z "$serviceFile" ]; then
    continue #Saltarse lineas en blanco
  fi
  
  echo "Configurando servicio $serviceName en maquina $remoteAddress con fichero de configuracion $serviceFile..."
  echo "Copiando ficheros $serviceFile y $serviceName.sh ..."
         
  scp $serviceFile root@$remoteAddress:  #Copiamos el fichero de configuracion a la maquina remoto
  scp ./$serviceName.sh root@$remoteAddress: #Copiamos el script a la maquina remota
  #Ejecutamos el script (solo con el basename del fichero por si la ruta era absoluta) y borramos los ficheros
  ssh -n -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@$remoteAddress "./$serviceName.sh `basename "$serviceFile"`; rm $serviceName.sh; rm `basename "$serviceFile"`"
  
done < $1