=========================
 Python Project Template
=========================

This project provides a template Python project for using several different tools. It saves you work by setting up a number of things, including documentation, code checking, and unit test runners.

As it is a personal template project, the tools are rather opinionated. Tools used include:

* Paver_ for running miscellaneous tasks
* Distribute_ for distribution
* Sphinx_ for documentation
* flake8_ for source code checking
* pytest_ for unit testing
* mock_ for mocking

.. _Paver: http://paver.github.io/paver/
.. _Distribute: http://pythonhosted.org/distribute/
.. _Sphinx: http://sphinx-doc.org/
.. _flake8: https://pypi.python.org/pypi/flake8
.. _pytest: http://pytest.org/latest/
.. _mock: http://www.voidspace.org.uk/python/mock/

Project Setup
=============

This will be the README for your project. For now, follow these instructions to get this project template set up correctly. Then, come back and replace the contents of this README with contents specific to your project.

Instructions
------------

#. Clone the template project and remove the git history::

        git clone https://github.com/seanfisk/python-project-template.git my-module
        cd my-module
        rm -rf .git

#. Edit the metadata file ``my_module/metadata.py`` to correctly describe your project. Don't forget to correct the docstring.

#. Generate files based upon the project metadata you just entered::

        python GENERATE.py

   The generation script will remove all the template files and generate real files, then self-destruct upon completion.

#. Edit ``pavement.py`` to change the ``classifiers`` keyword as necessary.

#. Replace this README with your own text.

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

    $ paver test_all
    ---> pavement.test_all
    No style errors
    ========================================= test session starts =========================================
    platform darwin -- Python 2.7.3 -- pytest-2.3.4
    collected 5 items

    tests/test_main.py .....

    ====================================== 5 passed in 0.05 seconds =======================================
    .______      ___           _______.     _______. _______  _______
    |   _  \    /   \         /       |    /       ||   ____||       \
    |  |_)  |  /  ^  \       |   (----`   |   (----`|  |__   |  .--.  |
    |   ___/  /  /_\  \       \   \        \   \    |   __|  |  |  |  |
    |  |     /  _____  \  .----)   |   .----)   |   |  |____ |  '--'  |
    | _|    /__/     \__\ |_______/    |_______/    |_______||_______/

Issues
======

Please report any bugs or requests that you have using the Github issue tracker!

Authors
=======

* Sean Fisk
* Benjamin Schwarze
