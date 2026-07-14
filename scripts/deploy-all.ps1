<#
.SYNOPSIS
    One-command rebuild of the Meridian Communications demo org from scratch.

.DESCRIPTION
    The single documented procedure for recreating this entire project on a
    clean Scratch Org: create the org, deploy all metadata, load fictitious
    data, create sample users, and open it. Every step after Dev Hub
    connection is unattended.

    This script does NOT connect a Dev Hub — that's a one-time interactive
    browser login only a human can complete (see PORTFOLIO/deployment/README.md
    step 1). Run that once, then this script any number of times afterward.

.PARAMETER Alias
    Scratch org alias. Default: meridian-demo

.PARAMETER DurationDays
    How many days the scratch org should live before auto-expiring. Default: 30

.PARAMETER SkipData
    Skip fictitious data generation (metadata deploy only).

.PARAMETER SkipUsers
    Skip sample user creation.

.EXAMPLE
    .\scripts\deploy-all.ps1

.EXAMPLE
    .\scripts\deploy-all.ps1 -Alias meridian-ci -DurationDays 1 -SkipUsers
#>

param(
    [string]$Alias = "meridian-demo",
    [int]$DurationDays = 30,
    [switch]$SkipData,
    [switch]$SkipUsers
)

$ErrorActionPreference = "Stop"
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Assert-LastExitCode {
    param([string]$Context)
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAILED: $Context (exit code $LASTEXITCODE)" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

# --- 0. Preconditions -------------------------------------------------
Write-Step "Checking prerequisites"

if (-not (Get-Command sf -ErrorAction SilentlyContinue)) {
    Write-Host "Salesforce CLI ('sf') not found on PATH. Install it first: https://developer.salesforce.com/tools/salesforcecli" -ForegroundColor Red
    exit 1
}

$devHub = (sf config get target-dev-hub --json 2>$null | ConvertFrom-Json).result.value
if (-not $devHub) {
    Write-Host ""
    Write-Host "No Dev Hub is connected. This is the one step this script cannot do for you" -ForegroundColor Yellow
    Write-Host "-- it's an interactive browser login. Run this once, then re-run this script:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "    sf org login web --set-default-dev-hub --alias MeridianDevHub" -ForegroundColor White
    Write-Host ""
    exit 1
}
Write-Host "Dev Hub connected: $devHub" -ForegroundColor Green

# --- 1. Scratch org -----------------------------------------------------
Write-Step "Creating Scratch Org '$Alias' ($DurationDays days)"
sf org create scratch --definition-file config/project-scratch-def.json --alias $Alias --duration-days $DurationDays --set-default --wait 10
Assert-LastExitCode "org create scratch"

# --- 2. Deploy metadata ---------------------------------------------------
Write-Step "Deploying metadata"
sf project deploy start --target-org $Alias --wait 30
Assert-LastExitCode "project deploy start"

# --- 3. Fictitious data ---------------------------------------------------
if (-not $SkipData) {
    Write-Step "Loading fictitious data"
    sf apex run --file scripts/apex/generate-fictitious-data.apex --target-org $Alias
    Assert-LastExitCode "generate-fictitious-data.apex"
} else {
    Write-Host "Skipping data load (-SkipData)" -ForegroundColor Yellow
}

# --- 4. Sample users -------------------------------------------------------
if (-not $SkipUsers) {
    Write-Step "Creating sample users"
    sf apex run --file scripts/apex/create-sample-users.apex --target-org $Alias
    Assert-LastExitCode "create-sample-users.apex"
} else {
    Write-Host "Skipping sample users (-SkipUsers)" -ForegroundColor Yellow
}

# --- 5. Done ---------------------------------------------------------------
Write-Step "Done"
Write-Host "Org '$Alias' is deployed and populated." -ForegroundColor Green
Write-Host "Next: sf org open --target-org $Alias" -ForegroundColor White
Write-Host "Then: follow PORTFOLIO/screenshots/README.md to capture evidence," -ForegroundColor White
Write-Host "  or run scripts/capture-evidence.ps1 to automate it." -ForegroundColor White
