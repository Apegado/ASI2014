#!/bin/bash

echo "============================="
echo "Configurando Servidor MOUNT"

#Cogemos las lineas de manera facil con sed
nombreDis=`sed '1q;d' $1`
puntoMontaje=`sed '2q;d' $1`

echo "Intentando montar $nombreDis en $puntoMontaje"
montaje="$nombreDis     $puntoMontaje   auto    auto    0   0";
#Copiamos fstab a fstab.tmp
cat /etc/fstab > fstab.tmp;
#Comprobamos que el dispositivo no se encuentra montado actualmente si no lo esta lo montamos
grep -q $nombreDis fstab.tmp && echo "El dispositivo ya esta en fstab" || (echo "$montaje" >> fstab.tmp && mv fstab.tmp /etc/fstab && mount -t auto && echo "Montaje realizado")