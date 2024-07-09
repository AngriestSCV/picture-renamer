import os
import os.path
import argparse
import configparser
from common import *

def package(cfg):
    pass

def build(cfg):
    QTDIR = get_var(cfg, 'QTDIR')
    qmake_path = os.path.join(QTDIR, 'bin', 'qmake.exe')
    root = get_var(cfg, 'root')

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument("--build", action='store_true', help="Build the code")
    parser.add_argument("--package", action='store_true', help="Package the app")
    parser.add_argument("--configFile", default="build-config.ini", help="Package the app")

    parser.add_argument('--platform', required=True, help="The Platform to build for")

    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.configFile)

    cfg = config[args.platform]

    if args.build:
        build(cfg)
    elif args.package:
        package(cfg)

