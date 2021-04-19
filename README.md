# DoS Capacity Status API

## Table of Contents

- [DoS Capacity Status API](#dos-capacity-status-api)
  - [Table of Contents](#table-of-contents)
  - [Quick Start](#quick-start)
    - [Development Requirements](#development-requirements)
    - [Local Environment Configuration](#local-environment-configuration)
    - [Local Project Setup](#local-project-setup)
  - [To Be Refactored...](#to-be-refactored)
    - [Dev Routine](#dev-routine)
      - [Pre-requisites](#pre-requisites)
      - [Configuring the development environment](#configuring-the-development-environment)
      - [Running the API in the development environment](#running-the-api-in-the-development-environment)
        - [Running the Dockerised API in HTTPS mode](#running-the-dockerised-api-in-https-mode)
        - [Running the API in HTTP mode](#running-the-api-in-http-mode)
      - [Creating an authenticated user in the Development Environment](#creating-an-authenticated-user-in-the-development-environment)
    - [Testing](#testing)
      - [Creating unit tests](#creating-unit-tests)
      - [Creating Regression tests](#creating-regression-tests)
      - [Running the unit tests from command line](#running-the-unit-tests-from-command-line)
      - [Running the unit tests from Make](#running-the-unit-tests-from-make)
    - [Deployment](#deployment)
      - [To provision the infrastructure](#to-provision-the-infrastructure)
    - [Pipeline Strategy](#pipeline-strategy)

## Quick Start

### Development Requirements

- macOS operating system provisioned with the `curl -L bit.ly/make-devops-macos | bash` command
- `iTerm2` command-line terminal and `Visual Studio Code` source code editor, which will be installed automatically for you in the next steps
- Before starting any work, please read [CONTRIBUTING.md](build/automation/lib/project/template/CONTRIBUTING.md)

### Local Environment Configuration

Clone the repository

    git clone https://github.com/nhsd-exeter/dos-capacity-status-api.git
    cd ./dos-capacity-status-api

This is an equivalent to the `curl -L bit.ly/make-devops-macos | bash` command

    make macos-setup

Please, ask one of your colleagues for the AWS account numbers used by the project. The next command will prompt you to provide them. This information can be sourced from a properly set up project by running `make show-configuration | grep ^AWS_ACCOUNT_ID_`

    make devops-setup-aws-accounts

Generate and trust a self-signed certificate that will be used locally to enable encryption in transit

    make trust-certificate

### Local Project Setup

    make build
    make start log # Press Ctrl-C to exit
    open https://cs.local:443/api/v0.0.1/capacity/apidoc/
    open https://cs.local:443/api/v0.0.1/capacity/admin/login/ # admin/admin
    make stop

## To Be Refactored...

### Dev Routine

#### Pre-requisites

You'll need to have the following installed:
Python version 3.7.5
Pip version 19.3.1

#### Configuring the development environment

To run the application locally, you'll first need to create a python virtual
environment that has all of the relevant python modules and extensions that
the application requires.

To create a virtual environment for application run:
    make python-virtualenv

To remove the virtual environment for this application run:
    make python-virtualenv-clean

#### Running the API in the development environment

In the development environment, the API runs in debug mode on localhost. It is possible to
have an instance of the API running on port 8000 (HTTP) or 8443 (HTTPS). The HTTPS version
of the API is dockerised and runs within a container on your local machine, while the HTTP
version runs in the command window. It is possible to have one or both versions of the API running.

Both versions of the API require a dockerised postgres database and a dockerised proxy server
to be running on your local machine. These components are included in this project.

##### Running the Dockerised API in HTTPS mode

To run the (dockerised) API on localhost across port 8443, starting from the project
root directory:

    make build
This builds the API, Database, and Proxy Server images.

    make start
This runs the API, Database, and Proxy Server images.

Issuing a 'docker ps' command will show you the state of the running containers. You should
have running containers for the API, Database, and Proxy Server.

The API will be running on localhost on port 8443. The URL to the API Documentation is:

https://localhost:8443/api/v0.0.1/capacity/apidoc

Navigate here in a browser to see all available endpoints and routes.

Any changes made and saved to the API code base will NOT cause Django to immediately re-start the API
with those new changes. Instead, the project will need to be rebuilt and re-started for any changes to
the project to be seen. In this case, it is recommended that the following commands are run within the
project root directory:

    make stop clean build
This clears out previous images and builds new images

    make start
Then this will restart the application (the api Django container and the proxy container)

When running through the proxy in development the statics won't load currently unless you turn debug
on in the Django settings `application/api/settings.py`

    DEBUG = os.getenv("API_DEBUG", True)

##### Running the API in HTTP mode

To run the API on localhost across port 8080 (from the command prompt), starting from the
project root directory:

  Run the following make targets:

    make dev-setup
  Setup is only needed if you haven't run `make pythonvirtualenv`

    make dev-build
    make dev-db-start
    make dev-migrate
    make dev-start

The API will be running on localhost on port 8080. The URL to the API Documentation is:

http://localhost:8080/api/v0.0.1/capacity/apidoc

Navigate here in a browser to see all available endpoints and routes.

Any changes made and saved to the API code base will cause Django to immediately re-start the API
with those new changes. However, changes made to the Database or Proxy Server will require a new
build of the images as detailed in the 'Running the Dockerised API in HTTPS mode' section.

Stop and clear out the application using

    make stop clean

#### Creating an authenticated user in the Development Environment

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

Key: Authorization
Value: Token 3f26b15ee5c4723ecd91ddde5809a248c1f1a5b5

### Testing

#### Creating unit tests

- Ensure test files are created in a relevant sub-directory under the test directory of the app under test.
- Ensure all test files are prefixed with "test\_" and match the name of the module/class that this test file tests.
- Ensure that import unittest is brought into the test file.
- Base your test class on unittest.TestCase.
- Add the new test file to the `__init__.py` file so that the unit test runner picks the new tests up.

#### Creating Regression tests

- Following instructions for unit test but create under the `application/api/service/tests/test_regression` folder

#### Running the unit tests from command line

The unit and regression tests can be run by executing the following command in the project root directory:

    ./application/manage.py test api

To only run the unit tests:

    ./application/manage.py test  --exclude-tag=regression api

To only run the regression tests:

    ./application/manage.py test --tag=regression api

#### Running the unit tests from Make

The entire test suite of the API can be run by issuing the following command in the root directory of the
project (this run all the unit test and regression tests):

    make test

To only run the unit tests:

    make test-unit-only

To only run regression tests:

    make test-regression-only

To just run the test for a particular django app use the following:

    make test-service
    make test-dos-interface
    make test-authentication

### Deployment

Deployment of the API service is achieved by running the following make commands in the
root directory of the project.

Deploy current built images from the AWS ECR to the development env

    make deploy PROFILE=dev

Deploy newly build images to the development environment

    make PROFILE=dev \
      clean \
      build \
      push \
      deploy

The `PROFILE` variable can be set to other environments.

#### To provision the infrastructure

To provision the infrastructure use the following command:

    make terraform-apply STACKS=service PROFILE=${PROFILE} OPTS='--var-file=../tfvars/${PROFILE}.tfvars

Where `${PROFILE}` is the the environment your looking to deploy to e.g. `dev`, `demo`, or `prod`

### Pipeline Strategy

This project is comprised of two pipelines a **Commit Pipeline** and a **Deploy Pipeline**

The **Commit Pipeline** builds the project docker images after a commit to the master branch and push
them to the texas registry. The images are also tag with the commit hash they are associated with and
a timestamp when they were built. The two images it creates are the api image (the Django application)
and the proxy image (an NGINX server). It also test the images against the unit and regression tests.

The commit pipeline is comprise of the following stages :

  - Setup Variables
  - Start up Test Database
  - Build Images
  - Run Tests
  - Push Images

The **Deploy Pipeline** based on a given git tag provisions infrastructure and deploys the application
to a give environment. The tag suffix determines the environment the application will be deployed to,
with suffix being the `PROFILE` name from the deployment. If no suffix is present on a git tag it will
instead be deployed as a dev `PROFILE` and will also load test data for a DoS database to the created
RDS instance.

The deploy pipeline is comprise of the following stages :

- Setup Variables
- Check if OK to Deploy
- Backup Data
- Provision Infrastructure
- Deploy Application
- Load Test Data
- Deployment Summary

The pipelines can be found on UEC's Jenkins MoM server under the DoS API tab
