#!/usr/bin/env bash
#
# bootstrap-kali.sh
# Purpose: Quick bootstrap for a fresh Kali box — installs common tools, sets up aliases,
# and performs basic system upkeep. Intended for use in isolated/authorized environments.
#
# Usage: sudo ./bootstrap-kali.sh
#

set -euo pipefail
IFS=$'\n\t'

# ---------- colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()   { printf "${GREEN}==>${NC} %s\n" "$*"; }
warn()  { printf "${YELLOW}WARN${NC}: %s\n" "$*"; }
err()   { printf "${RED}ERROR${NC}: %s\n" "$*" >&2; }

# ---------- pre-checks ----------
if [[ "$(id -u)" -ne 0 ]]; then
  err "This script must be run as root (sudo). Exiting."
  exit 1
fi

KALI_USER="${SUDO_USER:-kali}"
USER_HOME="$(getent passwd "$KALI_USER" | cut -d: -f6 2>/dev/null || echo "/home/$KALI_USER")"

if [[ ! -d "$USER_HOME" ]]; then
  warn "User home directory $USER_HOME not found — creating it."
  mkdir -p "$USER_HOME"
  chown "$KALI_USER":"$KALI_USER" "$USER_HOME"
fi

export DEBIAN_FRONTEND=noninteractive

# ---------- update & upgrade ----------
log "Updating package lists..."
apt-get update -y

log "Upgrading existing packages..."
apt-get upgrade -y
apt-get autoremove -y
apt-get autoclean -y

# ---------- install packages ----------
log "Installing packages (this may take a while)..."

# Install everything in one apt-get call to avoid multiple apt locks.
# Add or remove packages as you prefer.
apt-get install -y --no-install-recommends \
  gobuster \
  dirsearch \
  seclists \
  tldr \
  curl \
  wget \
  jq \
  nmap \
  nikto \
  python3-pip \
  git \
  netcat-openbsd

# Optional/additional tools 
apt-get install -y amass httprobe whatweb

log "Ensuring tldr pages are up-to-date (for the unprivileged user)..."
# install/update tldr client for the kali user (pip may be used for Python tldr)
if command -v tldr >/dev/null 2>&1; then
  # try to update tldr cache for the user
  sudo -u "$KALI_USER" sh -c 'tldr --update || true'
fi

# ---------- .zshrc aliases & safe edits ----------
ZSHRC="$USER_HOME/.zshrc"
BACKUP="$ZSHRC.bootstrap.bak.$(date +%Y%m%d%H%M%S)"

log "Backing up existing $ZSHRC to $BACKUP (if it exists)..."
if [[ -f "$ZSHRC" ]]; then
  cp -a "$ZSHRC" "$BACKUP"
  chown "$KALI_USER":"$KALI_USER" "$BACKUP"
fi

log "Adding handy aliases to $ZSHRC (only if not present)..."

append_if_missing() {
  local file="$1"; shift
  local line="$*"
  grep -Fxq "$line" "$file" 2>/dev/null || {
    printf "%s\n" "$line" >> "$file"
    return 0
  }
  return 1
}

# Ensure the file exists and has proper ownership
touch "$ZSHRC"
chown "$KALI_USER":"$KALI_USER" "$ZSHRC"
chmod 644 "$ZSHRC"

append_if_missing "$ZSHRC" 'alias c=clear' && log "Added alias: c"
append_if_missing "$ZSHRC" 'alias q=exit' && log "Added alias: q"
append_if_missing "$ZSHRC" 'alias la="ls -lAh"' && log "Added alias: la"
append_if_missing "$ZSHRC" 'alias ll="ls -l"' && log "Added alias: ll"
append_if_missing "$ZSHRC" 'alias l="ls -CF"' && log "Added alias: l"
append_if_missing "$ZSHRC" 'prettyjson="python3 -m json.tool"' && log "Added helper: prettyjson"

# Add a small PS1 hint if not present (helps visually identify lab machines)
append_if_missing "$ZSHRC" 'export PS1="[\u@\h \W]\\$ "' && log "Ensured PS1 in $ZSHRC"

# Source .zshrc for the invoking non-root user (we won't source for root environment)
log "Sourcing $ZSHRC for $KALI_USER (in their shell config only)."
# No interactive sourcing here; inform user how to reload
printf "\n# Added by bootstrap script on %s\n" "$(date --iso-8601=seconds)" >> "$ZSHRC"

# ---------- permissions ----------
chown "$KALI_USER":"$KALI_USER" "$ZSHRC"

# ---------- post-setup reminders ----------
log "Bootstrap complete. A few recommended post-steps for the user (${KALI_USER}):"

cat <<'EOF'
  1) Re-login or run:   source ~/.zshrc
  2) Review installed tools and add any extra wordlists to /usr/share/seclists or ~/wordlists.
  3) Consider enabling a non-destructive cron for security updates or using unattended-upgrades.
EOF
