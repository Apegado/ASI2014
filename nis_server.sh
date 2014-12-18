#! /bin/bash

echo "============================="
echo "Configurando Servidor: " $1
echo "Tipo Servidor: nis_server"
echo "Fichero configuracion"  $2


nombreDominio="";
DONE=false
linea=0
until $DONE; do
    read line || DONE=true
    #Vemos que servicio es y llamamos a su script
    case "$linea" in
        0) nombreDominio=$line
        ;;
    esac
    linea=$((linea+1));
done < $2

ssh -oStrictHostKeyChecking=no -t $1 bash -c "'

    echo ""Instalando mdadm""
    echo "".practic@s"" | sudo -S apt-get install -y nis >> /dev/null
    Creamos la BD inicial
    echo "".practic@s"" | sudo -S /usr/lib/yp/ypinit -m

    cp /etc/default/nis nis.tmp
    cat nis.tmp | sed 's/NISSERVER=false/NISSERVER=true/' | sed 's/NISCLIENT=true/NISCLIENT=false/' > nis2.tmp

    echo "".practic@s"" | sudo -S mv nis2.tmp /etc/default/nis
    rm nis.tmp

    echo ""Reiniciamos el servicio NIS""
    echo "".practic@s"" | sudo -S service nis restart
    '"