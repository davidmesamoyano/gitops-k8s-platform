#!/usr/bin/env bash
# Pone tu usuario de GitHub y la IP de la VM en los manifiestos.
# Uso (en Git Bash, en Windows): bash platform/00-configure.sh tu-usuario-github IP_DE_LA_VM
set -euo pipefail
USER_GH=$(echo "${1:?Indica tu usuario de GitHub}" | tr '[:upper:]' '[:lower:]')
IP="${2:?Indica la IP de la VM (ip -4 addr dentro de la VM)}"
cd "$(dirname "$0")/.."
grep -rl --exclude-dir=.git --exclude=00-configure.sh --exclude=README.md -e GITHUB_USER -e IP_VM . | xargs sed -i "s/GITHUB_USER/${USER_GH}/g; s/IP_VM/${IP}/g"
echo "Configurado para github.com/${USER_GH} y la IP ${IP}"
