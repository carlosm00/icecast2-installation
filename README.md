# icecast2-installation
Bash script for installing icecast2 on any Debian based OS
[EN] Only for DEBIAN based Operating System / [ES] Sólo para Sistemas Operativos basados en Debian.
# [EN] 
Must be executed as ROOT. Installation scripts for:
  - Installing icecast2.
  - Icecast2 basic configuration.
  - HTTPS enabling with Certbot (OPTIONAL).
  
## USAGE (AS ROOT):
Execute these commands on the terminal:

```
   wget -q https://raw.githubusercontent.com/carlosm00/icecast2-installation/master/icecast2-installation.sh
   chmod +x icecast2-installation.sh
   ./icecast2-installation.sh
```
  The main script will download the XML template and change it according to the user's input.
  
## Extension:
The final service can be easily modified as any other web service. This means that CSS and JS stylesheets can be added to change the style of the main service (as on this [Sintonizate](https://www.sintonizate957.com/audio-en-vivo-2/) service) or simply inyect the service on your main web service (as on [Sintonizate](https://www.sintonizate957.com/) landingpage).

# [ES]
Debe ser ejecutado como ROOT. Scripts de instalación para:
  - Instalación de icecast2.
  - Configuración básica de icecast2.
  - Habilitación de HTTPS con Certbot (OPCIONAL).
  
## USO (COMO ROOT):
Ejecute estos comandos en la terminal:
```
  wget -q https://raw.githubusercontent.com/carlosm00/icecast2-installation/master/icecast2-installation.sh
  chmod +x icecast2-installation.sh
  ./icecast2-installation.sh
```
  El script principal descargará la plantilla XML y la cambiará de acuerdo a los parámetros de entrada del usuario.

## Extensión:
El servicio final puede ser modificado fácilemente como con cualquier otro servicio web. Esto significa que se puede añadir hojas de estilo en CSS o JS para cambiar el estilo como servicio principal (como en este servicio de [Sintonizate](https://www.sintonizate957.com/audio-en-vivo-2/)) o simplemente inyectar este servcio en tu servicio web principal (como en la landing page de [Sintonizate](https://www.sintonizate957.com/)).
