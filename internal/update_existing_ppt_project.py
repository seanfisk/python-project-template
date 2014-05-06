#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function
import os
import sys
import imp
import shutil
import argparse
import subprocess
# Too bad we don't have TemporaryDirectory from Python 3.2. Guess we'll settle
# for mkdtemp.
from tempfile import mkdtemp

import test

## Python 2.6 subprocess.check_output compatibility. Thanks Greg Hewgill!
if 'check_output' not in dir(subprocess):
    def check_output(cmd_args, *args, **kwargs):
        proc = subprocess.Popen(
            cmd_args, *args,
            stdout=subprocess.PIPE, stderr=subprocess.PIPE, **kwargs)
        out, err = proc.communicate()
        if proc.returncode != 0:
            raise subprocess.CalledProcessError(args)
        return out
    subprocess.check_output = check_output


class cwd(object):
    """Class used for temporarily changing directories. Can be though of
    as a `pushd /my/dir' then a `popd' at the end.
    """
    def __init__(self, newcwd):
        """:param newcwd: directory to make the cwd
        :type newcwd: :class:`str`
        """
        self.newcwd = newcwd

    def __enter__(self):
        self.oldcwd = os.getcwd()
        os.chdir(self.newcwd)
        return os.getcwd()

    def __exit__(self, type_, value, traceback):
        # This acts like a `finally' clause: it will always be executed.
        os.chdir(self.oldcwd)


def main(argv):
    arg_parser = argparse.ArgumentParser(
        description='Update the Python Project Template using diff3.')
    arg_parser.add_argument(
        'current_project_directory',
        help='Directory for the project wanting to be updated')
    # arg_parser.add_argument(
    #     'old_ppt_directory',
    #     help='PPT version from which this project originated')
    # arg_parser.add_argument(
    #     'new_ppt_directory',
    #     help='PPT version to which this project should be updated')

    args = arg_parser.parse_args(args=argv[1:])

    # Find the .ppt-version file and read the commit hash from it.
    ppt_version_path = os.path.join(
        args.current_project_directory, '.ppt-version')
    if not os.path.exists(ppt_version_path):
        raise SystemExit(
            'PPT version cookie not found: {0}'.format(ppt_version_path))
    with open(ppt_version_path) as ppt_version_file:
        for line in ppt_version_file:
            # Allow for comments in the file.
            if not line.startswith('#'):
                old_revision = line.rstrip()
                break

    # Grab the path to metadata from setup.py, as we know where that file is.
    # We're not sure of the directory where metadata.py resides. We need to
    # change directories instead of importing the module directly because there
    # are dependent imports.
    print("Finding project's `metadata.py' file...")
    with cwd(args.current_project_directory):
        current_project_setup_module = imp.load_source(
            'setup', os.path.join(args.current_project_directory, 'setup.py'))
    package_name = current_project_setup_module.metadata.package
    metadata_path = os.path.join(
        args.current_project_directory, package_name, 'metadata.py')
    if not os.path.exists(metadata_path):
        raise SystemExit(
            'Project metadata file not found: {0}'.format(metadata_path))

    # Setup the new PPT directory.
    print('Setting up new PPT directory...')
    new_ppt_directory = mkdtemp(prefix='ppt-new-')
    test.main(['unused_progname',
               '--metadata-path', metadata_path,
               new_ppt_directory])

    # Setup the old PPT directory.
    print('Setting up old PPT directory...')
    old_ppt_directory = mkdtemp(prefix='ppt-old-')
    test.main(['unused_progname',
               '--metadata-path', metadata_path,
               '--revision', old_revision,
               old_ppt_directory])

    dirs = [
        args.current_project_directory,
        old_ppt_directory,
        new_ppt_directory,
    ]

    with cwd(args.current_project_directory):
        git_ls_files = subprocess.check_output(
            ['git', 'ls-files']).splitlines()

    # Don't diff3 the version cookie.
    git_ls_files.remove('.ppt-version')

    print('Running diff3...')
    for git_path in git_ls_files:
        paths = []
        for dir_ in dirs:
            path = os.path.join(dir_, git_path)
            if not os.path.exists(path):
                path = '/dev/null'
            paths.append(path)
        process = subprocess.Popen(
            ['diff3', '--merge'] + paths,
            stdout=subprocess.PIPE)
        diff3_out, diff3_err = process.communicate()
        if process.returncode != 0:
            print('{0}: merge conflicts found, please resolve manually'.format(
                paths[0]))
        with open(paths[0], 'w') as current_file:
            current_file.write(diff3_out)

    new_revision = subprocess.check_output(
        ['git', 'rev-parse', 'HEAD']).rstrip()
    print('Updating PPT version cookie (revision {0})...'.format(new_revision))
    # Open file for reading and writing.
    with open(ppt_version_path, 'r+') as ppt_version_file:
        # Strip off the last line.
        new_contents_lines = ppt_version_file.readlines()[:-1]
        # Append the new revision.
        new_contents_lines.append(new_revision)
        # Write new contents to file.
        new_contents = ''.join(new_contents_lines)
        ppt_version_file.seek(0)
        print(new_contents, file=ppt_version_file)

    print('Removing temporary directories...')
    for dir_ in [old_ppt_directory, new_ppt_directory]:
        shutil.rmtree(dir_)


if __name__ == '__main__':
    raise SystemExit(main(sys.argv))
