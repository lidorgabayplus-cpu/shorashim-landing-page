# =====================================================
# Shorashim Landing Page - GitHub Push Script
# Run this ONCE from inside the deploy-to-github folder
# =====================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   Shorashim GitHub Deploy Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if git is installed
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Git is not installed." -ForegroundColor Red
    Write-Host "Please install Git from https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "Then run this script again." -ForegroundColor Yellow
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host "Git found: $(git --version)" -ForegroundColor Green
Write-Host ""

# Get token securely
Write-Host "Please paste your GitHub Personal Access Token:" -ForegroundColor Yellow
Write-Host "(It will be hidden as you type)" -ForegroundColor Gray
$secureToken = Read-Host -AsSecureString
$bstr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
$token = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr)

if ($token.Length -lt 10) {
    Write-Host "ERROR: Token seems too short. Exiting." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Setting up repository..." -ForegroundColor Cyan

# Get the script's own directory
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptDir

# Init git if not already
if (-not (Test-Path ".git")) {
    git init
    git branch -M main
}

# Set remote with token
$remoteUrl = "https://${token}@github.com/lidorgabayplus-cpu/shorashim-landing-page.git"
git remote remove origin 2>$null
git remote add origin $remoteUrl

# Configure git identity
git config user.email "lidorgabayplus@gmail.com"
git config user.name "Lidor Gabay"

Write-Host ""
Write-Host "Adding all files..." -ForegroundColor Cyan
git add -A

Write-Host ""
Write-Host "Committing..." -ForegroundColor Cyan
git commit -m "Deploy Shorashim landing page with all assets"

Write-Host ""
Write-Host "Pushing to GitHub (this may take a minute for large files)..." -ForegroundColor Cyan
git push -u origin main --force

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   SUCCESS! Files uploaded to GitHub" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Repo: https://github.com/lidorgabayplus-cpu/shorashim-landing-page" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "IMPORTANT: Revoke your GitHub token after deployment!" -ForegroundColor Yellow
    Write-Host "Go to: GitHub Settings > Developer settings > Personal access tokens" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "ERROR: Push failed. Check the error message above." -ForegroundColor Red
}

Write-Host ""
Read-Host "Press Enter to exit"
