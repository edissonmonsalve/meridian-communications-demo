<#
.SYNOPSIS
    Captures the full evidence library (screenshots + short clips) from a
    deployed, populated Scratch Org.

.DESCRIPTION
    Thin wrapper around scripts/evidence/capture-evidence.js. Requires the
    org to already be deployed and populated (run scripts/deploy-all.ps1
    first) and Playwright installed (npm install --save-dev playwright &&
    npx playwright install chromium — one-time setup, not done automatically
    here since it's a real dependency addition, not something to install
    silently).

.PARAMETER Alias
    Scratch org alias to capture from. Default: meridian-demo

.EXAMPLE
    .\scripts\capture-evidence.ps1
#>

param(
    [string]$Alias = "meridian-demo"
)

$ErrorActionPreference = "Stop"
$RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $RepoRoot

if (-not (Test-Path "node_modules/playwright")) {
    Write-Host "Playwright isn't installed yet. One-time setup:" -ForegroundColor Yellow
    Write-Host "    npm install --save-dev playwright" -ForegroundColor White
    Write-Host "    npx playwright install chromium" -ForegroundColor White
    exit 1
}

node scripts/evidence/capture-evidence.js --org $Alias
