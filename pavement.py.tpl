# -*- coding: utf-8; -*-

from __future__ import print_function

import sys
import time

import subprocess

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

from paver.easy import options, task, Bunch, needs
from paver.setuputils import install_distutils_tasks
import paver.doctools

try:
    import colorama
    colorama.init()  # Initialize colorama on Windows
except ImportError:
    # Don't require colorama just for running paver tasks. This allows us to
    # run `paver install' without requiring the user to first have colorama
    # installed.
    pass

sys.path.append('.')
from setup import setup_dict

## Constants
CODE_DIRECTORY = '$package'
TESTS_DIRECTORY = 'tests'

## Miscellaneous helper functions


def get_project_files():
    """Retrieve a list of all non-ignored files, including untracked files,
    excluding deleted files.

    :return: sorted list of project files
    :rtype: :class:`list`
    """
    cached_and_untracked_files = git_ls_files(
        '--cached',  # All files cached in the index
        '--others',  # Untracked files
        # Exclude untracked files that would be excluded by .gitignore, etc.
        '--exclude-standard')
    uncommitted_deleted_files = git_ls_files('--deleted')

    # Since sorting of files in a set is arbitrary, return a sorted list to
    # provide a well-defined order to tools like flake8, etc.
    return sorted(cached_and_untracked_files - uncommitted_deleted_files)


def git_ls_files(*cmd_args):
    """Run ``git ls-files`` in the top-level project directory. Arguments go
    directly to execution call.

    :return: set of file names
    :rtype: :class:`set`
    """
    cmd = ['git', 'ls-files']
    cmd.extend(cmd_args)
    return set(subprocess.check_output(cmd).splitlines())


def print_passed():
    # generated on http://patorjk.com/software/taag/#p=display&f=Small&t=PASSED
    print_success_message(r'  ___  _   ___ ___ ___ ___  ')
    print_success_message(r' | _ \/_\ / __/ __| __|   \ ')
    print_success_message(r' |  _/ _ \\__ \__ \ _|| |) |')
    print_success_message(r' |_|/_/ \_\___/___/___|___/ ')
    print_success_message(r'                            ')


def print_failed():
    # generated on http://patorjk.com/software/taag/#p=display&f=Small&t=FAILED
    print_failure_message(r'  ___ _   ___ _    ___ ___  ')
    print_failure_message(r' | __/_\ |_ _| |  | __|   \ ')
    print_failure_message(r' | _/ _ \ | || |__| _|| |) |')
    print_failure_message(r' |_/_/ \_\___|____|___|___/ ')
    print_failure_message(r'                            ')


def print_success_message(message):
    """Print a message indicating success in green color to STDOUT.

    :param message: the message to print
    :type message: :class:`str`
    """
    try:
        import colorama
        print(colorama.Fore.GREEN + message + colorama.Fore.RESET)
    except ImportError:
        print(message)


def print_failure_message(message):
    """Print a message indicating failure in red color to STDERR.

    :param message: the message to print
    :type message: :class:`str`
    """
    try:
        import colorama
        print(colorama.Fore.RED + message + colorama.Fore.RESET,
              file=sys.stderr)
    except ImportError:
        print(message, file=sys.stderr)


options(
    # see here for more options:
    # <http://packages.python.org/distribute/setuptools.html>
    setup=setup_dict,
    sphinx=Bunch(
        builddir='build',
        sourcedir='source',
    ),
    minilib=Bunch(
        extra_files=['doctools'],
    ),
)

install_distutils_tasks()

## Task-related functions


def _lint():
    """Run lint and return an exit code."""
    # Flake8 doesn't have an easy way to run checks using a Python function, so
    # just fork off another process to do it.

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


## Tasks

@task
@needs('html', 'setuptools.command.sdist')
def sdist():
    """Builds the documentation and the tarball."""
    pass


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
        print_passed()
    else:
        print_failed()
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
            # import os
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
