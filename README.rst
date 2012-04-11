========
 README
========

This will be the README for your project. For now, follow these instructions to
get this project template setup correctly. Then, come back an replace the
contents of this README with contents specific to your project.

Instructions
============

.. note:: ``my_module`` is used as the generic name for your Python module
   throughout the skeleton. You should replace it with your module name. The
   instructions should guide you through most of the necessary renames. However,
   to make sure there are no instances left, you can run this command in your
   project root::

     grep -F --recursive my_module .

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
   is consistent with the one you used in the metadata.

#. Rename ``conf.py.old`` back to the correct name::

     cd source
     mv conf.py.old conf.py

#. Tell Sphinx to pull docstrings out of your module::

     sphinx-apidoc -o . ../../my_new_module

#. This will produce ``modules.rst`` and ``my_new_module.rst``. Now, in
   ``index.rst``, add the modules document to the table of contents.

#. Generate the documentation::

     cd ..
     make html
