#!/usr/bin/env bash
# Health check sederhana untuk stack Nginx -> webapp -> MariaDB
set -euo pipefail

URL="${1:-http://127.0.0.1}"

cek_service() {
  if systemctl is-active --quiet "$1"; then
    echo "[OK] $1 aktif"
  else
    echo "[FAIL] $1 tidak aktif" >&2
    exit 1
  fi
}

cek_service nginx
cek_service webapp.service
cek_service mariadb

# Cek website merespon HTTP 200
KODE=$(curl -s -o /dev/null -w '%{http_code}' "$URL")
if [ "$KODE" = "200" ]; then
  echo "[OK] $URL merespon HTTP 200"
else
  echo "[FAIL] $URL merespon HTTP $KODE" >&2
  exit 1
fi

# Database tidak boleh terbuka ke publik (hanya loopback)
if ss -ltn | grep -E '(0\.0\.0\.0|\*|\[::\]):3306' >/dev/null; then
  echo "[FAIL] Port 3306 terbuka ke publik!" >&2
  exit 1
else
  echo "[OK] Database tidak terekspos ke publik"
fi

echo "[SUCCESS] Semua pengecekan lulus."
