#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

error_handler() {
    echo "[CRITICAL ERROR] Perintah '$2' gagal di baris $1!" >&2
    exit 1
}
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

echo "[INFO] Mulai mengatur user dan direktori..."

getent group webapp >/dev/null || sudo groupadd -r webapp

if ! id -u webapp >/dev/null 2>&1; then
    sudo useradd -r -g webapp -s /sbin/nologin -d /var/www/webapp -m webapp
    echo "[SUCCESS] User webapp berhasil dibuat."
else
    echo "[INFO] User webapp sudah tersedia, aman."
fi

sudo mkdir -p /var/www/webapp/data
sudo mkdir -p /var/log/webapp

sudo chown -R webapp:webapp /var/www/webapp /var/log/webapp
sudo chmod 0750 /var/www/webapp
sudo chmod 0750 /var/log/webapp

echo "[SUCCESS] Pengaturan user selesai."