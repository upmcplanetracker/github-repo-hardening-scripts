Repo Hardener
=============

_Automated security baseline enforcement for home lab repositories._

Overview
--------

This script uses the `gh` (GitHub CLI) to automatically apply branch protection rules to all repositories under an account. It prevents accidental branch deletion and force-pushes, ensuring a safe environment for solo development and automation.

The Script
----------

    #!/bin/bash
    set -euo pipefail
    
    # Get all repos (up to 1000)
    repos=$(gh repo list --limit 1000 --json nameWithOwner --jq '.[].nameWithOwner')
    
    for repo in $repos; do
        echo "--- Hardening $repo ---"
        
        default_branch=$(gh api "repos/$repo" --jq .default_branch)
        if [ -z "$default_branch" ]; then
            echo "ERROR: Could not determine default branch for $repo, skipping."
            continue
        fi
    
        if gh api -X PUT "repos/$repo/branches/$default_branch/protection" \
          --silent \
          --input - <

Usage 
-----  
*   Install GitHub CLI: `sudo apt install gh`
*   Authenticate: `gh auth login`
*   Make executable: `chmod +x harden.sh`
*   Run: `./harden.sh`
