"""File and dotfile creation operations for Conduit."""
from pathlib import Path


def create_main_config(config_path: Path):
    """Create the main configuration file at the specified path.

    Args:
        config_path: Path where the config file should be created
    """
    config_path.parent.mkdir(parents=True, exist_ok=True)
    config_path.write_text(
        "[general]\n"
        "debug = false\n"
        "[projects]\n"
    )
    print(f"Main config created at {config_path}")


def create_dot_conduit(path: Path):
    """Create the .cprm dotfile in the specified directory.

    Args:
        path: Directory where the .cprm file should be created

    Returns:
        Path to the created dotfile
    """
    dot_file = path / ".cprm"
    dot_file.write_text("# Conduit project marker\n")
    print(f"Created {dot_file}")
    return dot_file
