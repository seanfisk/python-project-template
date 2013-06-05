#!/usr/bin/env python
""":mod:`${package}.main` -- Program entry point
"""

from __future__ import print_function

import argparse
import sys

from $package import metadata


def _main(argv):
    """Program entry point.

    :param argv: command-line arguments
    :type argv: :class:`list`
    """
    author_strings = []
    for name, email in zip(metadata.authors, metadata.emails):
        author_strings.append('Author: {0} <{1}>'.format(name, email))

    epilog = '''
{project} {version}

{authors}
URL: <{url}>
'''.format(
        project=metadata.project,
        version=metadata.version,
        authors='\n'.join(author_strings),
        url=metadata.url)

    arg_parser = argparse.ArgumentParser(
        prog=argv[0],
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=metadata.description,
        epilog=epilog)
    arg_parser.add_argument(
        '-v', '--version',
        action='version',
        version='{0} {1}'.format(metadata.project, metadata.version))

    arg_parser.parse_args(args=argv[1:])

    print(epilog)

    return 0


def main():
    """Main for use with setuptools/distribute."""
    raise SystemExit(_main(sys.argv))


if __name__ == '__main__':
    main()
