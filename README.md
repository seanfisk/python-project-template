# Python Project Template

This project provides a minimalistic template Python project which can be used as a starter template to structure projects.

There are no specific tooling choices except for pipenv. Although included in the pipfiles's dev packages section are some of the tools I usually work with.

## Project Setup

This will be the `README` for your project. For now, follow these instructions to get this project template set up correctly. Then, come back and replace the contents of this `README` with contents specific to your project.

## Structure
```
.
├── setup.cfg      | Project configuration for dev packages
├── setup.py       | Setuptools project setup
├── MANIFEST.in    | For packaging
├── Pipfile        | For dependency management
├── README.md      | Informational
├── notebooks      | Folder for Jupyter notebooks
├── docs           | Folder for documentation
├── src            | Folder for all the packages
└── tests          | Folder for all the tests
```

## Can evolve to this ideal structure
```
.
├── .gitignore           | git ignore file
├── setup.cfg            | Project configuration for dev packages
├── setup.py             | Setuptools project setup
├── MANIFEST.in          | For packaging
├── Pipfile              | For dependency management
├── Pipfile.lock         | For dependency management
├── requirements.txt     | For dependency management
├── README.md            | Informational
├── LICENSE              | Legal
├── .venv                | virtual environment folder
├── notebooks            | Folder for Jupyter notebooks
├── docs                 | Folder for documentation
├   ├── generated        | Folder for generated documentation
├── src                  | Folder for all the packages
├   ├── my-package1      |
├       ├── __init__.py  |
├       ├── main.py      |
├   ├── my-package2      |
├       ├── __init__.py  |
└── tests                | Folder for all the tests
├   ├── my-package1      |
├       ├── test_main.py |
├   ├── my-package2      |
```

## Instructions

1. Create a git repo for your project, I prefer doing this rather than cloning so that I don't need to delete that .git folder in the clone. Also I get the latest .gitignore for python everytime.
2. Download this template project as a zip, copy everything it into your git repo except the README.md file.
3. Change the `classifiers` keyword in `setup.py`. This will require modification.

## Standard procedure that I follow

1. Create a new virtual environment for your project:

    ```shell
    python -m venv .venv --prompt "Cool Prompt"
    source .venv/bin/activate
      (or)
    .venv\Scripts\activate
    ```
2. Lock the project's development and runtime requirements

    ```shell
    python -m pipenv lock
    python -m pipenv lock -r requirements.txt
    ```
3. Sync venv with the pinned packages

    ```shell
    python -m pipenv synv --dev
    ```
