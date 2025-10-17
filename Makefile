.PHONY: major minor patch

patch:
	bun pm version patch && git push --follow-tags

minor:
	bun pm version minor && git push --follow-tags

major:
	bun pm version major && git push --follow-tags
