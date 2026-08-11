#!/usr/bin/env bash
# Disable Ubuntu Dock (sidebar) on GNOME 42 (Ubuntu 22.04)

set -euo pipefail

echo "Disabling Ubuntu Dock..."

# Disable the extension responsible for the dock
gsettings set org.gnome.shell enabled-extensions \
    "$(gsettings get org.gnome.shell enabled-extensions | \
      sed "s/'ubuntu-dock@ubuntu.com',\?//g")"

# Also forcibly disable via CLI
gnome-extensions disable ubuntu-dock@ubuntu.com || true

echo "✅ Ubuntu Dock disabled. Restarting GNOME Shell..."

# Restart GNOME Shell if running under X11
if [ "$XDG_SESSION_TYPE" = "x11" ]; then
  echo "Restarting GNOME Shell (X11)..."
  nohup bash -c "sleep 1; killall -3 gnome-shell" >/dev/null 2>&1 &
else
  echo "ℹ️ You're using Wayland. Log out and back in to apply changes."
fi
