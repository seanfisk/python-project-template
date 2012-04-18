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

#. Correct the docstring in ``my_module/__init__.py`` to the correct name of
   your module.

#. Rename the ``my_module`` directory to the name of your module::

     mv my_module my_new_module

#. Edit ``setup.py`` to import from your module and edit the ``classifiers``,
   ``packages``, and ``scripts`` keywords as necessary.

#. Edit ``scripts/my_module_runner`` as necessary or remove it if you don't need
   any scripts.

#. Now we need to setup the documentation. This has a few steps. First, go into
   the documentation source directory::

       cd docs/source
      
#. Edit ``conf.py`` by changing the module import to correctly import from your
   module.
 
#. Rename ``conf.py`` so we can run ``sphinx-quickstart``::

       mv conf.py conf.py.old
       cd ..
       sphinx-quickstart
      
#. For the answers to the questions, not too much matters since we will be
   replacing most of with our own configuration. Make sure to say yes to
   separate build and source directories, and make sure that the title you input
   is consistent with the one you used in the metadata. The reason it must be
   consistent is that ``sphinx-quickstart`` uses project-specific names in its
   ``Makefile`` for a number of different targets. I have not found a way around
   this.

#. Rename ``conf.py.old`` back to the correct name::

       cd source
       mv conf.py.old conf.py

#. Tell Sphinx to pull docstrings out of your module::

       sphinx-apidoc -o . ../../my_new_module

   It will be necessary to re-run this every time a new module is added to your
   package. You must delete the old files as ``sphinx-apidoc`` will not
   overwrite them.

#. This will produce ``modules.rst`` and ``my_new_module.rst``. Now, in
   ``index.rst``, add the modules document to the table of contents.

#. Generate the documentation::

       cd ..
       make html

#. Now come back and replace this README with your own text.

Notes
=====

``my_module`` is used as the generic name for your Python module throughout the
skeleton. You should replace it with your module name. The instructions should
guide you through most of the necessary renames. However, to make sure there are
no instances left, you can run this command in your project root::

    grep -F --recursive my_module .
