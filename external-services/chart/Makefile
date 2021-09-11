.DEFAULT_GOAL := help

RELEASE = jet-external-services

.PHONY: help install upgrade uninstall dryrun

help: ## List commands
	@awk 'BEGIN {FS = ":.*##"; printf ""} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 }' $(MAKEFILE_LIST)

install: ## Install the release
	@helm install $(RELEASE) ./

upgrade: ## Upgrade the relase
	@helm upgrade $(RELEASE) ./

uninstall: ## Uninstall current release
	@helm uninstall $(RELEASE)

dryrun: ## dryrun
	@helm install --dry-run $(RELEASE) ./
