import argparse
import sys
from config.init import init_config  # import funkce z modulu

def confirm_force() -> bool:
    return input(
        "This will overwrite existing config. Continue? [y/N]: "
    ).lower() in ("y", "yes")

def main():
    parser = argparse.ArgumentParser(prog="mytool")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # init command
    init_parser = subparsers.add_parser("make", help="create config file")
    init_parser.add_argument(
        "-f", "--force",
        action="store_true",
        help="Force initialization"
    )

    args = parser.parse_args()

    if args.command == "make":
        if args.force and not confirm_force():
            print("Aborted.")
            sys.exit(1)

        try:
            init_config(force=args.force)
        except RuntimeError as e:
            print(e)
            sys.exit(1)

if __name__ == "__main__":
    main()
