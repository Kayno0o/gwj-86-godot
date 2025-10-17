.PHONY: major minor patch

patch:
	bun version patch && git push --follow-tags

minor:
	bun version minor && git push --follow-tags

major:
	bun version major && git push --follow-tags
