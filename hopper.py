import os
import conduit
def jump(config_path: Path, name: str) -> str:
    """Search for a project by name and return its path."""
    config = conduit.load_config(config_path)

    if "projects" not in config:
        raise RuntimeError("No projects found in config.")

    if name not in config["projects"]:
        raise RuntimeError(f"Project '{name}' not found.")

    os.chdir(config["projects"][name])
