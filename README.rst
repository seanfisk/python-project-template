This project provides a template Python project for using distutils for
distribution and Sphinx for documentation. It saves you work by setting a number
of things up for you, including project directory structure, a basic Distutils
setup script, Sphinx configuration with the `Flask theme`_, and a project
metadata setup which applies to the Distutils script, Sphinx configuration, and
can also be used inside your project.

.. _Flask theme: https://github.com/mitsuhiko/flask-sphinx-themes

===============
 Project Setup
===============

This will be the README for your project. For now, follow these instructions to
get this project template setup correctly. Then, come back an replace the
contents of this README with contents specific to your project.

Instructions
============

#. Edit the metadata file ``my_module/metadata.py`` to correctly describe your
   project.

#. Edit ``setup.py`` to import from your module and edit the ``classifiers``,
   ``packages``, and ``scripts`` keywords as necessary.

#. Tell Sphinx to pull docstrings out of your module::

       sphinx-apidoc -o . ../../my_new_module

   It will be necessary to re-run this every time a new module is added to your
   package. You must delete the old files as ``sphinx-apidoc`` will not
   overwrite them.

#. Now come back and replace this README with your own text.

Notes
=====

``my_module`` is used as the generic name for your Python module throughout the
skeleton. You should replace it with your module name. The instructions should
guide you through most of the necessary renames. However, to make sure there are
no instances left, you can run this command in your project root::

    grep -F --recursive my_module .
