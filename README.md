Repo Hardener
=============

_Automated security baseline enforcement for home lab repositories._

Overview
--------

This script uses the `gh` (GitHub CLI) to automatically apply branch protection rules to all repositories under an account. It prevents accidental branch deletion and force-pushes, ensuring a safe environment for solo development and automation.

Usage 
-----  
*   Install GitHub CLI: `sudo apt install gh`
*   Authenticate: `gh auth login`
*   Download: 
*   Make executable: `chmod +x ./harden-github.sh`
*   Run: `./harden-github.sh`
