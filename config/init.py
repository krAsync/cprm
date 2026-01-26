from pathlib import Path

CONFIG_PATH = Path.home() / ".config" / "conduit" / "config.toml"

def create_config():
    CONFIG_PATH.parent.mkdir(parents=True, exist_ok=True)
    CONFIG_PATH.write_text(
        "[general]\n"
        "debug = false\n"
    )

def init_config(force: bool = False):
    if CONFIG_PATH.exists() and not force:
        raise RuntimeError("Config already exists. Use --force.")

    create_config()
