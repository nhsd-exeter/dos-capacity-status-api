PYTHON_VERSION = 3.8.2
PYTHON_PACKAGES = \
	flake8 \
	mypy \
	pylint

python-virtualenv: ### Setup Python virtual environment - optional: PYTHON_VERSION
	pyenv install --skip-existing $(PYTHON_VERSION)
	pyenv virtualenv --force $(PYTHON_VERSION) $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME)
	pyenv local $(PROJECT_GROUP_SHORT)-$(PROJECT_NAME)
	pip install --upgrade pip
	pip install $(PYTHON_PACKAGES)

python-virtualenv-clean: ### Clean up Python virtual environment - optional: PYTHON_VERSION
	rm -rf \
		.python-version \
		~/.pyenv/versions/$(PYTHON_VERSION)/envs/$(PROJECT_GROUP_SHORT)-$(PROJECT_NAME)
