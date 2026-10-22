param (
    [string]$EnvPath = "$PSScriptRoot\..\..\..\..\.env"
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " INITIALIZING WINDOWS SETUP PRESET" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$ResolvedEnvPath = [System.IO.Path]::GetFullPath($EnvPath)
$StartConfigurationDir = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot ".."))
$CentralizedConfigurationsPath = Join-Path -Path ([System.IO.Path]::GetTempPath()) -ChildPath "confedev-centralized-configurations"

if (-not (Test-Path -LiteralPath $ResolvedEnvPath -PathType Leaf)) {
    Write-Error "Error: Environment file not found at: $ResolvedEnvPath"
    exit 1
}

$EnvValues = @{}
Get-Content -LiteralPath $ResolvedEnvPath | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith("#")) {
        $parts = $line.Split('=', 2)
        if ($parts.Length -eq 2) {
            $name = $parts[0].Trim()
            $value = $parts[1].Trim()
            if ($value.Length -ge 2 -and
                (($value.StartsWith('"') -and $value.EndsWith('"')) -or
                ($value.StartsWith("'") -and $value.EndsWith("'")))) {
                $value = $value.Substring(1, $value.Length - 2)
            }
            $EnvValues[$name] = $value
        }
    }
}

$env:CENTRALIZED_CONFIGURATIONS_REPOSITORY = $EnvValues["CENTRALIZED_CONFIGURATIONS_REPOSITORY"]
if ([string]::IsNullOrWhiteSpace($env:CENTRALIZED_CONFIGURATIONS_REPOSITORY)) {
    throw "Missing value for 'CENTRALIZED_CONFIGURATIONS_REPOSITORY' in $ResolvedEnvPath"
}
if (Test-Path -LiteralPath $CentralizedConfigurationsPath) {
    throw "Centralized configurations directory already exists: '$CentralizedConfigurationsPath'. Run 99_post_set.ps1 to clean it up before starting a new setup."
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required to clone centralized configurations."
}

Write-Host "Replacing template values from: $ResolvedEnvPath" -ForegroundColor Green
$TemplateFiles = @(Get-ChildItem -LiteralPath $StartConfigurationDir -File -Recurse -Force)
$PlaceholderPattern = '\$\{([A-Z0-9_]+)\}'
$RenderedFiles = @()

foreach ($File in $TemplateFiles) {
    $Content = [System.IO.File]::ReadAllText($File.FullName)
    if ($Content -notmatch $PlaceholderPattern) {
        continue
    }

    $RenderedContent = [regex]::Replace(
        $Content,
        $PlaceholderPattern,
        [System.Text.RegularExpressions.MatchEvaluator]{
            param($Match)
            $Name = $Match.Groups[1].Value
            if (-not $EnvValues.ContainsKey($Name)) {
                throw "Missing value for '$Name' in $ResolvedEnvPath"
            }
            return [string]$EnvValues[$Name]
        }
    )

    $RenderedFiles += [PSCustomObject]@{
        File = $File
        Content = $RenderedContent
    }
}

foreach ($RenderedFile in $RenderedFiles) {
    [System.IO.File]::WriteAllText($RenderedFile.File.FullName, $RenderedFile.Content)
    Write-Host "  -> Rendered: $($RenderedFile.File.Name)" -ForegroundColor DarkGray
}

Write-Host "Cloning centralized configurations..." -ForegroundColor Cyan
& git clone --quiet -- $env:CENTRALIZED_CONFIGURATIONS_REPOSITORY $CentralizedConfigurationsPath
$GitExitCode = $LASTEXITCODE
if ($GitExitCode -ne 0) {
    if (Test-Path -LiteralPath $CentralizedConfigurationsPath) {
        Remove-Item -LiteralPath $CentralizedConfigurationsPath -Recurse -Force
    }
    throw "Failed to clone centralized configurations from '$env:CENTRALIZED_CONFIGURATIONS_REPOSITORY' (git exit code: $GitExitCode)."
}

Write-Host "`nWindows Preset initialized successfully!" -ForegroundColor Green