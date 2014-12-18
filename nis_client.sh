#! /bin/bash

echo "============================="
echo "========= NIS_CLIENT ========"
echo "============================="

echo "Configurando Servidor: " $1
echo "Tipo Servidor: nis_client"
echo "Fichero configuracion"  $2



nombreDominio="";
servidor=""

DONE=false
linea=0;
until $DONE; do
    read line || DONE=true

    #Vemos que servicio es y llamamos a su script
    case "$linea" in
        0) nombreDominio=$line
        ;;
        1) servidor=$line
        ;;
    esac
    linea=$((linea+1));
done < $2

lineayp="domain $nombreDominio server $servidor";
echo $lineayp;

ssh -oStrictHostKeyChecking=no $1 bash -c "'

    echo ""Instalando mdadm""
    echo .practic@s | sudo -S apt-get install -y nis >> /dev/null

    echo ""copiando /etc/default/nis""
    cp /etc/default/nis nis.tmp
    cat nis.tmp | sed 's/NISSERVER=true/NISSERVER=false/' | sed 's/NISCLIENT=false/NISCLIENT=true/' > nis2.tmp

    echo ""copiando yp.conf""
    cat /etc/yp.conf > yp.tmp
    grep -q $servidor yp.tmp && echo ""El servidor ya se encuentra en yp.conf"" ||( echo ""$lineayp"" >> yp.tmp && echo .practic@s | sudo -S mv yp.tmp /etc/yp.conf)

    echo ""Copiando nsswitch.conf""
    cat /etc/nsswitch.conf > nsswitch.tmp
    grep -q ""nis files"" nsswitch.tmp && echo ""El fichero nsswitch ya ha sido modificado, revisar manualmente."" || (echo Intentamos && echo -e ""passwd:  nis files\ngroup: nis files\nshadow: nis files"" >> nsswitch.tmp && echo .practic@s | sudo -S cp nsswitch.tmp /etc/nsswitch.conf)

    '"