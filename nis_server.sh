#! /bin/bash

echo "============================="
echo "Configurando Servidor: NIS SERVER"

#Cogemos las lineas de manera facil con sed
nombreDominio=`sed '1q;d' $1`

echo "Instalando nis..."
apt-get install nis -qq --force-yes -y > /dev/null

echo "Creando fichero /etc/defaultdomaion"
echo $nombreDominio > defaultdomain.tmp
mv defaultdomain.tmp /etc/defaultdomain

echo "Modificando fichero /etc/default/nis"
cp /etc/default/nis nis.tmp
cat nis.tmp | sed 's/NISSERVER=false/NISSERVER=true/' | sed 's/NISCLIENT=true/NISCLIENT=false/' > nis2.tmp

mv nis2.tmp /etc/default/nis
rm nis.tmp

echo "Ejecutando /usr/lib/yp/ypinit -m"

/usr/lib/yp/ypinit -m > /dev/null

echo "Reiniciando el servicio NIS..."
service nis restart