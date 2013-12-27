=========================
 Python Project Template
=========================

.. image:: https://travis-ci.org/seanfisk/python-project-template.png
   :target: https://travis-ci.org/seanfisk/python-project-template

This project provides a best-practices template Python project which integrates several different tools. It saves you work by setting up a number of things, including documentation, code checking, and unit test runners.

As it is an all-in-one solution, the tools used are rather opinionated. They include:

* Paver_ for running miscellaneous tasks
* Setuptools_ for distribution (Setuptools and Distribute_ have merged_)
* Sphinx_ for documentation
* flake8_ for source code checking
* pytest_ for unit testing
* mock_ for mocking (not required by the template, but included anyway)
* tox_ for testing on multiple Python versions

If you are new to Python or new to creating Python projects, see Kenneth Reitz's `Hitchhiker's Guide to Python`_ for an explanation of some of the tools used here.

.. _Paver: http://paver.github.io/paver/
.. _Setuptools: http://pythonhosted.org/setuptools/merge.html
.. _Distribute: http://pythonhosted.org/distribute/
.. _merged: http://pythonhosted.org/setuptools/merge.html
.. _Sphinx: http://sphinx-doc.org/
.. _flake8: https://pypi.python.org/pypi/flake8
.. _pytest: http://pytest.org/latest/
.. _mock: http://www.voidspace.org.uk/python/mock/
.. _tox: http://testrun.org/tox/latest/
.. _Hitchhiker's Guide to Python: http://docs.python-guide.org/en/latest/

Project Setup
=============

This will be the README for your project. For now, follow these instructions to get this project template set up correctly. Then, come back and replace the contents of this README with contents specific to your project.

Instructions
------------

#. Clone the template project, replacing ``my-project`` with the name of the project you are creating::

        git clone https://github.com/seanfisk/python-project-template.git my-project
        cd my-project

#. Edit the metadata file ``my_module/metadata.py`` to correctly describe your project.

#. Generate files based upon the project metadata you just entered::

        python internal/generate.py

   The generation script will remove all the template files and generate real files, then self-destruct upon completion.

#. Delete the old git history and optionally re-initialize the repository::

        rm -rf .git
        git init

#. Change the license in ``setup.py`` and replace the generated ``LICENSE`` file with the one of your choice. If you would like to use the MIT license, no change is necessary.

#. Change the ``classifiers`` keyword in ``setup.py``. This *will* require modification.

#. Replace this README with your own text.

#. *(Optional, but good practice)* Create a new virtual environment for your project:

   With pyenv_ and pyenv-virtualenv_::

       pyenv virtualenv my-project
       pyenv local my-project

   With virtualenvwrapper_::

       mkvirtualenv my-project

   With plain virtualenv_::

       virtualenv /path/to/my-project-venv
       source /path/to/my-project-venv/bin/activate

   If you are new to virtual environments, please see the `Virtual Environment section`_ of Kenneth Reitz's Python Guide.

#. Install the project's development and runtime requirements::

        pip install -r requirements-dev.txt

#. Install ``argparse`` package when developing on Python 2.6::

        pip install argparse

#. Run the tests::

        paver test_all

   You should see output similar to this::

       $ paver test_all
       ---> pavement.test_all
       No style errors
       ========================================= test session starts =========================================
       platform darwin -- Python 2.7.3 -- pytest-2.3.4
       collected 5 items

       tests/test_main.py .....

       ====================================== 5 passed in 0.05 seconds =======================================
         ___  _   ___ ___ ___ ___
        | _ \/_\ / __/ __| __|   \
        |  _/ _ \\__ \__ \ _|| |) |
        |_|/_/ \_\___/___/___|___/

   The substitution performed is rather naive, so some style errors may be reported if the description or name cause lines to be too long. Correct these manually before moving to the next step. If any unit tests fail to pass, please report an issue.

Project setup is now complete!

.. _pyenv: https://github.com/yyuu/pyenv
.. _pyenv-virtualenv: https://github.com/yyuu/pyenv-virtualenv
.. _virtualenvwrapper: http://virtualenvwrapper.readthedocs.org/en/latest/index.html
.. _virtualenv: http://www.virtualenv.org/en/latest/
.. _Virtual Environment section: http://docs.python-guide.org/en/latest/dev/virtualenvs.html

Using Paver
-----------

The ``pavement.py`` file comes with a number of tasks already set up for you. You can see a full list by typing ``paver help`` in the project root directory. The following are included::

    Tasks from pavement:
    lint             - Perform PEP8 style check, run PyFlakes, and run McCabe complexity metrics on the code.
    doc_open         - Build the HTML docs and open them in a web browser.
    coverage         - Run tests and show test coverage report.
    doc_watch        - Watch for changes in the Sphinx documentation and rebuild when changed.
    test             - Run the unit tests.
    get_tasks        - Get all paver-defined tasks.
    commit           - Commit only if all the tests pass.
    test_all         - Perform a style check and run all unit tests.

For example, to run the both the unit tests and lint, run the following in the project root directory::

    paver test_all

To build the HTML documentation, then open it in a web browser::

    paver doc_open

Using Tox
---------

Tox is a tool for running your tests on all supported Python versions.
Running it via ``tox`` from the project root directory calls ``paver test_all`` behind the scenes for each Python version,
and does an additional test run to ensure documentation generation works flawlessly.
You can customize the list of supported and thus tested Python versions in the ``tox.ini`` file.

Pip Requirements Files vs. Setuptools ``install_requires`` Keyword
------------------------------------------------------------------

The difference in use case between these two mechanisms can be very confusing. The `pip requirements files`_ is the conventionally-named ``requirements.txt`` that sits in the root directory of many repositories, including this one. The `Setuptools install_requires keyword`_ is the list of dependencies declared in ``setup.py`` that is automatically installed by ``pip`` or ``easy_install`` when a package is installed. They have similar but distinct purposes:

``install_requires`` keyword
    Install runtime dependencies for the package. This list is meant to *exclude* versions of dependent packages that do not work with this Python package. This is intended to be run automatically by ``pip`` or ``easy_install``.

pip requirements file
    Install runtime and/or development dependencies for the package. Replicate an environment by specifying exact versions of packages that are confirmed to work together. The goal is to `ensure repeatability`_ and provide developers with an identical development environment. This is intended to be run manually by the developer using ``pip install -r requirements-dev.txt``.

For more information, see the answer provided by Ian Bicking (author of pip) to `this StackOverflow question`_.

.. _Pip requirements files: http://www.pip-installer.org/en/latest/requirements.html
.. _Setuptools install_requires keyword: http://pythonhosted.org/setuptools/setuptools.html?highlight=install_requires#declaring-dependencies
.. _ensure repeatability: http://www.pip-installer.org/en/latest/cookbook.html#ensuring-repeatability
.. _this StackOverflow question: http://stackoverflow.com/questions/6947988/when-to-use-pip-requirements-file-versus-install-requires-in-setup-py

Supported Python Versions
=========================

Python Project Template supports the following versions out of the box:

* CPython 2.6, 2.7, 3.3
* PyPy 1.9

CPython 3.0-3.2 may also work but are at this point unsupported. PyPy 2.0.2 is known to work but is not run on Travis-CI.

Jython_ and IronPython_ may also work, but have not been tested. If there is interest in support for these alternative implementations, please open a feature request!

.. _Jython: http://jython.org/
.. _IronPython: http://ironpython.net/

Licenses
========

The code which makes up this Python project template is licensed under the MIT/X11 license. Feel free to use it in your free software/open-source or proprietary projects.

The template also uses a number of other pieces of software, whose licenses are listed here for convenience. It is your responsibility to ensure that these licenses are up-to-date for the version of each tool you are using.

+------------------------+----------------------------------+
|Project                 |License                           |
+========================+==================================+
|Python itself           |Python Software Foundation License|
+------------------------+----------------------------------+
|argparse (now in stdlib)|Python Software Foundation License|
+------------------------+----------------------------------+
|Sphinx                  |Simplified BSD License            |
+------------------------+----------------------------------+
|Paver                   |Modified BSD License              |
+------------------------+----------------------------------+
|colorama                |Modified BSD License              |
+------------------------+----------------------------------+
|flake8                  |MIT/X11 License                   |
+------------------------+----------------------------------+
|mock                    |Modified BSD License              |
+------------------------+----------------------------------+
|pytest                  |MIT/X11 License                   |
+------------------------+----------------------------------+
|tox                     |MIT/X11 License                   |
+------------------------+----------------------------------+

Issues
======

Please report any bugs or requests that you have using the Github issue tracker!

Development
===========

If you wish to contribute, first make your changes. Then run the following from the project root directory::

    source internal/test.sh

This will copy the template directory to a temporary directory, run the generation, then run tox. Any arguments passed will go directly to the tox command line, e.g.::

    source internal/test.sh -e py27

This command line would just test Python 2.7.

Authors
=======

* Sean Fisk
* Benjamin Schwarze
