#! /bin/bash

echo "============================="
echo "Configurando Servidor: NIS SERVER"

#Cogemos las lineas de manera facil con sed
nombreDominio=`sed '1q;d' $1`

echo "Instalando nis..."
apt-get install nis -qq --force-yes > /dev/null

echo $nombreDominio > defaultdomain.tmp
mv defaultdomain.tmp /etc/defaultdomain

cp /etc/default/nis nis.tmp
cat nis.tmp | sed 's/NISSERVER=false/NISSERVER=true/' | sed 's/NISCLIENT=true/NISCLIENT=false/' > nis2.tmp

mv nis2.tmp /etc/default/nis
rm nis.tmp

/usr/lib/yp/ypinit -m

echo "Reiniciando el servicio NIS..."
service nis restart