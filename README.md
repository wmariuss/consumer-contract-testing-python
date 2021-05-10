# Client App

This is a python application (Consumer) for explanation of Contract Testing based on [Pact](https://docs.pact.io/).

## Requirements

* `docker >= 20.10.5`
* `docker-compose >= 1.28.5`
* `.env` file

## Installing

* Consumer App: `make consumer`
* Deploy Broker: `make broker`

### Usage

* Copy `env.template` in `.env` and add your values
* Run the tests (generating Pact test file(s)): `make tests`
* Publish Pact test file(s): `make publish`
* Verify Pact test file(s) with `pact_cli` command: `make cli_verify`
* Check if is safe to deploy new version of the app: `make can_i_deploy`
* Create a new tag/version: `make version_tag`
* Clean Pact Broker: `make clean_broker`

An example of Pact test file can be found in [src/pact/](src/pact/) path.
