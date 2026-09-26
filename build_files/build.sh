#!/bin/bash
set -ouex pipefail

# Copia system_files a la raiz
if [ -d "/ctx/system_files" ]; then
  cp -avf "/ctx/system_files"/. /
elif [ -d "/system_files" ]; then
  cp -avf "/system_files"/. /
fi

### Paquetes extra (opcional)
dnf5 install -y tmux

### Servicios
systemctl enable podman.socket

### --- THE ORIGIN - OPCION B 100% CONSOLA + VIDEO ---
echo "Configurando THE ORIGIN Opcion B..."

# Crea carpeta de video de inicio
mkdir -p /etc/skel/.steam/root/config/uioverrides/movies

# Busca tu video (lo tienes que poner en build_files/deck_startup.mkv)
if [ -f "/ctx/deck_startup.mkv" ]; then
  echo "Encontrado deck_startup.mkv"
  cp /ctx/deck_startup.mkv /etc/skel/.steam/root/config/uioverrides/movies/deck_startup.webm
elif [ -f "/ctx/deck_startup.webm" ]; then
  echo "Encontrado deck_startup.webm"
  cp /ctx/deck_startup.webm /etc/skel/.steam/root/config/uioverrides/movies/deck_startup.webm
else
  echo "No hay video custom, se usara el de Bazzite"
fi

chmod -R 755 /etc/skel/.steam 2>/dev/null || true

# Opcion B - borra sesiones de escritorio para que arranque 100% en Game Mode
rm -rf /usr/share/wayland-sessions/gnome* /usr/share/wayland-sessions/plasma* /usr/share/xsessions/* 2>/dev/null || true

# Asegura que Steam Deck sea por defecto (Bazzite Deck ya lo trae, pero por si acaso)
mkdir -p /etc/sddm.conf.d
echo -e "[Autologin]\nUser=gamer\nSession=gamescope-wayland.desktop" > /etc/sddm.conf.d/the-origin.conf || true

echo "THE ORIGIN listo"
