#!/usr/bin/env python

# This script replaces all template files with a real file with contents
# properly substituted.

from __future__ import print_function
import os
import sys
import os.path
import subprocess
from string import Template

sys.path.append('my_module')
# Can't use `from my_module import metadata' since `__init__.py' is templated.
import metadata


def only_tpl(filename):
    return os.path.splitext(filename)[1] == '.tpl'

git_file_names = subprocess.check_output(['git', 'ls-files']).splitlines()
tpl_file_names = filter(only_tpl, git_file_names)

# Surround each key with an extra pair of `{}' so it doesn't interfere with
# regular format statements.

# metadata_keywords = dict(
#     (('{' + key + '}', val) for key, val in metadata.__dict__.iteritems()))

for tpl_file_name in tpl_file_names:
    with open(tpl_file_name) as tpl_file:
        template = Template(tpl_file.read())
    # Using splitext cuts off the last extension.
    real_file_name = os.path.splitext(tpl_file_name)[0]
    with open(real_file_name, 'w') as real_file:
        print(template.safe_substitute(**metadata.__dict__), file=real_file)
