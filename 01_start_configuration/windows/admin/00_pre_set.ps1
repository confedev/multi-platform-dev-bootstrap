param (
    [string]$EnvPath = "$PSScriptRoot\..\..\..\.env"
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " INITIALIZING WINDOWS SETUP PRESET" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$ResolvedEnvPath = [System.IO.Path]::GetFullPath($EnvPath)

if (-Not (Test-Path $ResolvedEnvPath)) {
    Write-Error "Error: Environment file not found at: $ResolvedEnvPath"
    exit 1
}

Write-Host "Reading environment variables from: $ResolvedEnvPath" -ForegroundColor Green

Get-Content $ResolvedEnvPath | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -Not $line.StartsWith("#")) {
        $parts = $line.Split('=', 2)
        if ($parts.Length -eq 2) {
            $name = $parts[0].Trim()
            $value = $parts[1].Trim() -replace '^["'']|["'']$', ''
            
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "  -> Loaded: $name" -ForegroundColor DarkGray
        }
    }
}

$env:USER_BASE = "C:/Users/$env:USERNAME"
Write-Host "  -> Generated USER_BASE: $env:USER_BASE" -ForegroundColor DarkGray

Write-Host "`nWindows Preset initialized successfully!" -ForegroundColor Green