#! /bin/bash

while read line
do
    var1=$(echo $line | awk '{print $1}')
    var2=$(echo $line | awk '{print $2}')
    var3=$(echo $line | awk '{print $3}')
    echo "============================="
    echo $line

    #Vemos que servicio es y llamamos a su script
    case "$var2" in
        "raid") sh ./scripts/raid.sh $var1 $var3
        ;;
        "lvm") sh ./scripts/lvm.sh $var1 $var3
        ;;
        "nis_server") sh ./scripts/nis_server.sh $var1 $var3
        ;;
        "nis_client") sh ./scripts/nis_client.sh $var1 $var3
        ;;
        "nfs_server") sh ./scripts/nfs_server.sh $var1 $var3
        ;;
        "nfs_client") sh ./scripts/nfs_client.sh $var1 $var3
        ;;
        "backup_server") sh ./scripts/backup_server.sh $var1 $var3
        ;;
        "backup_client") sh ./scripts/backup_client.sh $var1 $var3
        ;;
    esac
done < $1