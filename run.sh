#!/usr/bin/env bash
# NixOS rebuild script with proxy

set -euo pipefail

# Proxy settings
export https_proxy="http://192.168.123.50:10808"
export http_proxy="http://192.168.123.50:10808"

# Get host from argument or default to desktop
HOST="${1:-desktop}"

echo "🔄 Rebuilding NixOS for host: $HOST"
echo "📡 Using proxy: $https_proxy"

# Run nixos-rebuild with proxy
sudo nixos-rebuild switch --flake ".#$HOST"
