Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " INITIALIZING POST-SET CLEANUP" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$confirmation = Read-Host "This will discard local changes made during the setup process (e.g., rendered templates). Do you want to proceed? (y/n)"

if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-Host "Post-set cleanup aborted by user." -ForegroundColor Yellow
    exit 0
}

Write-Host "Resetting local repository changes..." -ForegroundColor Yellow

git reset --hard HEAD
git clean -fd

$CentralizedConfigurationsPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "confedev-centralized-configurations"
if (Test-Path -LiteralPath $CentralizedConfigurationsPath) {
    Remove-Item -LiteralPath $CentralizedConfigurationsPath -Recurse -Force
    Write-Host "Removed temporary centralized configurations clone." -ForegroundColor Green
}

Write-Host "`nPost-set cleanup completed successfully! Repository is clean." -ForegroundColor Green