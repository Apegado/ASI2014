#! /bin/bash

echo "============================="
echo "Configurando Servidor: " $1
echo "Tipo Servidor: raid"
echo "Fichero configuracion"  $2

nombreDis="";
puntoMontaje="";

linea=0;

DONE=false
until $DONE; do
    read line || DONE=true
    #Vemos que servicio es y llamamos a su script
    case "$linea" in
        0) nombreDis=$line
        ;;
        1) puntoMontaje=$line
        ;;
    esac
    linea=$((linea+1));
done < $2

echo "Datos Leidos"

echo "$nombreDis";
echo "$puntoMontaje";
echo "============================="
montaje="$nombreDis     $puntoMontaje   auto    auto    0   0";
echo $montaje;

ssh -oStrictHostKeyChecking=no -t $1 bash -c "'

    echo ""guardamos el fichero en fstab.tmp""
    cat /etc/fstab > fstab.tmp;
    echo ""Comprobamos que no este previamente montado.""

    noMontado=true
    fstab=""/etc/fstab""

    grep -q $nombreDis fstab.tmp && echo ""El dispositivo ya esta en fstab"" || (echo ""Intentamos"" && echo ""$montaje"" >> fstab.tmp && echo "".practic@s"" | sudo -S mv fstab.tmp /etc/fstab;sudo -S mount -t auto)

'"