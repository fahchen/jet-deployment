.DEFAULT_GOAL := help

RELEASE = jet-external-services

.PHONY: help install upgrade uninstall dryrun

help: ## List commands
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install: ## Install the release
	@helm install -f values.local.yaml $(RELEASE) ./

upgrade: ## Upgrade the relase
	@helm upgrade -f values.local.yaml $(RELEASE) ./

uninstall: ## Uninstall current release
	@helm uninstall -f values.local.yaml $(RELEASE)

dryrun: ## dryrun
	@helm install -f values.local.yaml --dry-run $(RELEASE) ./
