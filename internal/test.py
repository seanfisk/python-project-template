#!/usr/bin/env python

# This script allows easy testing of the template project. The only argument
# is the directory to which to copy and generate the template project.

from __future__ import print_function
import os
import sys
import shutil
import argparse
import subprocess
from distutils.dir_util import copy_tree


def main(argv):
    arg_parser = argparse.ArgumentParser(
        description='Update the Python Project Template using diff3.')
    arg_parser.add_argument(
        'generation_path',
        help='Directory in which to copy the template and run generation')
    arg_parser.add_argument(
        '--metadata-path',
        help='Metadata file to use in project generation')
    arg_parser.add_argument(
        '--revision',
        help='Revision of PPT to checkout')
    args = arg_parser.parse_args(args=argv[1:])

    # Get the project root directory.
    project_root = os.path.dirname(os.path.dirname(
        os.path.realpath(__file__)))

    # Copy files to the generation directory.
    temp_dir = args.generation_path
    print('Copying files to', temp_dir)
    # shutil.copytree requires that the destination directory not exist. Since
    # we are dealing with mostly temporary directories, this creates race
    # conditions _and_ is simply annoying. distutils.dir_util.copy_tree works
    # nicely for this.
    copy_tree(project_root, temp_dir)

    # Get the metadata source file abspath if that was requested.
    if args.metadata_path:
        source_metadata_path = os.path.abspath(args.metadata_path)

    # Switch to the newly-created generation directory.
    old_cwd = os.getcwd()
    print('Switching to', temp_dir)
    os.chdir(temp_dir)

    # Checkout the old revision if that was requested.
    if args.revision:
        print('Checking out revision', args.revision)
        subprocess.check_call(['git', 'checkout', args.revision])

    # Copy the metadata file if that was requested. Must happen after the git
    # checkout.
    if args.metadata_path:
        dest_metadata_path = os.path.join('my_module', 'metadata.py')
        shutil.copyfile(source_metadata_path, dest_metadata_path)

    # Run generation. Instead of importing we run directly with python. Too
    # many things could go wrong with importing.
    subprocess.check_call(['python', os.path.join('internal', 'generate.py')])

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

    os.chdir(old_cwd)


if __name__ == '__main__':
    main(sys.argv)
