# Capacity Status API

## Table of Contents

* [Table of Contents](#table-of-contents)
* [Quick Start](#quick-start)
  * [Prepare Development Environment](#prepare-development-environment)
    * [Minimum setup](#minimum-setup)
    * [Full setup](#full-setup)
  * [Recommendations](#recommendations)
  * [Run the Project](#run-the-project)
    * [Dev Routine](#dev-routine)
    * [Ops Routine](#ops-routine)
* [Todo](#todo)

## Quick Start

### Prepare Development Environment

#### Minimum setup

    brew install make
    export PATH=/usr/local/opt/make/libexec/gnubin:$PATH
    cd capacity-status-api
    make dev-install-essential

#### Full setup

    cd capacity-status-api
    make dev-setup

### Recommendations

* Use iTerm2 and Visual Studio Code for development
* Before starting any work, please read [CONTRIBUTING.md](CONTRIBUTING.md)

### Run the Project

### Ops Routine

    cd capacity-status-api
    make project-trust-certificate
    make project-build
    make project-start project-log # Press Ctrl-C to exit
    open https://localhost:8443/apidoc/
    make project-stop

#### Dev Routine

##### Pre-requisites

You'll need to have the following installed:
    Python version 3.7.5
    Pip version 19.3.1

##### Configuring the development environment

To run the application locally, you'll first need to create a python virtual
environment that has all of the relevant python modules and extensions that
the application requires.

First, create a python virtual environment as follows:

sudo pip3 install virtualenv
virtualenv $HOME/pythonvirtenvs/capacity-status-env

Activate the virtual environment:

source $HOME/pythonvirtenvs/capacity-status-env/bin/activate

Now install all of the extensions & load the static server files:

First, navigate to the root directory and run the following command:

make api-build

##### Running the application

In the development environment, the application runs in debug mode.

To run the application, make sure that you have your python virtual environment
activated:

source $HOME/pythonvirtenvs/capacity-status-env/bin/activate

Now run the following to start the application in the root directory of the
project:

make api-start

The application is configured to run on https://localhost:8443/apidoc/

Navigate here in a browser to see all available endpoints and routes.

## Unit testing

### Creating unit tests

* Ensure test files are created in a relevant sub-directory under the test directory of the app under test.
* Ensure all test files are prefixed with "test_" and match the name of the module/class that this test file tests.
* Ensure that import unittest is brought into the test file.
* Base your test class on unittest.TestCase.
* Add the new test file to the __init__.py file so that the unit test runner picks the new tests up.

### Running the unit tests

The unit tests can be run by executing the following command:
    ./manage.py test app

## Todo

* The `api` image weights more than 300MB. Can we drop the build dependencies but still keep `pg_config` binary?
* Fix the packages versions in the `application/requirements.txt` or do `pip freeze > requirements-lock.txt`
