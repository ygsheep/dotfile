#!/usr/bin/env bash
# Quick rebuild script for CachyOS kernel testing

HOST="${1:-desktop}"

# Export proxy for all commands
export https_proxy="http://192.168.123.50:10808"
export http_proxy="http://192.168.123.50:10808"
export all_proxy="http://192.168.123.50:10808"

echo "📡 Proxy: $https_proxy"
echo "🖥️  Host: $HOST"
echo "🔄 Running nixos-rebuild switch..."

sudo -E nixos-rebuild switch --flake ".#$HOST"
