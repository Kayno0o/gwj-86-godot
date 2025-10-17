#!/usr/bin/env bash

set -e

# Parse arguments
BUMP_TYPE="${1:-patch}"
AUTO_YES=0

# Check for -y flag
if [[ "$2" == "-y" ]] || [[ "$1" == "-y" ]]; then
  AUTO_YES=1
  if [[ "$1" == "-y" ]]; then
    BUMP_TYPE="patch"
  fi
fi

# Validate bump type
if [[ ! "$BUMP_TYPE" =~ ^(patch|minor|major)$ ]]; then
  echo "Error: Invalid bump type '$BUMP_TYPE'. Use 'patch', 'minor', or 'major'."
  exit 1
fi

# Get the current version from git tags
CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null || echo "v0.0.0")

# Remove 'v' prefix if present for semver tool
CURRENT_VERSION_CLEAN="${CURRENT_VERSION#v}"

# Handle case where there are no semver tags yet
if [[ ! "$CURRENT_VERSION_CLEAN" =~ ^[0-9]+\.[0-9]+\.[0-9]+ ]]; then
  CURRENT_VERSION_CLEAN="0.0.0"
  CURRENT_VERSION="v0.0.0"
fi

# Bump version using semver tool
NEW_VERSION_CLEAN=$(semver -i "$BUMP_TYPE" "$CURRENT_VERSION_CLEAN")
NEW_VERSION="v${NEW_VERSION_CLEAN}"

echo "Current version: ${CURRENT_VERSION}"
echo "New version: ${NEW_VERSION}"

# Confirm or auto-proceed
if [[ $AUTO_YES -eq 0 ]]; then
  echo ""
  read -p "Create and push tag ${NEW_VERSION}? (y/N) " -n 1 -r
  echo ""

  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
  fi
fi

# Create the tag
git tag -a "${NEW_VERSION}" -m "Release ${NEW_VERSION}"

# Push the tag
git push
git push --tags

echo "Successfully created and pushed tag ${NEW_VERSION}"
