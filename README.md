# uk5-multitier-deploy

Milestone 2 UK5 Sistem Operasi

## Anggota Kelompok

| No | Peran | Anggota | File |
|----|-------|---------|------|
| 1 | Master Installer | Muhammad Yaqut Al-Mu'tasimy | deploy.sh, 01_setup_users.sh, env.example |
| 2 | Systemd & Aplikasi | Muhammad Al-Rizki | webapp.service, app.py, 03_configure_sec.sh |
| 3 | Nginx & Database | Nur Jannah Desita | 02_install_deps.sh, nginx.conf.template, database.cnf |
| 4 | Repo & Dokumentasi | Nadya Arifatus Zahra | README.md + diagram, health_check.sh, laporan akhir |

## Arsitektur

```mermaid
flowchart TD
    A["Internet / Client"] -->|"Port 80"| B["Tier 1: Nginx Reverse Proxy"]
    B -->|"HTTP 127.0.0.1:8000"| C["Tier 2: Backend App (webapp.service)"]
    C -->|"TCP 3306 (loopback)"| D["Tier 3: MariaDB"]
```

## Cara Pakai

(menyusul)
