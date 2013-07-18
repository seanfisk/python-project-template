#!/usr/bin/env python

# This script allows easy testing of the template project. The first argument
# is the directory to which to copy and generate the template project.

from __future__ import print_function
import os
import shutil
import sys

TOX_INI_FILENAME = 'tox.ini'


def main(argv):
    if len(argv) != 2:
        print('Usage: {0} GEN_PATH', file=sys.stderr)

    # Get the original project root directory.
    project_root = os.path.dirname(os.path.dirname(
        os.path.realpath(__file__)))

    # The directory to which the project will be copied.
    temp_dir = argv[1]
    print('Copying files to', temp_dir)

    # Copy everything besides the `.tox' directory.
    listing = os.listdir()
    try:
        listing.remove('.tox')
    except ValueError:
        pass

    for top_level_file in listing:
        src = os.path.join(project_root, top_level_file)
        dest = os.path.join(temp_dir, top_level_file)
        if os.path.isdir(top_level_file):
            shutil.copytree(src, dest)
        elif os.path.isfile(top_level_file):
            shutil.copy2(src, dest)

    os.chdir(temp_dir)

    # Run generation.
    sys.path.insert(0, os.path.realpath('internal'))
    import generate
    generate.main()

    # Modify tox configuration.

    # We need to modify the `toxworkdir' to the full path to
    # `python-project-template/.tox' directory so we can cache it. Haven't been
    # able to find out how to modify config values on the command line or using
    # tox APIs itself, so this will have to do for now.

    # Also, pylib's ini parser (which tox uses) doesn't write ini files, so
    # we're out of luck there.

    try:
        # Python 3
        from configparser import RawConfigParser
    except ImportError:
        # Python 2
        from ConfigParser import RawConfigParser
    parser = RawConfigParser()
    parser.read(TOX_INI_FILENAME)

    # Use the Python 3 legacy API for compatibility with Python 2.
    parser.set('tox', 'toxworkdir', os.path.join(project_root, '.tox'))

    # Tox will recreate the virtualenvs if a path to a different requirement
    # file is used, even if the contents are the same. We want it to cache
    # virtualenvs (that's the whole point). This works around it.
    parser.set('testenv', 'deps', '''
--no-deps
--requirement
{toxworkdir}/../requirements-dev.txt''')

    # Rewrite `tox.ini' with these values.
    with open(TOX_INI_FILENAME, 'w') as tox_ini_file:
        parser.write(tox_ini_file)

    # Run tox.

    # For the life of me I can't figure out how to run tox correctly from
    # here. This would be how I would do it though. I think it has something to
    # do with running within a virtualenv.

    # tox only accepts a path to the config file, not a file object, so we
    # can't use StringIO. Guess we'll settle for a temporary file. Sigh...

    # tox will raise SystemExit() with a correct exit code. The __exit__
    # function *will* still be invoked, so the temporary file *will* be cleaned
    # up.

    # Open the temporary file in text mode so Python 3 doesn't complain when it
    # has to encode the strings.

    # from tempfile import NamedTemporaryFile
    # with NamedTemporaryFile(
    #         mode='w', dir=temp_dir, suffix='.ini') as tmp_config_file:
    #     import tox
    #     tox.cmdline(['tox'] + ['-c', tmp_config_file.name] + argv[2:])
    #     # or
    #     import subprocess
    #     subprocess.call(['tox'] + ['-c', tmp_config_file.name] + argv[2:])


if __name__ == '__main__':
    raise SystemExit(main(sys.argv))
