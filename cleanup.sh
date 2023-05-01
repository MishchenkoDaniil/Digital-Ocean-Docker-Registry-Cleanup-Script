#!/bin/bash

# Define the repositories to clean up
REPOSITORIES=(prod-api dev-api)

# Loop through the repositories
for REPO in "${REPOSITORIES[@]}"
do
  # Get a list of all tags for the repository
  TAGS=$(doctl registry repository list-tags $REPO)

  # Check if there are any tags for the repository
  if [[ -z "$TAGS" ]]; then
    echo "No tags found for $REPO"
    continue
  fi

  # Get the ID of the most recent tag
  LATEST_TAG=$(echo "$TAGS" | awk 'NR==1{print $2}')

  # Loop through the tags
  while read -r TAG; do
    # Extract the tag ID and tag name from the output
    TAG_ID=$(echo "$TAG" | awk '{print $1}')
    TAG_NAME=$(echo "$TAG" | awk '{print $2}')

    # Skip the latest tag
    if [[ "$TAG_NAME" == "$LATEST_TAG" ]]; then
      continue
    fi

    # Delete the tag
    if doctl registry repository delete-tag --force $REPO $TAG_NAME >/dev/null 2>&1; then
      echo "Deleted $REPO:$TAG_NAME"
    fi
  done <<< "$TAGS"
done

# Perform garbage collection to remove untagged images
echo "Performing garbage collection"
doctl registry garbage-collection start --include-untagged-manifests -f
