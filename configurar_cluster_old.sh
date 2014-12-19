#!/bin/bash

#Nueva aproximacion, se copia el script en la maquina destino, se ejecuta y despues se borra.

DONE=false
until $DONE;
do
    read line || DONE=true
    var1=$(echo $line | awk '{print $1}')
    var2=$(echo $line | awk '{print $2}')
    var3=$(echo $line | awk '{print $3}')
    #var3base=`basename $var3`
    echo "============================="
    echo $line

    #Vemos que servicio es y llamamos a su script
    case "$var2" in
        "mount") scp $var3 root@$var1:  #Copiamos el fichero de configuracion a la maquina remoto
                 ssh root@$var1 'bash -s' < ./mount.sh $var3 #Ejecutamos el script en la maquina remota y le pasamos solo el nombre del fichero como ruta (por si la que recibimos de entrada era absoluta)
                 ssh root@$var1 `rm $var3base`
        ;;
        "raid") sh ./raid.sh $var1 $var3
        ;;
        "lvm") scp $var3 root@$var1:  #Copiamos el fichero de configuracion a la maquina remoto
                 ssh root@$var1 'bash -s' < ./lvm.sh $var3 #Ejecutamos el script en la maquina remota y le pasamos solo el nombre del fichero como ruta (por si la que recibimos de entrada era absoluta)
                 #ssh root@$var1 `rm $var3base`
        ;;
        "nis_server") sh ./nis_server.sh $var1 $var3
        ;;
        "nis_client") sh ./nis_client.sh $var1 $var3
        ;;
        "nfs_server") sh ./nfs_server.sh $var1 $var3
        ;;
        "nfs_client") sh ./nfs_client.sh $var1 $var3
        ;;
        "backup_server") sh ./backup_server.sh $var1 $var3
        ;;
        "backup_client") sh ./backup_client.sh $var1 $var3
        ;;
    esac
done < $1