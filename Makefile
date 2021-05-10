# Set common variables
PACTICIPANT := "consumer-app"
PACT_CLI="docker run --rm -v $PWD/src/pact/:/usr/src/app/pact pactfoundation/pact-cli:latest"

all: broker consumer tests verify

# Deploy Pact Broker
broker:
	docker-compose -f pact-broker.yaml pull && \
	docker-compose -f pact-broker.yaml up -d

## Test stage
# Build consummer app
consumer:
	docker-compose build

# Run the tests
tests:
	docker-compose run --rm consumer test

# Verify the tests
verify:
	docker-compose run --rm consumer verify

# Publish Pact test files to the broker
publish:
	@"${PACT_CLI}" publish /usr/src/app/pact/ --broker-base-url=${PACT_BROKER_URL} --consumer-app-version=${GIT_COMMIT} --tag=${GIT_BRANCH}

cli_verify:
	# Optional: --provider-states-setup-url=${PROVIDER_URL}/_pact/provider_state
	@"${PACT_CLI}" verify --pact-broker-base-url=${PACT_BROKER_URL} --provider-base-url=${PROVIDER_URL} --provider=Provider --provider-app-version=${GIT_COMMIT} --publish-verification-results

pact_verifier:
	# Optional: --provider-states-setup-url=${PROVIDER_URL}/_pact/provider_state
	pact-verifier --provider-base-url=${PROVIDER_URL} --pact-broker-url=${PACT_BROKER_URL} --provider-app-version ${GIT_COMMIT} --provider=Provider --publish-verification-results

can_i_deploy:
	@"${PACT_CLI}" broker can-i-deploy --broker-base-url=${PACT_BROKER_URL} -a Provider -e ${GIT_COMMIT} --to ${GIT_BRANCH}

version_tag:
	@"${PACT_CLI}" broker create-version-tag -a Consumer -e ${GIT_COMMIT} -t ${GIT_BRANCH}

# Clean Pact Broker
clean_broker:
	docker-compose -f pact-broker.yaml down -v
