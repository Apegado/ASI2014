#!/bin/bash

echo "============================="
echo "Configurando Servidor LVM"

groupName=""
groupDevices=""

#Instalacion de lvm2
echo "Instalando lvm2...."
apt-get install lvm2 -qq --force-yes > /dev/null

#Lectura de fichero de config
nLine=0
while read line || [ -n "$line" ]
do 
  case "$line" in \#*) continue ;; esac #Saltarse comentarios
  case "$nLine" in
    0)  groupName=$line
        ;;
    1)  groupDevices=$line
        echo "Creando grupo de volumenes $groupName, con dispositivos $groupDevices"
        vgcreate $groupName $groupDevices > /dev/null #Redirigimos la stdout y dejamos sterr por si pasa algo
        ;;
    *)  volumeName=""
        volumeSize=""
        nWord=0
        for word in $line
        do
          case "$nWord" in
            0) volumeName=$word
               ;;
            1) volumeSize=$word
               ;;
          esac
          ((nWord++))
        done
        echo "Añadiendo volumen $volumeName con $volumeSize al grupo $groupName"
        lvcreate --name $volumeName --size $volumeSize $groupName > /dev/null #Redirigimos la stdout y dejamos sterr por si pasa algo
        ;;
  esac

   ((nLine++))
done < $1
exit 0