$settingsPath = "$env:APPDATA\Code\User\settings.json"
$settingsDirectory = Split-Path -Path $settingsPath -Parent

if (-not (Test-Path -LiteralPath $settingsDirectory -PathType Container)) {
    New-Item -ItemType Directory -Path $settingsDirectory -Force | Out-Null
}

$settings = if (Test-Path -LiteralPath $settingsPath -PathType Leaf) {
    $settingsContent = Get-Content -LiteralPath $settingsPath -Raw
    if ([string]::IsNullOrWhiteSpace($settingsContent)) {
        [PSCustomObject]@{}
    } else {
        $settingsContent | ConvertFrom-Json
    }
} else {
    [PSCustomObject]@{}
}

$settings | Add-Member -MemberType NoteProperty -Name "extensions.autoUpdate" -Value $false -Force
$settings | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $settingsPath
Write-Host "Auto-update for all VS Code extensions has been disabled." -ForegroundColor Green