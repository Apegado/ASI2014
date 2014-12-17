#! /bin/bash


    echo "guardamos el fichero en fstab.tmp"
    cat /etc/fstab > fstab.tmp;
    echo "comprobamos que no este previamente montado."

    noMontado=true
    fstab="/etc/fstab"

    grep -q "/dev" fstab.tmp && noMontado=false
