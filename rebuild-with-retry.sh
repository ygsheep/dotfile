#!/usr/bin/env bash
# NixOS rebuild script with automatic retry on network errors

set -euo pipefail

# Configuration
MAX_RETRIES=5
RETRY_DELAY=10
HOST="${1:-desktop}"

# Proxy settings
# export https_proxy="http://192.168.123.50:10808"
# export http_proxy="http://192.168.123.50:10808"

export https_proxy=""
export http_proxy=""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $*"
}

error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

# Check if error is network-related
is_network_error() {
    local error_output="$1"
    # Common network error patterns
    grep -qiE "(failed to download|SSL certificate|HTTP error|curl error|connection|timeout|network|transfer|truncated)" <<< "$error_output"
}

# Check if error is dependency build failure (often caused by download issues)
is_download_error() {
    local error_output="$1"
    grep -qiE "(failed to build|dependencies.*failed)" <<< "$error_output"
}

do_rebuild() {
    local attempt=1
    local last_error=""

    while [ $attempt -le $MAX_RETRIES ]; do
        log "Attempt $attempt/$MAX_RETRIES: Building NixOS configuration for '$HOST'..."

        # Run nixos-rebuild and capture output
        if sudo nixos-rebuild switch --flake ".#$HOST" 2>&1 | tee /tmp/nixos-rebuild.log; then
            log "✅ Build succeeded!"
            return 0
        else
            local exit_code=${PIPESTATUS[0]}
            local error_output=$(cat /tmp/nixos-rebuild.log)

            # Check if this is a recoverable error
            if is_network_error "$error_output" || is_download_error "$error_output"; then
                error "Network/download error detected (exit code: $exit_code)"
                warn "Retrying in ${RETRY_DELAY} seconds..."

                # Clear any problematic cached downloads
                sudo nix-store --gc --print-dead >/dev/null 2>&1 || true

                sleep $RETRY_DELAY
                ((attempt++))
            else
                error "Non-recoverable error detected. Exiting."
                error "Last error output:"
                echo "$error_output"
                return 1
            fi
        fi
    done

    error "Failed after $MAX_RETRIES attempts"
    return 1
}

# Main execution
log "🔄 Starting NixOS rebuild with retry logic"
log "📡 Using proxy: $https_proxy"
log "🖥️  Target host: $HOST"
log "🔁 Max retries: $MAX_RETRIES"

do_rebuild
exit_code=$?

if [ $exit_code -eq 0 ]; then
    log "🎉 Successfully built and activated NixOS configuration!"
else
    error "💥 Failed to build configuration"
    exit 1
fi
