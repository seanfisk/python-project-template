# -*- coding: utf-8; -*-

from __future__ import print_function
import os
import sys
import time
import subprocess

from setuptools import find_packages
from paver.easy import options, task, Bunch, needs
from paver.setuputils import install_distutils_tasks
import paver.doctools

import colorama
colorama.init()  # Initialize colorama on Windows

sys.path.append('.')
from $package import metadata

## Constants
CODE_DIRECTORY = '$package'
TESTS_DIRECTORY = 'tests'

## Miscellaneous helper functions


# Credit: <http://packages.python.org/an_example_pypi_project/setuptools.html>
#
# This is a utility function to read the README file used for the
# long_description.  It's nice, because now 1) we have a top level
# README file and 2) it's easier to type in the README file than to
# put a raw string in below ...
def read(filename):
    return open(os.path.join(os.path.dirname(__file__), filename)).read()


def get_project_files():
    # Use `git ls-files' to get all files tracked in this project.
    return subprocess.check_output(['git', 'ls-files']).splitlines()


def print_success_message(message):
    """Print a message indicating success in green color to STDOUT.

    :param message: the message to print
    :type message: :class:`str`
    """
    print(colorama.Fore.GREEN + message + colorama.Fore.RESET)


def print_failure_message(message):
    """Print a message indicating failure in red color to STDERR.

    :param message: the message to print
    :type message: :class:`str`
    """
    print(colorama.Fore.RED + message + colorama.Fore.RESET, file=sys.stderr)


options(
    # see here for more options:
    # <http://packages.python.org/distribute/setuptools.html>
    setup=dict(
        name=metadata.project,
        version=metadata.version,
        author=metadata.authors[0],
        author_email=metadata.emails[0],
        maintainer=metadata.authors[0],
        maintainer_email=metadata.emails[0],
        url=metadata.url,
        description=metadata.description,
        long_description=read('README.rst'),
        download_url=metadata.url,
        # Find a list of classifiers here:
        # <http://pypi.python.org/pypi?%3Aaction=list_classifiers>
        classifiers=[
            'Development Status :: 1 - Planning',
            'Environment :: Console',
            'Intended Audience :: Developers',
            'License :: OSI Approved :: ISC License (ISCL)',
            'Natural Language :: English',
            'Operating System :: OS Independent',
            'Programming Language :: Python',
            'Topic :: Documentation',
            'Topic :: Software Development :: Libraries :: Python Modules',
            'Topic :: System :: Installation/Setup',
            'Topic :: System :: Software Distribution',
        ],
        packages=find_packages(),
        install_requires=['argparse'],
        zip_safe=False,  # don't use eggs
        entry_points={
            'console_scripts': [
                '${package}_cli = ${package}.main:main'
            ],
            # if you have a gui, use this
            # 'gui_scripts': [
            #     '${package}_gui = ${package}.gui:main'
            # ]
        }
    ),
    sphinx=Bunch(
        builddir='build',
        sourcedir='source',
    )
)

install_distutils_tasks()

## Task-related functions


def _lint():
    """Run lint and return an exit code."""
    # Flake8 doesn't have an easy way to run checks using a Python function, so
    # just fork off another process to do it.

    # Only check version controlled files by using `git ls-files'. This avoids
    # checking generated files, such as PySide's resource files.
    git_python_files = filter(
        lambda filename: filename.endswith('.py'),
        get_project_files())
    retcode = subprocess.call(
        ['flake8', '--max-complexity=10'] + git_python_files)
    if retcode == 0:
        print_success_message('No style errors')
    return retcode


def _test():
    """Run the unit tests.

    :return: exit code
    """
    import pytest
    # This runs the unit tests.
    # It also runs doctest, but only on the modules in TESTS_DIRECTORY.
    return pytest.main(['--doctest-modules', TESTS_DIRECTORY])


def _test_all():
    """Run lint and tests.

    :return: exit code
    """
    return _lint() + _test()


def _big_text(text):
    """Render huge ASCII text.

    :return: the formatted text
    :rtype: :class:`str`
    """
    from pyfiglet import Figlet
    return Figlet(font='starwars').renderText(text)


## Tasks

@task
def test():
    """Run the unit tests."""
    raise SystemExit(_test())


@task
def lint():
    # This refuses to format properly when running `paver help' unless
    # this ugliness is used.
    ('Perform PEP8 style check, run PyFlakes, and run McCabe complexity '
     'metrics on the code.')
    raise SystemExit(_lint())


@task
def test_all():
    """Perform a style check and run all unit tests."""
    retcode = _test_all()
    if retcode == 0:
        print_success_message(_big_text('PASSED'))
    else:
        print_failure_message(_big_text('FAILED'))
    raise SystemExit(retcode)


@task
def commit():
    """Commit only if all the tests pass."""
    if _test_all() == 0:
        subprocess.check_call(['git', 'commit'])
    else:
        print_failure_message('\nTests failed, not committing.')


@task
def coverage():
    """Run tests and show test coverage report."""
    try:
        import pytest_cov  # NOQA
    except ImportError:
        print_failure_message(
            'Install the pytest coverage plugin to use this task, '
            "i.e., `pip install pytest-cov'.")
        raise SystemExit(1)
        import pytest
        pytest.main(['--cov', CODE_DIRECTORY,
                     '--cov-report', 'term-missing',
                     TESTS_DIRECTORY])


@task  # NOQA
def doc_watch():
    ('Watch for changes in the Sphinx documentation and rebuild when '
     'changed.')
    try:
        from watchdog.events import FileSystemEventHandler
        from watchdog.observers import Observer
    except ImportError:
        print_failure_message('Install the watchdog package to use this task, '
                              "i.e., `pip install watchdog'.")
        raise SystemExit(1)

    class RebuildDocsEventHandler(FileSystemEventHandler):
        def __init__(self, base_paths):
            self.base_paths = base_paths

        def dispatch(self, event):
            """Dispatches events to the appropriate methods.
            :param event: The event object representing the file system event.
            :type event: :class:`watchdog.events.FileSystemEvent`
            """
            for base_path in self.base_paths:
                if event.src_path.endswith(base_path):
                    super(RebuildDocsEventHandler, self).dispatch(event)
                    # We found one that matches. We're done.
                    return

        def on_modified(self, event):
            print_failure_message('Modification detected. Rebuilding docs.')
            # # Strip off the path prefix.
            # if event.src_path[len(os.getcwd()) + 1:].startswith(
            #         CODE_DIRECTORY):
            #     # sphinx-build doesn't always pick up changes on code files,
            #     # even though they are used to generate the documentation. As
            #     # a workaround, just clean before building.
            #     paver.doctools.doc_clean()
            paver.doctools.html()
            print_success_message('Docs have been rebuilt.')

    print_success_message(
        'Watching for changes in project files, press Ctrl-C to cancel...')
    handler = RebuildDocsEventHandler(get_project_files())
    observer = Observer()
    observer.schedule(handler, path='.', recursive=True)
    observer.start()
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
        observer.join()


@task
@needs(['html'])
def doc_open():
    """Build the HTML docs and open them in a web browser."""
    doc_index = 'docs/build/html/index.html'
    if sys.platform == 'darwin':
        # Mac OS X
        subprocess.check_call(['open', doc_index])
    elif sys.platform == 'win32':
        # Windows
        subprocess.check_call(['start', doc_index], shell=True)
    elif sys.platform == 'linux2':
        # All freedesktop-compatible desktops
        subprocess.check_call(['xdg-open', doc_index])
    else:
        print_failure_message(
            "Unsupported platform. Please open `{0}' manually.".format(
                doc_index))


@task
def get_tasks():
    """Get all paver-defined tasks."""
    from paver.tasks import environment
    for task in environment.get_tasks():
        print(task.shortname)
