.DEFAULT_GOAL := help

RELEASE ?= local

.PHONY: help install uninstall airbase rollout-airbase

help: echo-version ## List commands
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install: echo-version ## Install the release
	@helm install -f values.local.yaml $(RELEASE) ./

upgrade: echo-version ## Upgrade the relase
	@helm upgrade -f values.local.yaml $(RELEASE) ./

uninstall: echo-version ## Uninstall current release
	@helm uninstall $(RELEASE)

airbase: echo-version ## Enter the runnig airbase container
	# Entering airbase...
	@kubectl exec -it `kubectl get pods --selector "app=$(RELEASE)-jet-chart-airbase" --output=name` -- sh

rollout-airbase: echo-version ## Restart Airbase
	@kubectl rollout restart deploy/$(RELEASE)-jet-chart-airbase

dryrun: echo-version
	@helm install -f values.local.yaml --dry-run $(RELEASE) ./

echo-version:
	# ReleaseName: `$(RELEASE)`
	# ----------------------
