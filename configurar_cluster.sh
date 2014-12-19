#!/bin/bash

#Este script lee el fichero de configuracion principal y copia el fichero de configuracion especifico en la 
#maquina destino, copia y ejecuta el script correspondiente y borra ambos ficheros de la maquina remota.

echo "leyendo fichero de configuracion $1"
nLinea=0
while read line || [ -n "$line" ]
do 
  case "$line" in \#*) ((nLinea++)); continue ;; esac #Saltarse comentarios
  
  nParameters=$(echo $line | wc -w)
  if [[ ( "$nParameters" == 0 ) ]]; then
    continue #Saltarse lineas en blanco
  elif [[ ( "$nParameters" > 0 ) && ( "$nParameters" < 3 ) ]]; then #Fallo en parametros, muy pocos
    echo "Error linea $nLinea de $1: Numero de parametros insuficientes" 
    exit 1
  elif [[ ( "$nParameters" > 3 ) ]]; then #Fallo en parametros, demasiados
    echo "Error linea $nLinea de $1: Numero de parametros excesivo"
    exit 1
  fi
  
  #Lectura de parametros de linea (mejor usar awk para hacer funcion de trimming)
  remoteAddress=$(echo $line | awk '{print $1}')
  serviceName=$(echo $line | awk '{print $2}')
  serviceFile=$(echo $line | awk '{print $3}')
  
  echo "Configurando servicio $serviceName en maquina $remoteAddress con fichero de configuracion $serviceFile..."
  echo "Copiando ficheros $serviceFile y $serviceName.sh ..."
         
  scp -oStrictHostKeyChecking=no $serviceFile root@$remoteAddress:  #Copiamos el fichero de configuracion a la maquina remoto
  scp -oStrictHostKeyChecking=no ./$serviceName.sh root@$remoteAddress: #Copiamos el script a la maquina remota
  #Ejecutamos el script (solo con el basename del fichero por si la ruta era absoluta) y borramos los ficheros
  ssh -n -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null root@$remoteAddress "./$serviceName.sh `basename "$serviceFile"`; rm $serviceName.sh; rm `basename "$serviceFile"`"
  ((nLinea++))
done < $1