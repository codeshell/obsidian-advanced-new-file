#!/bin/bash

set -euo pipefail

current_branch=$(git rev-parse --abbrev-ref HEAD)
if [[ "$current_branch" != "main" ]]; then
  echo "Error: You are not on the 'main' branch. Current branch: '$current_branch'"
  echo "Please switch to the 'main' branch to run this release."
  echo "Exiting."

  exit 1
fi

if [ "$#" -ne 2 ]; then
    echo "Must provide exactly two arguments."
    echo "First one must be the new version number."
    echo "Second one must be the minimum obsidian version for this release."
    echo ""
    echo "Example usage:"
    echo "./release.sh 0.3.0 0.11.13"
    echo "Exiting."

    exit 1
fi

if [[ $(git status --porcelain) == " M package-lock.json" ]]; then
  echo "Info: package-lock.json has unstaged changes. Will be recreated with new version and committed."
  echo "Continuing."
elif [[ $(git status --porcelain) ]]; then
  echo "Changes in the git repo."
  echo "Exiting."

  exit 1
fi

NEW_VERSION=$1
MINIMUM_OBSIDIAN_VERSION=$2

if git rev-parse "$NEW_VERSION" >/dev/null 2>&1; then
  echo "Error: Tag '$NEW_VERSION' already exists."
  echo "Exiting."

  exit 1
fi

echo "Updating to version ${NEW_VERSION} with minimum obsidian version ${MINIMUM_OBSIDIAN_VERSION}"

read -p "Continue? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Updating package.json"
  TEMP_FILE=$(mktemp)
  jq ".version |= \"${NEW_VERSION}\"" package.json > "$TEMP_FILE" || exit 1
  mv "$TEMP_FILE" package.json

  echo "Updating manifest.json"
  TEMP_FILE=$(mktemp)
  jq ".version |= \"${NEW_VERSION}\" | .minAppVersion |= \"${MINIMUM_OBSIDIAN_VERSION}\"" manifest.json > "$TEMP_FILE" || exit 1
  mv "$TEMP_FILE" manifest.json

  echo "Updating versions.json"
  TEMP_FILE=$(mktemp)
  jq ". += {\"${NEW_VERSION}\": \"${MINIMUM_OBSIDIAN_VERSION}\"}" versions.json > "$TEMP_FILE" || exit 1
  mv "$TEMP_FILE" versions.json

  echo "Running npm in case node_modules is out-of-date"
  echo "This will also update package-lock.json with the new version number, which will be committed."
  npm install

  read -p "Create git commit, tag, and push? [y/N] " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
    git add -A .
    git commit -m"Update to version ${NEW_VERSION}"
    git tag "${NEW_VERSION}"
    # git push
    # LEFTHOOK=0 git push --tags

    # echo "Remember to publish the documentation via Obsidian Publish!"
  fi

else
  echo "Exiting."
  exit 1
fi