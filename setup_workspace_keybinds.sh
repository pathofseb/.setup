#!/bin/bash

# Script to set up 6 workspace keybindings in GNOME
# Keybindings: Super+1,2,3,q,w,e for workspaces 1-6

echo "Setting up 6 workspace keybindings..."

# First, ensure we have 6 static workspaces (you said you made 12, this keeps them)
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces 12

echo "✓ Keeping 12 static workspaces"

echo ""
echo "Disabling conflicting keybindings..."

# Disable GNOME's default app switcher keybindings (Super+1-9)
for i in {1..9}; do
    gsettings set org.gnome.shell.keybindings switch-to-application-${i} "[]"
done

# Disable Dash-to-Dock keybindings if the extension is installed
if gsettings list-schemas | grep -q "org.gnome.shell.extensions.dash-to-dock"; then
    for i in {1..9}; do
        gsettings set org.gnome.shell.extensions.dash-to-dock app-hotkey-${i} "[]"
        gsettings set org.gnome.shell.extensions.dash-to-dock app-shift-hotkey-${i} "[]"
    done
    echo "✓ Disabled Dash-to-Dock app keybindings"
fi

echo "✓ Disabled default application switcher keybindings"

# Define the keys for each workspace (in order)
keys=("1" "2" "3" "q" "w" "e")

# Set keybindings to SWITCH to each workspace
for i in {0..5}; do
    workspace_num=$((i + 1))
    key="${keys[$i]}"

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-${workspace_num} "['<Super>${key}']"
    echo "✓ Super+${key} → Switch to workspace ${workspace_num}"
done

echo ""
echo "Setting up keybindings to MOVE windows to workspaces..."

# Set keybindings to MOVE window to each workspace (Shift+Super+key)
for i in {0..5}; do
    workspace_num=$((i + 1))
    key="${keys[$i]}"

    gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-${workspace_num} "['<Shift><Super>${key}']"
    echo "✓ Shift+Super+${key} → Move window to workspace ${workspace_num}"
done

echo ""
echo "=========================================="
echo "Workspace keybindings configured successfully!"
echo ""
echo "Switch to workspace:"
echo "  Super+1,2,3 → Workspaces 1-3"
echo "  Super+q,w,e → Workspaces 4-6"
echo ""
echo "Move window to workspace:"
echo "  Shift+Super+1,2,3 → Workspaces 1-3"
echo "  Shift+Super+q,w,e → Workspaces 4-6"
echo "=========================================="
