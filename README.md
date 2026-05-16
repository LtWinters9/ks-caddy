# Caddy Install

Installs [Caddy](https://caddyserver.com/) from the official stable apt repository on Debian/Ubuntu.

---

## What it does

1. Installs prerequisites (`curl`, `apt-transport-https`, etc.)
2. Adds the Caddy GPG key and stable apt repository
3. Installs Caddy via `apt`
4. Creates and permissions `/var/www` as the web root (`www-data:www-data`, `775`)

---

## Prerequisites

- Debian/Ubuntu server
- Run as **root**
- Internet access to `dl.cloudsmith.io`

---

## Usage

```bash
chmod +x install.sh
sudo ./install.sh
```

No flags or configuration required — runs non-interactively from start to finish.

---

## After Installation

Caddy runs as a systemd service:

```bash
# Status
systemctl status caddy

# Restart
systemctl restart caddy

# View logs
journalctl -u caddy -f
```

The default `Caddyfile` is at `/etc/caddy/Caddyfile`. Web root is at `/var/www`.
