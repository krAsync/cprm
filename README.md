# cprm - Project Manager

A simple project manager that lets you quickly jump between projects.

## Installation

1. Clone this repository:

```bash
git clone <repo-url> ~/.cprm
cd ~/.cprm
```

2. Run the install script:

```bash
./install.sh
```

3. Reload your shell:

```bash
source ~/.bashrc  # or source ~/.zshrc
```

That's it! The install script will automatically:
- Create a symlink in `~/.local/bin/cprm`
- Add the required alias to your shell config
- Make sure everything is executable

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
