#!/bin/bash
# j - Jump to project directory
# Usage: source j <project-name>

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

path=$(python3 "$SCRIPT_DIR/conduit.py" j "$@")
if [ $? -eq 0 ] && [ -n "$path" ]; then
    cd "$path"
fi
