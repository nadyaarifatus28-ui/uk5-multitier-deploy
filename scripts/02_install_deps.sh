#!/bin/bash
set -e

echo "================================"
echo "Installing System Dependencies"
echo "================================"

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y \
    nginx \
    mariadb-server \
    python3 \
    python3-pip \
    gettext-base

echo "================================"
echo "Installation Completed"
echo "================================"

nginx -v
mariadb --version
python3 --version
pip3 --version
