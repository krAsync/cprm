# cprm shell integration
# Source this file in your ~/.bashrc or ~/.zshrc:
#   source /usr/share/cprm/cprm.sh
# Or if installed locally:
#   source ~/.local/share/cprm/cprm.sh

cprm() {
    # Use absolute path to cprm-bin (works regardless of PATH)
    local cprm_bin="$HOME/.local/bin/cprm-bin"

    # Check if it exists
    if [ ! -f "$cprm_bin" ]; then
        # Try system-wide installation
        if [ -f "/usr/local/bin/cprm-bin" ]; then
            cprm_bin="/usr/local/bin/cprm-bin"
        elif [ -f "/usr/bin/cprm-bin" ]; then
            cprm_bin="/usr/bin/cprm-bin"
        else
            echo "Error: cprm-bin not found. Run install.sh first." >&2
            return 1
        fi
    fi

    # Source the cprm-bin script to enable directory jumping
    source "$cprm_bin" "$@"
}
