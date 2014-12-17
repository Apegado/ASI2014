#! /bin/bash

echo "============================="
echo "Configurando Servidor: " $1
echo "Tipo Servidor: raid"
echo "Fichero configuracion"  $2

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

echo "Datos Leidos"

echo "$nombreDis";
echo "$nivelRaid";
echo "$dispositivos";

echo "============================="