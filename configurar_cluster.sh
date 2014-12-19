#!/bin/bash

#Este script lee el fichero de configuracion principal y copia el fichero de configuracion especifico en la 
#maquina destino, ejecuta el script correspondiente y borra el fichero de configuracion especifico de la maquina remota.

echo "leyendo fichero de configuracion $1"
while read line || [ -n "$line" ]
do 
  case "$line" in \#*) continue ;; esac #Saltarse comentarios
  
  nWord=0
  for word in $line
  do
    case "$nWord" in
      0) remoteAddress=$word
      ;;

      1) serviceName=$word
      ;;

      2) serviceFile=$word
         echo "Configurando servicio $serviceName en maquina $remoteAddress con fichero de configuracion $serviceFile..."
         echo "Copiando ficheros $serviceFile y $serviceName.sh ..."
         
         scp $serviceFile root@$remoteAddress:  #Copiamos el fichero de configuracion a la maquina remoto
         scp ./$serviceName.sh root@$remoteAddress: #Copiamos el script a la maquina remota
         #Ejecutamos el script (solo con el basename del fichero por si la ruta era absoluta) y borramos los ficheros
         ssh -n -oStrictHostKeyChecking=no root@$remoteAddress "./$serviceName.sh `basename "$serviceFile"`; rm $serviceName.sh; rm `basename "$serviceFile"`" 
      ;;
    esac
    ((nWord++))
  done
done < $1