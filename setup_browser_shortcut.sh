#!/usr/bin/env bash
set -euo pipefail

# Configure a GNOME custom keybinding that launches the default browser with Super+B.

KEY_SCHEMA="org.gnome.settings-daemon.plugins.media-keys"
CUSTOM_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-browser-super-b/"

DEFAULT_BROWSER_DESKTOP="firefox.desktop"
if command -v xdg-settings >/dev/null 2>&1; then
    DETECTED_DESKTOP=$(xdg-settings get default-web-browser 2>/dev/null | tr -d '[:space:]')
    if [[ -n "${DETECTED_DESKTOP}" ]]; then
        DEFAULT_BROWSER_DESKTOP="${DETECTED_DESKTOP}"
    fi
fi

LAUNCH_COMMAND="bash -lc \"gtk-launch ${DEFAULT_BROWSER_DESKTOP}\""
CUSTOM_NAME="Launch Browser (Super+B)"
CUSTOM_BINDING="<Super>b"

CURRENT_LIST=$(gsettings get "${KEY_SCHEMA}" custom-keybindings)
CLEAN_LIST=${CURRENT_LIST#@as }

UPDATED_LIST=$(python3 - <<'PY' "${CLEAN_LIST}" "${CUSTOM_PATH}"
import ast
import sys

current = sys.argv[1].strip() or "[]"
path = sys.argv[2]

items = ast.literal_eval(current)
if path not in items:
    items.append(path)

print("[" + ", ".join(f"'{item}'" for item in items) + "]")
PY
)

echo "Updating GNOME custom keybinding list..."
gsettings set "${KEY_SCHEMA}" custom-keybindings "${UPDATED_LIST}"

echo "Writing Super+B browser shortcut details..."
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"${CUSTOM_PATH}" name "${CUSTOM_NAME}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"${CUSTOM_PATH}" command "${LAUNCH_COMMAND}"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"${CUSTOM_PATH}" binding "${CUSTOM_BINDING}"

echo "✓ Super+B is now mapped to launch ${DEFAULT_BROWSER_DESKTOP}"
