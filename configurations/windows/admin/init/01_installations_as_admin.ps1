# Imports
. (Join-Path $PSScriptRoot "functions\for_installations.ps1")

# Installations
if (Test-CommandMissing -CommandName "git") {
    winget install --id Git.Git -e --source winget
}

if (Test-CommandMissing -CommandName "choco" -CustomMessage "Chocolatey") {
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

if (Test-CommandMissing -CommandName "code" -CustomMessage "Visual Studio Code") {
    winget install Microsoft.VisualStudioCode
}

$DisableVSCodeAutoUpdateScript = Join-Path $PSScriptRoot "..\files\scripts\Disable-VSCodeAutoUpdate.ps1"
& $DisableVSCodeAutoUpdateScript

if (Test-CommandMissing -CommandName "pwsh" -CustomMessage "PowerShell 7") {
    winget install --id Microsoft.PowerShell --source winget --installer-type wix
}

if (Test-CommandMissing -CommandName "docker" -CustomMessage "Docker") {
    Invoke-DownloadAndInstall `
        -Url "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" `
        -AppName "Docker Desktop"
}

if (Test-CommandMissing -CommandName "zoxide" -CustomMessage "Zoxide") {
    choco install zoxide -y
}

if (Test-CommandMissing -CommandName "fzf" -CustomMessage "Fuzzy Finder") {
    choco install fzf -y
}

if (Test-CommandMissing -CommandName "glow" -CustomMessage "Glow") {
    choco install glow -y
}

if (Test-CommandMissing -CommandName "jq" -CustomMessage "jq") {
    choco install jq -y
}

if (Test-CommandMissing -CommandName "yq" -CustomMessage "yq") {
    choco install yq -y
}

if (Test-CommandMissing -CommandName "kubectl" -CustomMessage "Kubernetes CLI") {
    choco install kubernetes-cli -y
}

if (Test-CommandMissing -CommandName "grep" -CustomMessage "GNU Grep") {
    choco install grep -y
}

if (Test-CommandMissing -CommandName "rg" -CustomMessage "Ripgrep") {
    choco install ripgrep -y
}

$Url = "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip"
$TempDir = Join-Path $env:TEMP "NerdFonts_FiraCode"
$ZipFile = Join-Path $TempDir "FiraCode.zip"
$FontsFolder = "$env:windir\Fonts"
$CheckFont = Join-Path $FontsFolder "FiraCodeNerdFont-Regular.ttf"

if (Test-Path $CheckFont) {
    Write-Host "Font is already installed!" -ForegroundColor Yellow
    exit
}

if (!(Test-Path $TempDir)) { New-Item -ItemType Directory -Path $TempDir | Out-Null }

Invoke-WebRequest -Uri $Url -OutFile $ZipFile
Expand-Archive -Path $ZipFile -DestinationPath $TempDir -Force

$FontFiles = Get-ChildItem -Path $TempDir -Include *.ttf -Recurse
foreach ($FontFile in $FontFiles) {
    $Destination = Join-Path $FontsFolder $FontFile.Name
    Copy-Item $FontFile.FullName -Destination $Destination -Force

    $NameWithoutExtension = $FontFile.BaseName
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "$NameWithoutExtension (TrueType)" -Value $FontFile.Name -PropertyType String -Force | Out-Null
}

Remove-Item -Path $TempDir -Recurse -Force

Write-Host "Installation completed successfully!" -ForegroundColor Green
