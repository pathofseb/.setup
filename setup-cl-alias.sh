#!/bin/bash

# Add 'cl' alias for claude code to .bashrc

ALIAS_LINE="alias cl='claude'"

# Check if alias already exists
if grep -q "alias cl=" ~/.bashrc 2>/dev/null; then
    echo "Alias 'cl' already exists in ~/.bashrc"
else
    echo "" >> ~/.bashrc
    echo "# Claude Code shortcut" >> ~/.bashrc
    echo "$ALIAS_LINE" >> ~/.bashrc
    echo "Added 'cl' alias to ~/.bashrc"
fi

echo ""
echo "Run 'source ~/.bashrc' or open a new terminal to use it."
