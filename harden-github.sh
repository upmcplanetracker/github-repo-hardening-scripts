#!/bin/bash
set -euo pipefail

repos=$(gh repo list --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner')

for repo in $repos; do
    echo "--- Hardening $repo ---"
    
    default_branch=$(gh api "repos/$repo" --jq .default_branch)
    if [ -z "$default_branch" ]; then
        echo "ERROR: Could not determine default branch for $repo, skipping."
        continue
    fi
    echo "Default branch: $default_branch"

    # Using PUT to establish the baseline. GitHub requires these top-level keys.
    if gh api -X PUT "repos/$repo/branches/$default_branch/protection" \
      --silent \
      --input - <<EOF
{
  "required_status_checks": null,
  "enforce_admins": true,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_linear_history": false
}
EOF
    then
        echo "Protection applied successfully."
    else
        echo "WARNING: Failed to apply protection to $repo"
    fi
done

echo "Finished."
