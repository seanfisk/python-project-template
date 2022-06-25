# Python Project Template

This project provides a minimalistic template Python project which can be used as a starter template to structure projects.

## Tooling choices:

|||
|---|---|
|project structure|src structure|
|build backend|setuptools|
|build frontend|pip|
|build tool|build|
|test|pytest|
|coverage|coverage|
|formatter|black|


## Project Setup

This will be the `README` for the project. For now, follow these instructions to get this project template set up correctly. Then, come back and replace the contents of this `README` with contents specific to your project.

## Structure
```
/
├── .gitignore
├── README.md
├── CHANGELOG.md
├── LICENSE.md
├── pyproject.toml
├── setup.cfg
├── src/
├── ├── my_package/
├──     ├── __init__.py
```

## Can evolve to this ideal structure
```
/
├── .gitignore           | git ignore file
├── pyproject.toml       | Config
├── setup.cfg            | Project configuration for dev packages
├── README.md            |
├── CHANGELOG.md         |
├── LICENSE.md           |
├── venv/                | virtual environment folder
├── src/                 | Folder for all the packages
├── ├── my_package/      |
├──     ├── __init__.py  |
├──     ├── main.py      |
├── ├── my_package2/     |
├──     ├── __init__.py  |
└── test/                | Folder for all the tests
├── ├── my_package1/     |
├── ├── ├── test_main.py |
├── ├── my_package2/     |
```

## Standard procedure that I follow

1. Create a new virtual environment for your project:

    ```shell
    python -m venv venv --prompt "Cool_Prompt"
    source .venv/bin/activate
      (or if Windows)
    .venv\Scripts\activate
    ```

2. Install project

    ```shell
    python -m pip install -e .
    ```

3. Install project with dev dependencies

    ```shell
    python -m pip install -e .[dev]
    ```

4. Build sdists and wheels

    ```shell
    python -m build
    ```
