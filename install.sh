#!/bin/bash
# Installation script for cprm

set -e

echo "Installing cprm..."
echo ""

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install directory
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Create symlink
if [ -L "$INSTALL_DIR/cprm" ] || [ -f "$INSTALL_DIR/cprm" ]; then
    echo "Removing existing cprm installation..."
    rm "$INSTALL_DIR/cprm"
fi

ln -s "$SCRIPT_DIR/cprm" "$INSTALL_DIR/cprm"
chmod +x "$SCRIPT_DIR/cprm"
chmod +x "$SCRIPT_DIR/conduit.py"
echo "✓ Created symlink: $INSTALL_DIR/cprm -> $SCRIPT_DIR/cprm"

# Check if ~/.local/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo ""
    echo "⚠ Warning: $HOME/.local/bin is not in your PATH"
    echo "Add this line to your ~/.bashrc or ~/.zshrc:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo ""
fi

# Detect shell config file based on user's shell
SHELL_CONFIG=""
USER_SHELL=$(basename "$SHELL")

if [ "$USER_SHELL" = "zsh" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ "$USER_SHELL" = "bash" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    fi
else
    # Fallback: check which config files exist
    if [ -f "$HOME/.zshrc" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        SHELL_CONFIG="$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        SHELL_CONFIG="$HOME/.bash_profile"
    fi
fi

# Check if alias already exists
ALIAS_LINE="alias cprm='source cprm'"
if [ -n "$SHELL_CONFIG" ]; then
    if grep -q "alias cprm=" "$SHELL_CONFIG" 2>/dev/null; then
        echo "✓ cprm alias already exists in $SHELL_CONFIG"
    else
        echo ""
        echo "Adding alias to $SHELL_CONFIG..."
        echo "" >> "$SHELL_CONFIG"
        echo "# cprm project manager" >> "$SHELL_CONFIG"
        echo "$ALIAS_LINE" >> "$SHELL_CONFIG"
        echo "✓ Added alias to $SHELL_CONFIG"
    fi
else
    echo ""
    echo "⚠ Could not detect shell config file"
    echo "Please manually add this line to your ~/.bashrc or ~/.zshrc:"
    echo "  $ALIAS_LINE"
fi

echo ""
echo "✓ Installation complete!"
echo ""
echo "To start using cprm, reload your shell:"
echo "  source $SHELL_CONFIG"
echo ""
echo "Or open a new terminal window."
echo ""
echo "Usage:"
echo "  cprm make              # Create config file"
echo "  cprm init <name>       # Initialize project in current directory"
echo "  cprm j <name>          # Jump to project directory"
