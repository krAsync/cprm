import argparse

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

if args.command == "init":
    if args.force:
        pass
       

