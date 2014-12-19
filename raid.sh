#! /bin/bash

echo "============================="
echo "Configurando Servidor RAID"

#Cogemos las lineas de manera facil con sed
nombreDis=`sed '1q;d' $1`
nivelRaid=`sed '2q;d' $1`
dispositivos=`sed '3q;d' $1`

#Calculamos el numero de dispositivos
ndispositivos=$(echo "$dispositivos" | wc -w)

echo "============================="

echo "Instalando mdadm..."
apt-get install mdadm -qq --force-yes > /dev/null

echo "Creando raid $nivelRaid devices $dispositivos"
mdadm --create --level=$nivelRaid --raid-devices=$ndispositivos $nombreDis -R $dispositivos