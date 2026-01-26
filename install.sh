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
if [ -L "$INSTALL_DIR/cprm-bin" ] || [ -f "$INSTALL_DIR/cprm-bin" ]; then
    echo "Removing existing cprm installation..."
    rm "$INSTALL_DIR/cprm-bin"
fi

ln -s "$SCRIPT_DIR/cprm-bin" "$INSTALL_DIR/cprm-bin"
chmod +x "$SCRIPT_DIR/cprm-bin"
echo "✓ Created symlink: $INSTALL_DIR/cprm-bin -> $SCRIPT_DIR/cprm-bin"

# Install Python library files
SHARE_DIR="$HOME/.local/share/cprm"
mkdir -p "$SHARE_DIR"
cp "$SCRIPT_DIR/conduit.py" "$SHARE_DIR/conduit.py"
cp "$SCRIPT_DIR/file_operations.py" "$SHARE_DIR/file_operations.py"
chmod +x "$SHARE_DIR/conduit.py"
echo "✓ Installed Python library: $SHARE_DIR/"

# Install shell integration file
cp "$SCRIPT_DIR/cprm.sh" "$SHARE_DIR/cprm.sh"
echo "✓ Installed shell integration: $SHARE_DIR/cprm.sh"

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

# Add source line to shell config
SOURCE_LINE="source \"\$HOME/.local/share/cprm/cprm.sh\""
if [ -n "$SHELL_CONFIG" ]; then
    if grep -q "cprm/cprm.sh" "$SHELL_CONFIG" 2>/dev/null; then
        echo "✓ cprm shell integration already sourced in $SHELL_CONFIG"
    else
        echo ""
        echo "Adding cprm shell integration to $SHELL_CONFIG..."
        cat >> "$SHELL_CONFIG" << 'EOF'

# cprm project manager
source "$HOME/.local/share/cprm/cprm.sh"
EOF
        echo "✓ Added source line to $SHELL_CONFIG"
    fi
else
    echo ""
    echo "⚠ Could not detect shell config file"
    echo "Please manually add this line to your ~/.bashrc or ~/.zshrc:"
    echo "  $SOURCE_LINE"
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
