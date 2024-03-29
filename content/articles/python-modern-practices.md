+++
title = "Modern Good Practices for Python Development"
slug = "python-modern-practices"
date = "2024-02-03T14:02:00+00:00"
description = "Good development practices for modern Python"
categories = ["programming", "python"]
tags = ["python"]

+++

[Python](https://www.python.org/) has a long history, and it has evolved over time. This article describes some agreed modern best practices.

## Using Python

### Use The Most Recent Version of Python That You Can

Use the most recent stable version of Python 3. This ensures that you have the latest security fixes, as well as the fastest performance. If your operating system includes an older version of Python, you can use tools like [asdf](https://asdf-vm.com), [pyenv](https://github.com/pyenv/pyenv) or [Homebrew](https://brew.sh/) to install a separate copy of Python.

If you need to use an older version of Python for compatibility, check that you are using the most recent version that you can. The Python development team usually support each version for five years, but some Python libraries may only support each version of Python for a shorter period of time.

Avoid using Python 2. It is not supported by the Python development team. The current versions of many libraries are not compatible with Python 2.

### Use pipx To Install Python Applications

Always use [pipx](https://github.com/pypa/pipx) to install Python applications, rather than _pip_. This ensures that each application has the correct libraries. Unlike _pip_, _pipx_ automatically installs the libraries for each application into a separate [Python virtual environment](https://docs.python.org/3/tutorial/venv.html).

The Python Packaging Authority maintain _pipx_, but it is not included with Python. You can install _pipx_ with Homebrew on macOS, or with your system package manager on Linux.

> [PEP 668 - Marking Python base environments as “externally managed”](https://peps.python.org/pep-0668/#guide-users-towards-virtual-environments) recommends that users install Python applications with pipx.

## Developing Python Projects

### Use a pyproject.toml File

Create a _pyproject.toml_ file in the root directory of each Python project. Use this file as the central place to store configuration information about the project and the tools that it uses. The [pyOpenSci project documentation on pyproject.toml](https://www.pyopensci.org/python-package-guide/package-structure-code/pyproject-toml-python-package-metadata.html) provides an introduction to the file format.

Modern Python tools support _pyproject.toml_ files. Python project management tools like [Hatch](https://hatch.pypa.io) or
[Poetry](https://python-poetry.org/) automatically create and use a _pyproject.toml_ file. If you use a tool that supports another configuration file by default, use a _pyproject.toml_ file instead.

> The various features of _pyproject.toml_ files are defined these PEPs: [PEP 517](https://peps.python.org/pep-0517/), [PEP 518](https://peps.python.org/pep-0518/), [PEP 621](https://peps.python.org/pep-0621/) and [PEP 660](https://peps.python.org/pep-0660/).

### Create a Directory Structure That Uses the src Layout

Python itself does not require a specific directory structure for your projects. The Python packaging documentation describes two popular directory structures: [the src layout and the flat layout](https://packaging.python.org/en/latest/discussions/src-layout-vs-flat-layout/). For modern Python projects, use the src layout. The [pyOpenSci project documentation on directory structures](https://www.pyopensci.org/python-package-guide/package-structure-code/python-package-structure.html) explains the differences between the two.

Current versions of the [Hatch](https://hatch.pypa.io) tool create a src layout for new projects.

### Use Virtual Environments for Development

The [virtual environments](https://docs.python.org/3/tutorial/venv.html) feature enables you to define separate sets of packages for each Python project, so that the packages for a project do not conflict with any other Python packages on the system. Always use Python virtual environments for your projects.

If you use a tool like [Hatch](https://hatch.pypa.io) or
[Poetry](https://python-poetry.org/) to develop your projects it will manage Python virtual environments for you.

If you prefer, you can also manually set up and manage virtual environments with _venv_, which is part of the Python standard library.

### Use Package Lists with Hashes

Avoid installing individual packages with _pip_. Use a tool to create package lists with hashes for each package, and then run _pip_ or another tool to install and update the packages in a virtual environment.

_pip_ and other tools use _requirements.txt_ files to list the packages to be installed into an environment. The _requirements.txt_ file format supports hashes.

To work with _requirements.txt_ files, use the [pip-tools](https://github.com/jazzband/pip-tools/). The _pip-compile_ utility generates _requirements.txt_ files with hashes from _requirements.in_ files, and the _pip-sync_ utility ensures that the packages in a virtual environment match the list in the _requirements.txt_ file.

If you need to install packages without using _pip-sync_, run _pip install_ with a _requirements.txt_ file. For example, these commands installs the packages specified by the file _requirements-dev.txt_ into the virtual environment _.venv_:

```shell
source ./.venv/bin/activate
python3 -m pip install -r requirements-dev.txt 
```

### Format Your Code

Use a formatting tool with a plugin to your editor, so that your code is automatically formatted to a consistent style.

[Black](https://black.readthedocs.io/en/stable/) is currently the most popular code formatting tool for Python, but consider using [Ruff](https://docs.astral.sh/ruff/). Ruff provides both code formatting and quality checks for Python code.

Run the formatting tool with your CI system, to reject code that does not match the format for your project.

### Use a Code Linter

Use a code linting tool with a plugin to your editor, so that your code is automatically checked for issues.

[flake8](https://flake8.pycqa.org/en/latest/) is currently the most popular linter for Python, but consider using [Ruff](https://docs.astral.sh/ruff/). Ruff includes the features of both flake8 itself and the most popular plugins for flake8.

Run the linting tool with your CI system, to reject code that does not meet the standards for your project.

### Test with pytest

Use [pytest](http://pytest.org) for testing. It has superseded _nose_ as the most popular testing system for Python. Use the _unittest_ module in the standard library for situations where you cannot add _pytest_ to the project.

## Language Syntax

### Use Type Hinting

Current versions of Python support type hinting. Consider using type hints in any critical application. If you develop a shared library, use type hints.

Once you add type hints, [Mypy](http://www.mypy-lang.org/) tool can check your code as you develop it. Code editors can also read type hints to display information about the code that you are working with.

If you add [Pydantic](https://docs.pydantic.dev/) to your software, it uses type hints in your software to validate data as an application runs.

> [PEP 484 - Type Hints](https://peps.python.org/pep-0484/) and [PEP 526 – Syntax for Variable Annotations](https://peps.python.org/pep-0526/) define the notation for type hinting.

### Format Strings with f-strings

The new [f-string](https://docs.python.org/3/reference/lexical_analysis.html#f-strings) syntax is both more readable and has better performance than older methods. Use f-strings instead of _%_ formatting, _str.format()_ or _str.Template()_.

The older features for formatting strings will not be removed, to avoid breaking backward compatibility.

The f-strings feature was added in version 3.6 of Python. Alternate implementations of Python may include this specific feature, even when they do not support version 3.6 syntax.

> [PEP 498](https://www.python.org/dev/peps/pep-0498/) explains f-strings in detail.

### Use Datetime Objects with Time Zones

Always use _datetime_ objects that are [aware](https://docs.python.org/3/library/datetime.html?highlight=datetime#aware-and-naive-objects) of time zones. By default, Python creates _datetime_ objects that do not include a time zone. The documentation refers to _datetime_ objects without a time zone as **naive**.

Avoid using _date_ objects, except where the time of day is completely irrelevant. The _date_ objects are always **naive**, and do not include a time zone.

Use aware _datetime_ objects with the UTC time zone for timestamps, logs and other internal features.

To get the current time and date in UTC as an aware _datetime_ object, specify the UTC time zone with _now()_. For example:

```python
from datetime import datetime, timezone

dt = datetime.now(timezone.utc)
```

Python 3.9 and above include the **zoneinfo** module. This provides access to the standard IANA database of time zones. Previous versions of Python require a third-party library for time zones.

> [PEP 615](https://www.python.org/dev/peps/pep-0615/) describes support for the IANA time zone database with **zoneinfo**.

### Use enum or Named Tuples for Immutable Sets of Key-Value Pairs

Use the _enum_ type in Python 3.4 or above for immutable collections of key-value pairs. Enums can use class inheritance.

Python 3 also has _collections.namedtuple()_ for immutable key-value pairs. Named tuples do not use classes.

### Create Data Classes for Custom Data Objects

The data classes feature enables you to reduce the amount of code that you need to define classes for objects that exist to store values. The new syntax for data classes does not affect the behavior of the classes that you define with it. Each data class is a standard Python class.

You can set a _frozen_ option to make [frozen instances](https://docs.python.org/3/library/dataclasses.html#frozen-instances) of a data class.

Data classes were introduced in version 3.7 of Python.

> [PEP 557](https://www.python.org/dev/peps/pep-0557/) describes data classes.

### Use collections.abc for Custom Collection Types

The abstract base classes in _collections.abc_ provide the components for building your own custom collection types.

Use these classes, because they are fast and well-tested. The implementations in Python 3.7 and above are written in C, to provide better performance than Python code.

### Use breakpoint() for Debugging

This function drops you into the debugger at the point where it is called. Both the [built-in debugger](https://docs.python.org/3/library/pdb.html) and external debuggers can use these breakpoints.

The [breakpoint()](https://docs.python.org/3/library/functions.html#breakpoint) feature was added in version 3.7 of Python.

> [PEP 553](https://www.python.org/dev/peps/pep-0553/) describes the _breakpoint()_ function.

## Application Design

### Use Logging for Diagnostic Messages, Rather Than print()

The built-in _print()_ statement is convenient for adding debugging information, but you should include logging in your scripts and applications. Use the [logging](https://docs.python.org/3/library/logging.html#logrecord-attributes) module in the standard library, or a third-party logging module.

### Use The TOML Format for Configuration

Use [TOML](https://toml.io/) for data files that must be written or edited by human beings. Use the JSON format for data that is transferred between computer programs. Avoid using the INI or YAML formats.

Python 3.11 and above include _tomllib_ to read the TOML format. Use [tomli](https://pypi.org/project/tomli/) to add support for reading TOML to applications that run on older versions of Python.

If your Python software needs to generate TOML, add [Tomli-W](https://pypi.org/project/tomli-w/).

> [PEP 680 - tomllib: Support for Parsing TOML in the Standard Library](https://peps.python.org/pep-0680/) explains why TOML is now included with Python.

### Only Use async Where It Makes Sense

The [asynchronous features of Python](https://docs.python.org/3/library/asyncio.html) enable a single process to avoid blocking on I/O operations. To achieve concurrency with Python, you must run multiple Python processes. Each of these processes may or may not use asynchronous I/O.

To run multiple application processes, either use an application server like [Gunicorn](https://gunicorn.org/) or use a container system, with one container per process. If you need to build a custom application that manages muliple processes, use the [multiprocessing](https://docs.python.org/3/library/multiprocessing.html) package in the Python standard library.

Code that uses asynchronous I/O must not call _any_ function that uses synchronous I/O, such as _open()_, or the _logging_ module in the standard library. Instead, you need to use either the equivalent functions from _asyncio_ in the standard library or a third-party library that is designed to support asynchronous code.

The [FastAPI](https://fastapi.tiangolo.com/) Web framework supports [using both synchronous and asynchronous functions in the same application](https://fastapi.tiangolo.com/async/). You must still ensure that asynchronous functions never call any synchronous function.

If you would like to work with _asyncio_, use Python 3.7 or above. Version 3.7 of Python introduced [context variables](https://docs.python.org/3/library/contextvars.html), which enable you to have data that is local to a specific _task_, as well as the _asyncio.run()_ function.

> [PEP 0567](https://www.python.org/dev/peps/pep-0567/) describes context variables.

## Libraries

### Handle Command-line Input with argparse

The [argparse](https://docs.python.org/3/library/argparse.html) module is now the recommended way to process command-line input. Use _argparse_, rather than the older _optparse_ and _getopt_.

The _optparse_ module is officially deprecated, so update code that uses _optparse_ to use _argparse_ instead.

Refer to [the argparse tutorial](https://docs.python.org/3/howto/argparse.html) in the official documentation for more details.

### Use pathlib for File and Directory Paths

Use [pathlib](https://docs.python.org/3/library/pathlib.html) objects instead of strings whenever you need to work with file and directory pathnames.

Consider using the [the pathlib equivalents for os functions](https://docs.python.org/3/library/pathlib.html#correspondence-to-tools-in-the-os-module).

The existing methods in the standard library have been updated to support Path objects.

To list all of the the files in a directory, use either the _.iterdir()_ function of a Path object, or the _os.scandir()_ function.

This [RealPython article](https://realpython.com/working-with-files-in-python/#directory-listing-in-modern-python-versions) provides a full explanation of the different Python functions for working with files and directories.

The _pathlib_ module was added to the standard library in Python 3.4, and other standard library functions were updated to support Path objects in version 3.5 of Python.

### Use os.scandir() Instead of os.listdir()

The _os.scandir()_ function is significantly faster and more efficient than _os.listdir()_. Use _os.scandir()_ wherever you previously used the _os.listdir()_ function.

This function provides an iterator, and works with a context manager:

```python
import os

with os.scandir('some_directory/') as entries:
    for entry in entries:
        print(entry.name)
```

The context manager frees resources as soon as the function completes. Use this option if you are concerned about performance or concurrency.

The _os.walk()_ function now calls _os.scandir()_, so it automatically has the same improved performance as this function.

The _os.scandir()_ function was added in version 3.5 of Python.

> [PEP 471](https://www.python.org/dev/peps/pep-0471/) explains _os.scandir()_.

### Run External Commands with subprocess

The [subprocess](https://docs.python.org/3/library/subprocess.html) module provides a safe way to run external commands. Use _subprocess_ rather than shell backquoting or the functions in _os_, such as _spawn_, _popen2_ and _popen3_. The _subprocess.run()_ function in current versions of Python is sufficient for most cases.

> [PEP 324](https://www.python.org/dev/peps/pep-0324/) explains the technical details of subprocess in detail.

### Use httpx for Web Clients

Use [httpx](https://www.python-httpx.org/) for Web client applications. It [supports HTTP/2](https://www.python-httpx.org/http2/), and [async](https://www.python-httpx.org/async/). The httpx package supersedes [requests](https://requests.readthedocs.io/en/latest/), which only supports HTTP 1.1.

Avoid using _urllib.request_ from the Python standard library. It was designed as a low-level library, and lacks the features of httpx.
