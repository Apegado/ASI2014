#! /bin/bash
echo "============================="
echo "Configurando Servidor: NIS CLIENTE"

#Cogemos las lineas de manera facil con sed
nombreDominio=`sed '1q;d' $1`
servidor=`sed '2q;d' $1`
lineayp="domain $nombreDominio server $servidor";

echo "Instalando nis..."
apt-get install --force-yes -y nis >/dev/null

echo "Guardamos defaultdomain"
echo $nombreDominio > defaultdomain.tmp
mv defaultdomain.tmp /etc/defaultdomain

echo "copiando yp.conf"
cat /etc/yp.conf > yp.tmp
grep -Fxq $servidor yp.tmp && echo "El servidor ya se encuentra en yp.conf" || echo "$lineayp" >> yp.tmp
mv yp.tmp /etc/yp.conf

echo $lineayp;
nisfiles="nis files"

echo "copiando /etc/default/nis"
cp /etc/default/nis nis.tmp
cat nis.tmp | sed 's/NISSERVER=true/NISSERVER=false/' | sed 's/NISCLIENT=false/NISCLIENT=true/' > nis2.tmp
mv nis2.tmp /etc/default/nis
rm nis.tmp


echo "Copiando nsswitch.conf"
## Esto no funciona
cat /etc/nsswitch.conf > nsswitch.tmp
cat nsswitch.tmp | sed 's/compat/nis files/' > nsswitch2.tmp
mv nsswitch2.tmp /etc/nsswitch.conf
rm nsswitch.tmp

echo "Reiniciando el servicio NIS..."
service nis restart
