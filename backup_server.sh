#!/bin/bash

echo "============================="
echo "Configurando Servidor: BACKUP SERVER"

dirBackup=`sed '1q;d' $1`

echo "Creando directorio $dirBackup..."
mkdir --parents $dirBackup > /dev/null