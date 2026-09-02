#!/usr/bin/env bash
# Run this in Ubuntu/WSL after: wsl --install (admin PowerShell), reboot, open Ubuntu.
set -euo pipefail

PROJECT_DIR="/mnt/c/Users/artis/OneDrive/Documents/allie-ugc-portfolio"
REPO_NAME="allie-ugc-portfolio"

cd "$PROJECT_DIR"

if ! command -v origin >/dev/null 2>&1; then
  curl -fsSL https://downloads.cursor.com/origin/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
fi

if ! origin auth status 2>/dev/null | grep -qi "logged in\|authenticated\|session"; then
  origin auth login
fi

if git remote get-url origin >/dev/null 2>&1; then
  echo "Remote 'origin' already set:"
  git remote -v
else
  origin repo create "$REPO_NAME"
  git remote add origin "https://origin.cursor.com/$(origin auth status 2>/dev/null | sed -n 's/.*namespace: //p' | head -1)/${REPO_NAME}.git" 2>/dev/null || true
  echo ""
  echo "If remote was not added automatically, run:"
  echo "  git remote add origin https://origin.cursor.com/YOUR-NAMESPACE/${REPO_NAME}.git"
  echo "(Use the clone URL from: origin repo create output or cursor.com/codebase)"
fi

git push -u origin main

echo ""
echo "Done. Open: https://cursor.com/codebase"
