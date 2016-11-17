# ASI2014
##Script maestro para la configuración de un cluster Linux
1. Estructura General


Para la estructuración de la práctica se ha utilizado un script principal y otro adicional por cada servicio requerido. Sumando un total de 11 scripts. Esto proporciona modularidad, facilitando la adición de nuevos servicios o la modificación de los ya existentes.
2. Ficheros de configuración


Tal y como se pide en la práctica cada servicio se configura siguiendo las características pedidas en los ficheros de configuración, estos ficheros deben contener el número de parámetros requerido por cada script para la ejecución del mismo.
3. Scripts
3.1 Estrategias Generales
Para la realización de esta práctica se han tomado varias decisiones a la hora de elaborar los scripts que se repiten en prácticamente la mayoría de ellos y que procedemos a explicar.
3.1.1. Instalación de paquetes
La instalación de paquetes se realiza mediante el mandato apt-get con los atributos -qq --force-yes y redireccionando su salida a /dev/null. Esto nos asegura que tanto si el programa ya esta instalado con anterioridad como si es necesaria su instalación, el usuario no tenga la necesidad de intervenir ni se ensucie la salida del script.


3.1.2. Edición de ficheros
Para la edición de los ficheros necesarios primero se realiza una copia temporal de ellos. Para posteriormente verificar si la modificación a efectuar esta realizada ya en cuyo caso no se modificaría el fichero evitando corromperlo o duplicar contenido, o en caso de no estar realizada la modificación realizarla para posteriormente sustituir el fichero original.


3.1.3. Creación de directorios
Puesto que las carpetas necesarias pueden estar anidadas en carpetas que no existen, la creación de los nuevos directorios se realiza mediante el mandato mkdir y el parámetro --parent lo que creará la estructura completa de carpetas necesaria.




3.1.4. Lectura de ficheros de configuración
Para los ficheros de configuración con tamaño de lineas fijo se utiliza el mandato sed por sencillez. Sin embargo para ficheros de configuración de tamaño variable se utiliza una estructura “while read line” junto con un “or” del numero de lineas para asegurar que lea la última línea.
3.2 Script Principal
Este script es el encargado de leer el fichero de configuración que contiene los servicios a desplegar. La secuencia seguida por este script es la siguiente:
Lee línea del fichero de configuración.
Copia script y fichero de configuración del servicio en la máquina destino.
Ejecuta el script mediante ssh en la máquina destino.
Si existen más líneas en el fichero de configuración vuelve a 1.


Destacar la utilización de los parámetros “-oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null” tanto para la copia de los ficheros como para la ejecución del script. Estos parámetros nos permiten realizar las dos acciones sin necesidad de que el usuario acepte el fingerprint de la máquina destino y evita posibles errores por cambios en estas.
Otra dato a destacar es lo genérico del script. El cuál permite añadir nuevos tipos de servicios sin la modificación de este script puesto que el nombre del script a utilizar es la composición del proporcionado por el fichero de configuración más la extensión .sh.
3.3 Script Montaje
Este script es el encargado de montar un dispositivo y dejarlo preparado para que se automonte al reiniciar el sistema. Para conseguir esto se crea la carpeta de montaje pedida. Posteriormente se crea una copia del fichero fstab y se comprueba si ya existe el dispositivo. En caso de existir se lanza un mensaje por pantalla indicandolo o en su defecto se añade y posteriormente se reemplaza el fichero original con las modificaciones realizadas.
3.4 Script RAID
El primer paso de este script es la lectura de los parámetros de configuración. Una vez realizado este paso se procede a instalar el programa mdadm. Como último paso y fruto de una correcta instalación del paquete mdadm se procede a crear el raid.
3.5 Script LVM
Para la configuración de este servicio es necesaria la instalación del paquete lvm2 para el cual se sigue la misma secuencia que en el Script RAID. Posteriormente se procede a leer los parámetros de configuración. La estrategia elegida en este caso ha sido la utilización de un while, puesto que el número de líneas es variable. Una vez leídas las dos primeras líneas del fichero se procede a la crear el grupo de volúmenes con los dispositivos dados. Y como último paso se añade un volumen lógico al grupo por cada línea.
3.6 Script Servidor NIS
Este script comienza con la instalación del paquete nis. Para posteriormente seguir la secuencia:
Creación del fichero /etc/defaultdomain que contiene el nombre del dominio.
Modificación del fichero /etc/default/nis para especificar que se trata de un servidor nis.
Ejecución del programa “/usr/lib/yp/ypinit -m”
Reinicio del servicio nis
3.7 Script Cliente NIS
Este script realiza los mismos pasos que el script anterior, cambiando la modificación del fichero /etc/default/nis que en este caso será necesario indicar que se trata de un cliente, y añadiendo la adición del servidor en  el fichero  /etc/yp.conf y modificando /etc/nsswitch.conf para que consulte al servidor nis para la autenticación de usuarios.
3.8 Script Servidor NFS
La configuración del servidor NFS cuenta con tres partes bien diferenciadas que explicamos a continuación. 
La instalación de los paquetes nfs-common y nfs-kernel-server.
Adición de las entradas para cada directorio compartido a /etc/exports (Se ha decidido compartir el directorio de forma general con todos puesto que no esta indicado en el enunciado conquien compartir) con las siguientes características rw, sync y no_root_squash que se explican más adelante. 
Como último paso se procede al reinicio del servicio nfs.


Nota:
rw: habilita la lectura y escritura al directorio.
sync: Obliga seguir el protocolo NFS para evitar pérdida de información.
no_root_squash: Permite el acceso como root al directorio compartido.
3.9 Script Cliente NFS
Al igual que el Script correspondiente al servidor NFS este script cuenta con tres partes que pasamos a explicar:
Instalación del paquete nfs-common
Bucle que añade una línea a fstab por cada dirección remota encontrada en el fichero de configuración
Recarga de fstab


Destacar en este script la utilización de una expresión regular para la detección de la ip, puesto que es necesario añadir a continuación de esta dos puntos.
3.10 Script Servidor Backup
La función de este script es únicamente la creación de la carpeta donde se realizará el backup.
3.11 Script Cliente Backup
Para el cliente de backup se ha decidido utilizar rsync junto con un demonio utilizando cron. Se ha decidido esta estrategia puesto que cumple al completo con los requisitos pedidos en el enunciado y a su vez es muy sencillo de configurar. Para la configuración el script realiza la siguiente secuencia.
Instalación del paquete rsync
Busca si el demonio está ya incluido en /etc/crontab y en caso negativo lo añade.
