#!/bin/bash

# Script to disable workspace switching animations in GNOME

echo "Disabling workspace switching animations..."

# Disable all animations (this includes workspace switching)
gsettings set org.gnome.desktop.interface enable-animations false

echo "✓ Workspace switching animations disabled"
echo ""
echo "Note: This disables all GNOME Shell animations."
echo "To re-enable animations, run:"
echo "  gsettings set org.gnome.desktop.interface enable-animations true"
