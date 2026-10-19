# Imports
. "$PSScriptRoot\..\functions\for_installations.ps1"

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

if (Test-CommandMissing -CommandName "pwsh" -CustomMessage "PowerShell 7") {
    winget install --id Microsoft.PowerShell --source winget --installer-type wix
}

if (Test-CommandMissing -CommandName "docker" -CustomMessage "Docker") {
    Invoke-DownloadAndInstall `
        -Url "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" `
        -AppName "Docker Desktop"
}