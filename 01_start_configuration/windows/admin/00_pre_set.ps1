param (
    [string]$EnvPath = "$PSScriptRoot\..\..\..\.env"
)

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " INITIALIZING WINDOWS SETUP PRESET" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$ResolvedEnvPath = [System.IO.Path]::GetFullPath($EnvPath)
$StartConfigurationDir = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\..")
$ConfigDir = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\..\..\02_configuration")

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

Write-Host "Replacing template values from: $ResolvedEnvPath" -ForegroundColor Green
$TemplateFiles = @(
    Get-ChildItem -LiteralPath $ConfigDir -File -Filter "*.gitconfig"
    Get-ChildItem -LiteralPath $StartConfigurationDir -File -Recurse -Force
)
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

Write-Host "`nWindows Preset initialized successfully!" -ForegroundColor Green