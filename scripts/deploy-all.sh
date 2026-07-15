#!/usr/bin/env bash
# One-command rebuild of the Meridian Communications demo org from scratch.
#
# The single documented procedure for recreating this entire project on a
# clean Scratch Org: create the org, deploy all metadata, load fictitious
# data, create sample users, and open it. Every step after Dev Hub
# connection is unattended.
#
# This script does NOT connect a Dev Hub -- that's a one-time interactive
# browser login only a human can complete (see PORTFOLIO/deployment/README.md
# step 1). Run that once, then this script any number of times afterward.
#
# Usage:
#   ./scripts/deploy-all.sh [alias] [duration_days]
#   ./scripts/deploy-all.sh meridian-demo 30
#   SKIP_DATA=1 SKIP_USERS=1 ./scripts/deploy-all.sh meridian-ci 1

set -euo pipefail

ALIAS="${1:-meridian-demo}"
DURATION_DAYS="${2:-30}"
SKIP_DATA="${SKIP_DATA:-0}"
SKIP_USERS="${SKIP_USERS:-0}"

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

step() { echo ""; echo "==> $1"; }

# --- 0. Preconditions -------------------------------------------------
step "Checking prerequisites"

if ! command -v sf >/dev/null 2>&1; then
  echo "Salesforce CLI ('sf') not found on PATH. Install it first: https://developer.salesforce.com/tools/salesforcecli" >&2
  exit 1
fi

# NOTE: `sf config get <key> --json` does not include a "value" field in its
# result entries in this CLI version -- confirmed empirically. `sf config
# list --json` does, so that's what this filters instead.
DEV_HUB="$(sf config list --json 2>/dev/null | node -e 'let d="";process.stdin.on("data",c=>d+=c);process.stdin.on("end",()=>{try{const r=JSON.parse(d).result||[];const hub=r.find(e=>e.key==="target-dev-hub");console.log((hub&&hub.value)||"")}catch(e){console.log("")}})' 2>/dev/null || true)"

if [ -z "$DEV_HUB" ]; then
  echo ""
  echo "No Dev Hub is connected. This is the one step this script cannot do for you"
  echo "-- it's an interactive browser login. Run this once, then re-run this script:"
  echo ""
  echo "    sf org login web --set-default-dev-hub --alias MeridianDevHub"
  echo ""
  exit 1
fi
echo "Dev Hub connected: $DEV_HUB"

# --- 1. Scratch org -----------------------------------------------------
step "Creating Scratch Org '$ALIAS' ($DURATION_DAYS days)"
sf org create scratch --definition-file config/project-scratch-def.json --alias "$ALIAS" --duration-days "$DURATION_DAYS" --set-default --wait 10

# --- 2. Deploy metadata ---------------------------------------------------
step "Deploying metadata"
sf project deploy start --target-org "$ALIAS" --wait 30

# --- 3. Fictitious data ---------------------------------------------------
if [ "$SKIP_DATA" != "1" ]; then
  step "Loading fictitious data"
  sf apex run --file scripts/apex/generate-fictitious-data.apex --target-org "$ALIAS"
else
  echo "Skipping data load (SKIP_DATA=1)"
fi

# --- 4. Sample users -------------------------------------------------------
if [ "$SKIP_USERS" != "1" ]; then
  step "Creating sample users"
  sf apex run --file scripts/apex/create-sample-users.apex --target-org "$ALIAS"
else
  echo "Skipping sample users (SKIP_USERS=1)"
fi

# --- 5. Done ---------------------------------------------------------------
step "Done"
echo "Org '$ALIAS' is deployed and populated."
echo "Next: sf org open --target-org $ALIAS"
echo "Then: follow PORTFOLIO/screenshots/README.md to capture evidence,"
echo "  or run scripts/capture-evidence.sh to automate it."
