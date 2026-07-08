#!/bin/bash
set -euo pipefail

echo "Fetching repositories..."
repos=$(gh repo list --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner')

success_count=0
fail_count=0

for repo in $repos; do
    echo "--- Hardening $repo ---"
    
    default_branch=$(gh api "repos/$repo" --jq .default_branch 2>/dev/null || echo "")
    
    if [ -z "$default_branch" ]; then
        echo "ERROR: Could not determine default branch for $repo, skipping."
        ((fail_count++))
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
        echo "✓ Protection applied successfully."
        ((success_count++))
    else
        echo "⚠ WARNING: Failed to apply protection to $repo"
        ((fail_count++))
    fi
done

echo "=========================================="
echo "Finished Hardening."
echo "Successfully protected: $success_count"
echo "Failed/Skipped: $fail_count"
echo "=========================================="
