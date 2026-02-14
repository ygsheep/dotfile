#!/usr/bin/env bash
# NixOS rebuild script with automatic retry and proxy support

set -euo pipefail

# Configuration
MAX_RETRIES=5
RETRY_DELAY=10
HOST="${1:-desktop}"

# Proxy settings
export https_proxy="http://192.168.123.50:10808"
export http_proxy="http://192.168.123.50:10808"
export all_proxy="http://192.168.123.50:10808"
export no_proxy="localhost,127.0.0.1"

# Ensure curl can use the proxy
export CURL_HOME="$HOME"

# SSL settings for proxy that might inspect SSL
export GIT_SSL_NO_VERIFY=0
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

is_network_error() {
    local error_output="$1"
    grep -qiE "(failed to download|SSL certificate|HTTP error|curl error|connection|timeout|network|transfer|truncated)" <<< "$error_output"
}

do_rebuild() {
    local attempt=1

    while [ $attempt -le $MAX_RETRIES ]; do
        log "Attempt $attempt/$MAX_RETRIES: Building NixOS configuration for '$HOST'..."
        log "📡 Proxy: $https_proxy"

        if sudo -E nixos-rebuild switch --flake ".#$HOST" 2>&1 | tee /tmp/nixos-rebuild.log; then
            log "✅ Build succeeded!"
            return 0
        else
            local exit_code=${PIPESTATUS[0]}
            local error_output=$(cat /tmp/nixos-rebuild.log)

            if is_network_error "$error_output"; then
                error "Network error detected (exit code: $exit_code)"
                warn "Retrying in ${RETRY_DELAY} seconds..."
                sleep $RETRY_DELAY
                ((attempt++))
            else
                error "Non-recoverable error detected."
                echo "$error_output"
                return 1
            fi
        fi
    done

    error "Failed after $MAX_RETRIES attempts"
    return 1
}

log "🔄 Starting NixOS rebuild with retry logic"
log "🖥️  Target host: $HOST"

do_rebuild
exit_code=$?

if [ $exit_code -eq 0 ]; then
    log "🎉 Successfully built and activated NixOS configuration!"
else
    error "💥 Failed to build configuration"
    exit 1
fi
