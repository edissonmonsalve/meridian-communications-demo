#!/usr/bin/env bash
# Captures the full evidence library (screenshots + short clips) from a
# deployed, populated Scratch Org.
#
# Thin wrapper around scripts/evidence/capture-evidence.js. Requires the org
# to already be deployed and populated (run scripts/deploy-all.sh first) and
# Playwright installed (npm install --save-dev playwright && npx playwright
# install chromium -- one-time setup, not done automatically here since it's
# a real dependency addition, not something to install silently).
#
# Usage:
#   ./scripts/capture-evidence.sh [alias]

set -euo pipefail

ALIAS="${1:-meridian-demo}"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

if [ ! -d "node_modules/playwright" ]; then
  echo "Playwright isn't installed yet. One-time setup:"
  echo "    npm install --save-dev playwright"
  echo "    npx playwright install chromium"
  exit 1
fi

node scripts/evidence/capture-evidence.js --org "$ALIAS"
