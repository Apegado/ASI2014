#! /bin/bash

echo "============================="
echo "Configurando Servidor: " $1
echo "Tipo Servidor: raid"
echo "Fichero configuracion"  $2
echo "============================="

nombreDis="";
nivelRaid=-1;
dispositivos="";

linea=0;

DONE=false
until $DONE; do
    read line || DONE=true
    #Vemos que servicio es y llamamos a su script
    case "$linea" in
        0) nombreDis=$line
        ;;
        1) nivelRaid=$line
        ;;
        2) dispositivos=$line
        ;;
    esac
    linea=$((linea+1));
done < $2


ndispositivos=$(echo "$dispositivos" | wc -w)

echo "Datos Leidos:"

echo "$nombreDis";
echo "$nivelRaid";
echo "$dispositivos";
echo "$ndispositivos"


echo "============================="
ssh -oStrictHostKeyChecking=no -t $1 bash -c "'

    echo ""Instalando mdadm""
    echo "".practic@s"" | sudo -S apt-get install -y mdadm >> /dev/null
    echo "" Creando raid $nivelRaid devices $dispositivos""
    echo "".practic@s"" | sudo -S mdadm --create --level=$nivelRaid --raid-devices=$ndispositivos $nombreDis -R $dispositivos

    '"