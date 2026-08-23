#!/usr/bin/env bash
set -euo pipefail

# Bind Super+Shift+S to GNOME's interactive screenshot overlay, so you can drag a
# selection around whatever you want to capture — the Windows "Snipping Tool" flow.
#
# Uses GNOME Shell's built-in screenshot UI (GNOME 42+), so nothing extra is
# installed and it works on Wayland. The overlay lets you drag a region, or switch
# to window / full-screen capture. Every shot goes to the clipboard AND is saved
# to ~/Pictures/Screenshots.
#
# Run with --verify to check that the last screenshot actually reached the
# clipboard as an image.

SHORTCUT="<Shift><Super>s"
SCREENSHOT_SCHEMA="org.gnome.shell.keybindings"
SCREENSHOT_KEY="show-screenshot-ui"

if ! command -v gsettings >/dev/null 2>&1; then
    echo "gsettings not found — this script needs GNOME." >&2
    exit 1
fi

# --verify: report what the clipboard is currently holding.
if [[ "${1:-}" == "--verify" ]]; then
    if ! command -v wl-paste >/dev/null 2>&1; then
        echo "wl-paste not found — install wl-clipboard to use --verify." >&2
        exit 1
    fi
    echo "Clipboard currently offers:"
    wl-paste --list-types 2>/dev/null | sed 's/^/  /'
    if wl-paste --list-types 2>/dev/null | grep -q '^image/'; then
        echo "✓ An image is on the clipboard — paste it with Ctrl+V."
    else
        echo "✗ No image on the clipboard. Take a shot with Super+Shift+S, then re-run."
    fi
    exit 0
fi

echo "Clearing anything else bound to Super+Shift+S..."

# GNOME ships Shift+Super+S as "move window to workspace 8"; the workspace setup in
# this repo uses Super+1,2,3,q,w,e instead, so the key is free to reclaim.
for wm_key in $(gsettings list-keys org.gnome.desktop.wm.keybindings); do
    # Match the whole quoted accelerator, so <Shift><Super>space isn't caught too.
    if [[ "$(gsettings get org.gnome.desktop.wm.keybindings "${wm_key}")" == *"'${SHORTCUT}'"* ]]; then
        gsettings set org.gnome.desktop.wm.keybindings "${wm_key}" "[]"
        echo "  ✓ Unbound ${wm_key}"
    fi
done

echo "Binding ${SHORTCUT} to the screenshot overlay..."

# Keep Print working as well, so both keys open the same overlay.
gsettings set "${SCREENSHOT_SCHEMA}" "${SCREENSHOT_KEY}" "['${SHORTCUT}', 'Print']"

# The overlay always copies to the clipboard; make sure its save location exists too,
# so a shot is never lost if the clipboard is later overwritten.
mkdir -p "$(xdg-user-dir PICTURES 2>/dev/null || echo "${HOME}/Pictures")/Screenshots"

echo ""
echo "=========================================="
echo "✓ Super+Shift+S opens the screenshot overlay"
echo ""
echo "  drag a box around what you want   → region capture"
echo "  or pick window / full screen from the toolbar"
echo ""
echo "Every shot is copied to the clipboard (paste with Ctrl+V) and also"
echo "saved to ~/Pictures/Screenshots."
echo ""
echo "Check the clipboard after a shot with:  $(basename "$0") --verify"
echo "=========================================="
