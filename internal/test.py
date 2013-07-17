#!/usr/bin/env python

# This script allows easy testing of the template project. The first argument
# is the directory to which to copy and generate the template project. All
# other arguments go directly to tox.

from __future__ import print_function
import os
import shutil
import sys


def main(argv):
    if len(argv) == 1:
        print('Usage: {0} GEN_PATH [TOX_ARGS...]', file=sys.stderr)

    # Get the project root directory.
    project_root = os.path.dirname(os.path.dirname(
        os.path.realpath(__file__)))

    temp_dir = argv[1]
    print('Copying files to ', temp_dir)
    shutil.copytree(project_root, temp_dir)
    os.chdir(temp_dir)

    # Run generation.
    sys.path.insert(0, os.path.realpath('internal'))
    import generate
    generate.main()

    # Run tox.
    import tox
    # tox will raise SystemExit() and try to exit. We don't want that.
    try:
        tox.cmdline(argv[2:])
    except SystemExit:
        pass

    # Print out the directory name for the shell script.
    print(temp_dir)


if __name__ == '__main__':
    main(sys.argv)
