#!/usr/bin/env python

# This script allows easy testing of the template project. The only argument
# is the directory to which to copy and generate the template project.

from __future__ import print_function
import os
import shutil
import sys


def main(argv):
    if len(argv) != 2:
        raise SystemExit('Usage: {0} GEN_PATH'.format(argv[0]))

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

    # Don't run tox for now, because there are reasons to generate the project
    # and not run tox immediately, such as testing sdist, testing Paver tasks,
    # etc. Just suggest running `tox' or `detox' manually afterward in the
    # shell script.

    # Run tox.
    # import tox
    # tox will raise SystemExit() and try to exit. We don't want that.
    # try:
    #     tox.cmdline(argv[2:])
    # except SystemExit:
    #     pass

    # Print out the directory name for the shell script.
    print(temp_dir)


if __name__ == '__main__':
    main(sys.argv)
