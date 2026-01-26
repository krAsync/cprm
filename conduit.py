import argparse
import sys
from pathlib import Path
import toml
from file_operations import create_main_config, create_dot_conduit

# --- hlavní config ---
DEFAULT_CONFIG_PATH = Path.home() / ".config" / "cprm" / "config.toml"

def load_config(config_path: Path) -> dict:
    if not config_path.exists():
        raise RuntimeError("Main config does not exist. Run 'make' first.")
    return toml.load(config_path)

def save_config(config_path: Path, data: dict):
    config_path.write_text(toml.dumps(data))

def add_project_to_config(config_path: Path, name: str, path: str):
    config = load_config(config_path)
    if "projects" not in config:
        config["projects"] = {}
    config["projects"][name] = str(Path(path).resolve())
    save_config(config_path, config)
    print(f"Project '{name}' added with path '{path}'")

def jump(config_path: Path, name: str) -> str:
    """Search for a project by name and return its path."""
    config = load_config(config_path)

    if "projects" not in config:
        raise RuntimeError("No projects found in config.")

    if name not in config["projects"]:
        raise RuntimeError(f"Project '{name}' not found.")

    return config["projects"][name]

# --- CLI ---
def main():
    parser = argparse.ArgumentParser(prog="conduit")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # make command → create main config
    make_parser = subparsers.add_parser("make", help="Create main config file")
    make_parser.add_argument("-f", "--force", action="store_true", help="Force overwrite")

    # init command → create .conduit file
    init_parser = subparsers.add_parser("init", help="Initialize project in current folder")
    init_parser.add_argument("name", help="Project name")
    init_parser.add_argument(
        "--config", help="Path to main config file",
        default=str(DEFAULT_CONFIG_PATH)
    )
    init_parser.add_argument(
        "-f", "--force", action="store_true", help="Force overwrite .conduit"
    )

    # jump command → get project path
    jump_parser = subparsers.add_parser("j", help="Jump to project directory")
    jump_parser.add_argument("name", help="Project name to search")
    jump_parser.add_argument(
        "--config", help="Path to main config file",
        default=str(DEFAULT_CONFIG_PATH)
    )

    args = parser.parse_args()

    if args.command == "make":
        config_path = DEFAULT_CONFIG_PATH
        if config_path.exists() and not args.force:
            print(f"Config already exists at {config_path}. Use --force to overwrite.")
            sys.exit(1)
        create_main_config(config_path)

    elif args.command == "init":
        cwd = Path.cwd()
        dot_file = cwd / ".cprm"
        create_dot_conduit(cwd)
        # přidání do hlavního configu
        config_path = Path(args.config)
        try:
            add_project_to_config(config_path, args.name, str(cwd))
        except RuntimeError as e:
            print(e)
            sys.exit(1)

    elif args.command == "j":
        config_path = Path(args.config)
        try:
            path = jump(config_path, args.name)
            print(path)  # Output path for shell: cd $(cprm j conduit)
        except RuntimeError as e:
            print(e, file=sys.stderr)
            sys.exit(1)

if __name__ == "__main__":
    main()
    #print(load_config(DEFAULT_CONFIG_PATH))
