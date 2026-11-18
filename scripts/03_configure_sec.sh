cd ~/uk5-multitier-deploy
git checkout -b feat/03-configure-sec

cat > scripts/03_configure_sec.sh << 'EOF'
#!/usr/bin/env bash
# 03_configure_sec.sh - Konfigurasi firewall dan SELinux (idempoten, multi-distro)
set -euo pipefail
IFS=$'\n\t'

# shellcheck disable=SC2329
error_handler() {
    local line_no=$1
    local last_command=$2
    echo "[CRITICAL ERROR] Perintah '${last_command}' gagal di baris ${line_no}!" >&2
    exit 1
}
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR
trap 'echo "[INFO] Skrip dibatalkan oleh pengguna."; exit 130' INT TERM

# Port publik yang dibuka. Port 8000 (backend) dan 3306 (database) sengaja tidak dibuka.
ALLOWED_PORTS=(22 80 443)

configure_ufw() {
    if ! command -v ufw >/dev/null 2>&1; then
        export DEBIAN_FRONTEND=noninteractive
        sudo apt-get update -y
        sudo apt-get install -y ufw
    fi

    sudo ufw default deny incoming
    sudo ufw default allow outgoing

    local port
    for port in "${ALLOWED_PORTS[@]}"; do
        sudo ufw allow "${port}/tcp"
    done

    sudo ufw --force enable
    sudo ufw status verbose
}

configure_firewalld() {
    if ! command -v firewall-cmd >/dev/null 2>&1; then
        sudo dnf install -y firewalld
    fi

    sudo systemctl enable --now firewalld

    local svc
    for svc in ssh http https; do
        sudo firewall-cmd --permanent --add-service="${svc}"
    done

    sudo firewall-cmd --reload
    sudo firewall-cmd --list-all
}

configure_selinux() {
    if
