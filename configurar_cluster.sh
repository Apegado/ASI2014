#! /bin/bash

DONE=false
until $DONE;
do
    read line || DONE=true
    var1=$(echo $line | awk '{print $1}')
    var2=$(echo $line | awk '{print $2}')
    var3=$(echo $line | awk '{print $3}')
    echo "============================="
    echo $line

    #Vemos que servicio es y llamamos a su script
    case "$var2" in
        "mount") sh ./mount.sh $var1 $var3
        ;;
        "raid") sh ./raid.sh $var1 $var3
        ;;
        "lvm") sh ./lvm.sh $var1 $var3
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