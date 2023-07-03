#!/bin/bash
# script que instalará los paquetes básicos en ubuntu
#un navegador y un editor de código

#Función para detectar errores
function usage(){
    echo "Error de instalación"
    exit 1
}

#Función para actualizar el sistema
function actualizar(){
    apt update && apt upgrade
}

#Se comprueba que estamos ejecutando el scrip como usario root
if [[ ${UID} -ne 0 ]]
then
    echo "No eres el administrador"
    exit 1
fi

#se actualiza el sistema con la función que hemos creado, antes de instalar algo es recomendable actualizar
#como se va usar más de una vez se ha creado una función
actualizar
#se instalan una serie de paquetes básicos para el terminal Linux
apt install net-tools tree wget curl snap ssh git 
#comprueva si ha habido algún error en la intalación de los paquetes
if [[ ${?} -ne 0 ]]
then
    usage
fi
#se vuelve a actualizar el sistema
actualizar
#se descarga el instalador de chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#se instala chrome
sudo dpkg -i google-chrome-stable_current_amd64.deb
# Si hay algún problema con la instalación de Chrome, corregir dependencias
if [[ ${?} -ne 0 ]]
then
sudo apt-get install -f
    #se vuelve a comprobar los errores que pueda haber en la correción de dependencias
    if [[ ${?} -ne 0 ]]
    then
        usage
    fi
fi
#Se vuelve a actualizar para hacer otra instalación
actualizar
#instalación de visual studio code
# Importar la clave GPG de Microsoft es parte del proceso para agregar el repositorio oficial de Visual Studio Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#se mueve este archivo a la ubicación /etc/apt/trusted.gpg.d/microsoft.gpg, que es donde se almacenan las claves GPG confiables para el sistema.
mv packages.microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
# se agrega el repositorio de Visual Studio Code al sistema
echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" |  tee /etc/apt/sources.list.d/vscode.list
# Actualiza la lista de paquetes e instala Visual Studio Code
actualizar
#Se instala visual Studio Code
apt install code
#Se vuelve a comprobar  que la instalación se ha hecho bien,y si hemos llegado al final del código, se emitirá
#un mensaje de que todas las actualizaciones se han hecho
if [[ ${?} == 0 ]]
then
    echo "Las instalaciones se han hecho correctamente"
else
    usage
fi
#Se vuelve a actualizar el sistema
actualizar
# Agregar al usuario actual al grupo sudo
# -a se utiliza para agregar al usuario a un grupo existente sin eliminarlo de otros grupos a los que ya pertenece.
# G expecifica el grupo
usermod -aG sudo ${USER}
if [[ ${?} == 0 ]]
then
    echo " se ha añadido al usuario ${USER} al grupo sudo"
else
    echo "no ha podido añardirse el usuario al grupo sudo"
    exit 1
fi