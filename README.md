# Capacity Status API

## Table of Contents

- [Capacity Status API](#capacity-status-api)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
    - [Prepare Development Environment](#prepare-development-environment)
      - [Minimum setup](#minimum-setup)
      - [Full setup](#full-setup)
    - [Recommendations](#recommendations)
    - [Run the Project](#run-the-project)
    - [Ops Routine](#ops-routine)
      - [Dev Routine](#dev-routine)
        - [Pre-requisites](#pre-requisites)
        - [Configuring the development environment](#configuring-the-development-environment)
        - [Running the application in the development environment](#running-the-application-in-the-development-environment)
  - [Unit testing](#unit-testing)
    - [Creating unit tests](#creating-unit-tests)
    - [Running the unit tests](#running-the-unit-tests)
  - [Todo](#todo)

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
    open https://localhost:8443/api/v0.0.1/capacity/apidoc/
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

Install all of the modules that the application requires:

cd application
pip3 install -r requirements.txt

Your development environment is now ready.

##### Running the API in the development environment

In the development environment, the API runs in debug mode on localhost. It is possible to
have an instance of the API running on port 8000 (HTTP) or 8443 (HTTPS). The HTTPS version
of the API is dockerised and runs within a container on your local machine, while the HTTP
version runs in the command window. It is possible to have one or both versions of the API running.

Both versions of the API require a dockerised postgres database and a dockerised proxy server
to be running on your local machine. These components are included in this project.

###### Running the Dockerised API in HTTPS mode

To run the (dockerised) API on localhost across port 8443, starting from the project
root directory:

make project-build    - This builds the API, Database, and Proxy Server images.
make project-start    - This runs the API, Database, and Proxy Server images.

Issuing a 'docker ps' command will show you the state of the running containers. You should
have running containers for the API, Database, and Proxy Server.

The API will be running on localhost on port 8443. The URL to the API Documentation is:

https://localhost:8443/api/v0.0.1/capacity/apidoc

Navigate here in a browser to see all available endpoints and routes.

Any changes made and saved to the API code base will NOT cause Django to immediately re-start the API
with those new changes. Instead, the project will need to be rebuilt and re-started for any changes to
the project to be seen. In this case, it is recommended that the following commands are run within the
project root directory:

make project-clean-build    - This clears out previous images and builds new images
make project-start

###### Running the API in HTTP mode

To run the API on localhost across port 8000 (from the command prompt), starting from the
project root directory:

Follow the instructions given in the 'Running the Dockerised API in HTTPS mode' section, and
perform the following additional steps:

source $HOME/pythonvirtenvs/capacity-status-env/bin/activate     - Activate the virtual env
make api-start

The API will be running on localhost on port 8000. The URL to the API Documentation is:

http://localhost:8000/api/v0.0.1/capacity/apidoc

Navigate here in a browser to see all available endpoints and routes.

Any changes made and saved to the API code base will cause Django to immediately re-start the API
with those new changes.  However, changes made to the Database or Proxy Server will require a new
build of the images as detailed in the 'Running the Dockerised API in HTTPS mode' section.

##### Creating an authenticated user in the Development Environment

Only authenticated users can use the API endpoints. As such, an authenticated user will need to be
created. Creation of authenticated users is achieved in the APIs admin module. To access the admin
module, go to the following endpoint:

https://localhost:8443/api/v0.0.1/capacity/admin

Credentials for the administrator user in the development environment are admin/admin.

When creating an API user, there will be a field to link this user with a DoS User. The development
environment is pre-configured with a DoS user that can be used as the API user. The DoS User is 'EditCapacity'.
Once an API user has been created, you can go ahead and generate a Token for the user. This token will
need to be provided in the 'Authorization' section of all request headers.

Authorization header format:

Key:    Authorization
Value:  Token 3f26b15ee5c4723ecd91ddde5809a248c1f1a5b5

## Unit Tests

### Creating unit tests

* Ensure test files are created in a relevant sub-directory under the test directory of the app under test.
* Ensure all test files are prefixed with "test_" and match the name of the module/class that this test file tests.
* Ensure that import unittest is brought into the test file.
* Base your test class on unittest.TestCase.
* Add the new test file to the __init__.py file so that the unit test runner picks the new tests up.

### Running the unit tests

The unit tests can be run by executing the following command in the project root directory:
    ./application/manage.py test api

#### Deployment
