#!/bin/bash

# Setup case-insensitive autocomplete for bash
# This script configures readline to ignore case when autocompleting

INPUTRC="$HOME/.inputrc"

echo "Setting up case-insensitive autocomplete..."

# Create or update .inputrc with case-insensitive settings
cat > "$INPUTRC" << 'EOF'
# Case-insensitive completion
set completion-ignore-case on

# Treat hyphens and underscores as equivalent when completing
set completion-map-case on

# Show completion matches immediately (without needing to press TAB twice)
set show-all-if-ambiguous on
EOF

echo "Configuration written to $INPUTRC"
echo ""
echo "Settings applied:"
echo "  - completion-ignore-case: on"
echo "  - completion-map-case: on"
echo "  - show-all-if-ambiguous: on"
echo ""
echo "Please restart your terminal for changes to take effect."
