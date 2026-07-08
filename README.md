Repo Hardener
=============

*Automated security baseline enforcement for home lab repositories.*

Overview
--------

This script uses the `gh` (GitHub CLI) to automatically apply branch protection rules to all repositories under an account. It prevents accidental branch deletion and force-pushes, ensuring a safe environment for solo development, automation, and repository archiving.

Usage 
-----  
1. **Install GitHub CLI:** `sudo apt install gh`
2. **Authenticate:** `gh auth login`
3. **Download & Make Executable:** `wget https://raw.githubusercontent.com/upmcplanetracker/github-repo-hardening-scripts/main/harden-github.sh && chmod +x harden-github.sh`
4. **Run:** `./harden-github.sh`
