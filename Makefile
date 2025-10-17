
.PHONY: patch
patch: ## Create and push a patch version tag (x.y.Z)
	@./bump.sh patch $(ARGS)

.PHONY: minor
minor: ## Create and push a minor version tag (x.Y.0)
	@./bump.sh minor $(ARGS)

.PHONY: major
major: ## Create and push a major version tag (X.0.0)
	@./bump.sh major $(ARGS)
