# TODO: This file has to be refactored
# 1) Wrap python/flake8/black/coverage commands in a Docker container
# 2) Integrate it with vscode and git
# 3) If the targets are genric enough move them to the `make-devops` repository

XARGS := xargs -0 $(shell test $$(uname) = Linux && echo -r)
GREP_T_FLAG := $(shell test $$(uname) = Linux && echo -T)
export PYFLAKES_BUILTINS=_

OMIT := */tests/*,*/migrations/*,*apps.py,*asgi.py,*wsgi.py,*manage.py,*api/settings.py

clean: # Reset the project and remove auto-generated assets
	rm -rf build
	rm -rf dist
	rm -rf .coverage
	rm -rf .eggs
	rm -rf docs/_build
	find . \( -name '*.py[co]' -o -name dropin.cache \) -delete
	find . \( -name '*.bak' -o -name dropin.cache \) -delete
	find . \( -name '*.tgz' -o -name dropin.cache \) -delete
	find . | grep -E "(__pycache__)" | xargs rm -rf

flake8: # Run the flake8 code checker
	flake8 --max-line-length=119 api

test: clean # Run the test suite
	python manage.py test api/capacityservice/ api/dos/

coverage: clean # View a report on test coverage
	coverage run --source='.' --omit=$(OMIT) manage.py test api/
	coverage report -m
	coverage erase

unit-test-coverage: clean # View a report on test coverage
	coverage run --source='.' --omit=$(OMIT) manage.py test api/ \
		--exclude-tag=regression
	coverage report -m
	coverage erase

regression-test-coverage: clean # View a report on test coverage
	coverage run --source='.' --omit=$(OMIT) manage.py test api/ \
		--tag=regression
	coverage report -m
	coverage erase

tidy: clean # Tidy code with the 'black' formatte
	@echo "\nTidying code with black..."
	black -l 119 api

check: clean tidy flake8 coverage # Run all the checkers and tests

docs: clean # Run sphinx to create project documentation
	$(MAKE) -C docs html
	@echo "\nDocumentation can be found here:"
	@echo file://`pwd`/docs/_build/html/index.html
	@echo "\n"
