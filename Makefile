.PHONY: venv install test-install test test-integ test-docker clean nopyc

venv: clean
	@uv --version || (echo "uv is not installed, please install uv"; exit 1);
	uv venv --clear

install: venv
	uv sync --locked --all-extras --dev --group test

test: install
	uv run coverage run -m unittest discover -s test/unit

test-integ: test
	uv run coverage run -m unittest discover -s test/integ

version ?= latest
test-docker:
	curl -s https://raw.githubusercontent.com/sendgrid/sendgrid-oai/HEAD/prism/prism.sh -o prism.sh
	version=$(version) bash ./prism.sh

clean: nopyc
	rm -rf venv

nopyc:
	find . -name \*.pyc -delete
