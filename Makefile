
.PHONY: patch
patch: ## Create and push a patch version tag (x.y.Z)
	@./scripts/bump-version.sh patch $(ARGS)

.PHONY: minor
minor: ## Create and push a minor version tag (x.Y.0)
	@./scripts/bump-version.sh minor $(ARGS)

.PHONY: major
major: ## Create and push a major version tag (X.0.0)
	@./scripts/bump-version.sh major $(ARGS)
