#!/bin/bash
# 
#   Author/Autor: Carlos Mena.
#   https://github.com/carlosm00
#
#############################################################
#
# [EN] THIS SCRIPT INSTALLS ICECAST2 + SSL CERTIFICATE (OPTIONAL). ONLY FOR DEBIAN BASED OS. MUST BE EXECUTED AS ROOT.
#   1. Packages installation
#   2. Configuration
#   3. (Optional) SSL certificate
#
# [ES] ESTE SCRIPT INSTALA ICECAST2 y CERTIFICADO DE SSL (OPCIONAL). SÓLO PARA SO BASADO EN DEBIAN. DEBE SER EJECUTADO COMO ROOT.
#   1. Instalación de paquetes
#   2. Configuración
#   3. (Opcional) Certificado SSL
#
# logs
PROGNAME=$(basename $0)
mkdir /tmp/icecast2_installation
echo "${PROGNAME}: " $(date) >/tmp/icecast2_installation/success_icecast2.log
echo "${PROGNAME}: " $(date) >/tmp/icecast2_installation/error_icecast2.log
#
#############################################################
#
# [EN] Function for password insertion / [ES] Función para la inserción de la contraseña
contra () {
    echo -n "[EN] Write your icecast2 admin password / [Es] Escriba su contraseña de administración de icecast2: "
    read CON
    clear
    echo -n "[EN] Repeat it, please / [ES] Repítala, por favor :"
    read CON2
    clear
}
# [EN] Function for password comprobation / [ES] Función para la comprobacińo de la contraseña
comp_contra () {
    if [ $CON != $CON2 ]
    then
        echo "[EN] The given password is not correct... / [ES] La contraseña dada no es correcta... "  
        contra
    fi
}
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# [EN] Function for 2 - configuration / [ES] Función para 2 - configuración
#
conf () {
#
# DOMAIN / DOMINIO # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
    echo -n "[EN] Write your domain / [Es] Escriba su dominio : "
    read DOM
    echo $DOM | grep "." >>/tmp/icecast2_installation/success_icecast2.log
    if [ $? != 0 ]
    then
        echo "[EN] Your domain name must contain at least a dot / [ES] Su dominio debe contener mínimo un punto "
        echo "Example/Ejemplo: example.com "
        echo -n "[EN] Write your domain / [Es] Escriba su dominio : "
        read DOM
    fi
#
# LOCATION / LOCALIZACIÓN # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
    echo -n "[EN] Write your location / [Es] Escriba su localización : "
    read LOC
#
# ADMIN EMAIL / CORREO DE ADMINISTRADOR # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
    echo -n "[EN] Write your admin email / [Es] Escriba su correo de administrador : "
    read ADM
    echo $ADM | grep "." >>/tmp/icecast2_installation/success_icecast2.log
    if [ $? != 0 ]
    then
        echo "[EN] Your admin email must contain at least an at sign and an dot / [ES] Su correo de administrador debe contener mínimo un arroba y un punto "
        echo "Example/Ejemplo: admin@example.com "
        echo -n "[EN] Write your admin email / [Es] Escriba su correo de administrador : "
        read ADM
    fi
#
# PASSWD / CONTRA # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
contra
comp_contra
#
# PORT / PUERTO # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
    clear
    echo -n "[EN] Icecast2 client port / [ES] Puerto para la conexión cliente de icecast2 :"
    read PORT
#
# SSL
#
    echo -n "[EN] Connect trought HTTPS? Say yes ONLY if you already have a certificate / [ES] Conectar a través de HTTPS? SÓLO diga sí en caso de ya tener un certificado [Y/n]: "
    read
    if [[ $REPLY != "y" ]] && [[ $REPLY != "Y" ]]
    then
        SL=0
    else
        SL=1
    fi
#
# CHECK / COMPROBACIÓN # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
    echo -en "[EN] CHECK THE INFORMATION GIVEN / [ES] COMPRUEBE LA INFORMACIÓN HABILITADA \n    DOMAIN: $DOM \n    LOCATION: $LOC \n    ADMIN EMAIL: $ADM \n    PORT: $PORT \n    SSL: $SL \n[EN] Is it correct ? / [ES] ¿Es correcto?: \n    [Y/n]"
    read
    if [[ $REPLY != "y" ]] && [[ $REPLY != "Y" ]]
    then 
        echo "[EN] Sorry, but you'll have to execute this script again... / [ES] Lo sentimos, pero tendrá que ejecutar este script de nuevo..."
    else
        echo "[EN] Great! / [ES] ¿Genial!"
    fi
#
# icecast.xml config # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
    cd /etc/icecast2 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    mv /etc/icecast2/icecast.xml /etc/icecast2/icecast--.xml
    wget -q https://raw.githubusercontent.com/carlosm00/icecast2-installation/master/icecast_template.xml 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    mv icecast_template.xml icecast.xml 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log 
    sed -i "s/{LOCATION}/$LOC/g" icecast.xml
    sed -i "s/{ADMIN}/$ADM/g" icecast.xml
    sed -i "s/{PASSWD}/$CON/g" icecast.xml
    CON=0
    CON2=0
    sed -i "s/{HOSTNAME}/$DOM/g" icecast.xml
    sed -i "s/{PORT}/$PORT/g" icecast.xml
    sed -i "s/{SSL}/$SL/g" icecast.xml
#
# /etc/default/icecast2 # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
cat << 'EOL' > /etc/default/icecast
# Defaults for icecast2 initscript
# sourced by /etc/init.d/icecast2
# installed at /etc/default/icecast2 by the maintainer scripts

#
# This is a POSIX shell fragment
#

# Full path to the server configuration file
CONFIGFILE="/etc/icecast2/icecast.xml"

# Name or ID of the user and group the daemon should run under
USERID=root
GROUPID=root

# Edit /etc/icecast2/icecast.xml and change at least the passwords.
# Change this to true when done to enable the init.d script
ENABLE=true

EOL
#
# Ownership # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
    chown -R nobody /var/log/icecast2/ 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    systemctl enable icecast2 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    service icecast2 restart 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
}

#
############################################################# 
#
# [EN] Function for 3 - SSL certificate / [ES] Función para 3 - certificado SSL
#
cert () {
# Certbot # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    apt-get install certbot -y 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    certbot certonly --webroot-path="/usr/share/icecast2/web" -d $DOM 2>>/tmp/icecast2_installation/error_icecast2.log
# Keys # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    cat /etc/letsencrypt/live/$DOM/fullchain.pem /etc/letsencrypt/live/$DOM/privkey.pem > /etc/icecast2/bundle.pem 2>>/tmp/icecast2_installation/error_icecast2.log
    chmod 666 /etc/icecast2/bundle.pem 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
# Certificate renewal / Renovación de certificado # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    sed -n -e 1,14p /etc/letsencrypt/renewal/$DOM.conf > /etc/letsencrypt/renewal/$DOM.conf
    echo "post_hook = cat /etc/letsencrypt/live/$DOM/fullchain.pem /etc/letsencrypt/live/$DOM/privkey.pem > /etc/icecast2/bundle.pem && service icecast2 restart" >> /etc/letsencrypt/renewal/$DOM.conf
    echo "[[webroot_map]]" >> /etc/letsencrypt/renewal/$DOM.conf
# XML file reconfiguration / Reconfiguración del archivo XML # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
sed -i "s+<!-- {SSL_CERT} -->+<ssl-certificate>/usr/share/icecast2/icecast2.pem</ssl-certificate>+g" /etc/icecast2/icecast.xml
sed -i "s+<ssl>0</ssl>+<ssl>1</ssl>+g" /etc/icecast2/icecast.xml
#
service icecast2 restart 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
}
#
############################################################# EXECUTION / EJECUCIÓN ##################################
#
# 1.
OS=`grep ID_LIKE /etc/os-release | cut -c9-`
OSI=`grep 'ID=' /etc/os-release -m1 | cut -c4-`
OSV=`grep 'VERSION_ID=' /etc/os-release -m1 | cut -d '"' -f 2`
#
#
if [[ $OS == *"buntu"* ]] || [[ $OS == *"ebian"* ]]
then
    if [[ $OSI == *"buntu"* ]]
    then
        wOS="xUbuntu_"
    elif [[ $OSI == *"ebian"* ]]
    then
        wOS="Debian_"
    fi
    sudo sh -c "echo deb http://download.opensuse.org/repositories/multimedia:/xiph/$wOS$OSV/ ./ >>/etc/apt/sources.list.d/icecast.list" 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    wget -qO - http://icecast.org/multimedia-obs.key | sudo apt-key add - 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    apt-get update 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
    apt -qq install -y curl icecast2 sed 1>>/tmp/icecast2_installation/success_icecast2.log 2>>/tmp/icecast2_installation/error_icecast2.log
# [EN] Execution function for 2 / [ES] Ejecución de función para 2
    conf
# [EN] Execution function for 3 / [ES] Ejecución de función para 3
    echo -e -n "[EN] Do you want to install a self-signed SSL certificate for enabling HTTPS? / [ES] ¿Desea instalar un certificado SSL autofirmado para habilitar HTTPS? \n[Y/n]: "
    read
    if [[ $REPLY == "y" ]] || [[ $REPLY == "Y" ]]
    then
        cert
    fi
# [EN] End / [ES] Fin
    echo "[EN] Installation finished! / [ES] ¡Instalación acabada!"
    echo "[EN] Installation finished / [ES] Instalación acabada --> " $(date) >>/tmp/icecast2_installation/success_icecast2.log
    echo "[EN] Installation finished / [ES] Instalación acabada --> " $(date) >>/tmp/icecast2_installation/error_icecast2.log
elif [[ $OS == *"edora"* ]]
then
    echo "[EN] This script is ONLY for Debian based OS / [ES] Este script es SOLO para sistemas operativos basados en Debian "
fi
