#!/usr/bin/env python

# This script replaces all template files with a real file with contents
# properly substituted.

from __future__ import print_function

import os
import os.path
import shutil
import stat
from string import Template
import sys


def main():
    # If not in the project root directory, go to it.
    project_root = os.path.dirname(os.path.dirname(
        os.path.realpath(__file__)))
    os.chdir(project_root)

    sys.path.insert(0, os.path.realpath('my_module'))
    # Can't use `from my_module import metadata' since `__init__.py' is
    # templated.
    import metadata

    # The title of the main documentation should match the project name in the
    # metadata. Under it should be a matching underline of equal signs. Produce
    # it for the template.
    project_underline = len(metadata.project) * '='

    # Substitute values into template files and produce their real
    # counterparts.
    for dirpath, dirnames, filenames in os.walk('.'):
        # Don't recurse into git directory.
        if '.git' in dirnames:
            dirnames.remove('.git')

        for filename in filenames:
            # Ignore all non-template files.
            # Using splitext cuts off the last extension.
            root, extension = os.path.splitext(filename)
            if extension != '.tpl':
                continue

            # Substitute values and write the new file.
            tpl_path = os.path.join(dirpath, filename)
            real_path = os.path.join(dirpath, root)

            with open(tpl_path) as tpl_file:
                template = Template(tpl_file.read())
            print('Substituting', tpl_path, '->', real_path)
            with open(real_path, 'w') as real_file:
                real_file.write(template.safe_substitute(
                    project_underline=project_underline,
                    **metadata.__dict__))

            # Remove the template file.
            os.remove(tpl_path)

    print('Renaming the package: my_module ->', metadata.package)
    os.rename('my_module', metadata.package)

    print('Making main script executable...')
    main_py_path = os.path.join(metadata.package, 'main.py')
    # This is a no-op on Windows.
    os.chmod(main_py_path, os.stat(main_py_path).st_mode | stat.S_IXUSR)

    print('Removing internal Travis-CI test file...')
    os.remove('.travis.yml')

    print("Revising `LICENSE' file...")
    # Open file for reading and writing.
    with open('LICENSE', 'r+') as license_file:
        # Strip off the first two lines.
        new_contents = ''.join(license_file.readlines()[2:])
        license_file.seek(0)
        print(new_contents, file=license_file)

    print('Removing internal directory...')
    shutil.rmtree('internal')

    print('''
To finish project setup:

1. Change the `classifiers' keyword in `setup.py' as necessary.
2. Change the license in `setup.py' and replace the generated `LICENSE' file
   with the one of your choice. If you would like to use the MIT license, no
   change is necessary.
3. Install `argparse' package when developing on Python 2.6.
4. Change `README.rst' to your own text.
''')


if __name__ == '__main__':
    main()
