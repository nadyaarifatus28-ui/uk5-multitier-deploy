#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

error_handler() {
    echo "[CRITICAL ERROR] Aduh!Perintah '$2' gagal di baris $1!" >&2
    exit 1
}
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

echo "=== Mari mulai Master Installer ==="

if [ -f .env ]; then
    source .env
else
    echo "[ERROR] Astaghfirullah File .env belum ada! Tolong jalankan perintah: cp env.example .env dulu yaa" >&2
    exit 1
fi

if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    echo "[ERROR] Aduhh!! OS tidak dikenali!" >&2
    exit 1
fi

if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
    echo "[INFO] Menginstall paket untuk Ubuntu/Debian... tunggu yaa"
    export DEBIAN_FRONTEND=noninteractive
    sudo apt-get update -y
    sudo apt-get install -y nginx mariadb-server python3-pip
elif [[ "$ID" == "rhel" || "$ID" == "rocky" || "$ID" == "almalinux" || "$ID" == "fedora" ]]; then
    echo "[INFO] Menginstall paket untuk RHEL/AlmaLinux... bentar aja"
    sudo dnf install -y nginx mariadb-server python3-pip
else
    echo "[ERROR] Distro $ID belum didukung lohh!" >&2
    exit 1
fi

echo "[INFO] Memanggil skrip 01_setup_users.sh..."
bash scripts/01_setup_users.sh

echo "=== Master Installer Sudah Selesai! Yeayy! ==="
