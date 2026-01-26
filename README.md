# cprm - Project Manager

A simple project manager that lets you quickly jump between projects.

## Dependencies

- Python 3.6+
- `python-toml` package

**Install on Arch Linux:**
```bash
sudo pacman -S python python-toml
```

**Or use a virtual environment:**
```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Installation

### Method 1: Install Script (Recommended for local use)

```bash
git clone <repo-url> ~/projects/conduit
cd ~/projects/conduit
./install.sh
source ~/.bashrc  # or source ~/.zshrc
```

### Method 2: System-wide Installation (Package Manager Ready)

```bash
git clone <repo-url>
cd conduit
sudo make install PREFIX=/usr/local
```

Then add to your `~/.bashrc` or `~/.zshrc`:
```bash
source /usr/local/share/cprm/cprm.sh
```

### Method 3: Via Package Manager (Future)

This project is structured to be packaged for:
- **Arch Linux (AUR)**: `yay -S cprm` (coming soon)
- **Debian/Ubuntu (APT)**: `apt install cprm` (coming soon)
- **Other**: Use the Makefile for packaging

## Project Structure

```
conduit/
├── cprm-bin             # Main bash wrapper
├── conduit.py           # Python backend
├── cprm.sh              # Shell integration
├── file_operations.py   # Python helper module
├── requirements.txt     # Python dependencies
├── Makefile             # For system-wide installation
└── install.sh           # Local installation script
```

### Installation Layout

**Local installation (`./install.sh`):**
```
~/.local/bin/cprm-bin              # Executable (symlink)
~/.local/share/cprm/conduit.py     # Python library
~/.local/share/cprm/file_operations.py
~/.local/share/cprm/cprm.sh        # Shell integration
```

**System installation (`make install`):**
```
/usr/local/bin/cprm-bin                     # Executable
/usr/local/share/cprm/conduit.py            # Python library
/usr/local/share/cprm/file_operations.py
/usr/local/share/cprm/cprm.sh               # Shell integration
```

## Usage

### Initialize config
```bash
cprm make
```

### Add a project
```bash
cd /path/to/your/project
cprm init myproject
```

### Jump to a project
```bash
cprm j myproject
```

That's it! The `cprm` command handles everything.

## How it works

- `cprm` is a bash wrapper that handles both jumping (cd) and other commands
- The `cprm j` command changes your directory when used with the alias
- All other commands (`make`, `init`) are passed to the Python backend
- Projects are stored in `~/.config/cprm/config.toml`
