#!/bin/bash
set -euo pipefail

# ─────────────────────────────────────────────────────────────────────────────
# Caddy Install — adds the Caddy stable repo and installs Caddy.
# ─────────────────────────────────────────────────────────────────────────────

CADDY_GPG_KEY="/usr/share/keyrings/caddy-stable-archive-keyring.gpg"
CADDY_REPO_LIST="/etc/apt/sources.list.d/caddy-stable.list"
WEB_ROOT="/var/www"

# ─────────────────────────────────────────────────────────────────────────────

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*"
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

# ─────────────────────────────────────────────────────────────────────────────

check_root() {
    [[ $EUID -eq 0 ]] || die "Must be run as root."
}

add_repo() {
    log "Installing prerequisites..."
    apt-get -qq install -y \
        debian-keyring \
        debian-archive-keyring \
        apt-transport-https \
        curl

    log "Adding Caddy GPG key..."
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
        | gpg --dearmor -o "$CADDY_GPG_KEY"

    log "Adding Caddy stable repo..."
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
        | tee "$CADDY_REPO_LIST" > /dev/null
}

install_caddy() {
    log "Updating package lists..."
    apt-get -qq update

    log "Installing Caddy..."
    DEBIAN_FRONTEND=noninteractive apt-get -qq install -y caddy
}

setup_webroot() {
    log "Setting up web root at ${WEB_ROOT}..."
    mkdir -p "$WEB_ROOT"
    chmod -R 775 "$WEB_ROOT"
    chown -R www-data:www-data "$WEB_ROOT"
}

# ─────────────────────────────────────────────────────────────────────────────

main() {
    check_root
    add_repo
    install_caddy
    setup_webroot
    log "Caddy installed successfully on ${HOSTNAME}."
}

main
