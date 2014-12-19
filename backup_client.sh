#!/bin/bash

echo "============================="
echo "Configurando Servidor: BACKUP CLIENT"

dirFrom=`sed '1q;d' $1`
backupServer=`sed '2q;d' $1`
dirTo=`sed '3q;d' $1`
hoursInterval=`sed '4q;d' $1`

echo "Instalando rsync...."
apt-get install rsync -qq --force-yes -y> /dev/null

echo "Estableciendo demonio para sincronizar ficheros de $dirFrom a $backupServer:$dirTo cada $hoursInterval"
task="* */$hoursInterval * * * root rsync -avz $dirFrom root@$backupServer:$dirTo" 

grep -Fxq "$task" /etc/crontab && echo "Este backup ya esta configurado!" || echo "$task" >> /etc/crontab