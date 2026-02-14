#!/usr/bin/env bash
# NixOS rebuild script with proxy configuration

set -euo pipefail

HOST="${1:-desktop}"

# Proxy settings
export https_proxy="http://192.168.123.50:10808"
export http_proxy="http://192.168.123.50:10808"
export all_proxy="http://192.168.123.50:10808"
export CURL_HOME="/etc/nix"

# Pass proxy to Nix build
export NIX_CONFIG="extra-sandbox-paths = /etc/nix/curlrc /etc/nix/netrc"

# Disable SSL verification for problematic hosts (only use with trusted proxy!)
export GIT_SSL_NO_VERIFY=0
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

echo "🔄 Rebuilding with proxy: $https_proxy"

# Run nixos-rebuild with proxy env vars
sudo -E nixos-rebuild switch --flake ".#$HOST"
