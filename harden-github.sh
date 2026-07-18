#!/bin/bash
set -euo pipefail

gh auth status >/dev/null 2>&1 || { echo "GitHub CLI not authenticated"; exit 1; }

success_count=0
fail_count=0

while IFS= read -r repo; do
    [[ -n "$repo" ]] || continue
    
    echo "--- Hardening $repo ---"
    
    default_branch=$(gh api "repos/$repo" --jq .default_branch 2>/dev/null || true)
    
    if [[ -z "$default_branch" ]]; then
        echo "ERROR: Could not determine default branch for $repo, skipping."
        fail_count=$((fail_count + 1))
        continue
    fi

    if gh api -X PUT "repos/$repo/branches/$default_branch/protection" \
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
        success_count=$((success_count + 1))
    else
        echo "⚠ WARNING: Failed to apply protection to $repo"
        fail_count=$((fail_count + 1))
    fi
done <<< "$(gh repo list --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner')"

echo "=========================================="
echo "Finished Hardening."
echo "Successfully protected: $success_count"
echo "Failed/Skipped: $fail_count"
echo "=========================================="
