# Imports
. "$PSScriptRoot\..\functions\for_installations.ps1"

# Installations
if (Test-AppPathMissing -RelativePath "BraveSoftware\Brave-Browser\Application\brave.exe" -CustomMessage "Brave Browser") {
    winget install Brave.Brave
} 

if (Test-CommandMissing -CommandName "nvm" -CustomMessage "NVM for Windows") {
    Invoke-DownloadAndInstall `
        -Url "https://github.com/nvm-windows/nvm/releases/download/v2.0.0/nvm-2.0.0-amd64-setup.exe" `
        -AppName "NVM for Windows"
}

if (Test-AppPathMissing -RelativePath "Postman\Postman.exe" -CustomMessage "Postman") {
    Invoke-DownloadAndInstall `
        -Url "https://dl.pstmn.io/download/latest/win64" `
        -AppName "Postman"
}

if (Test-CommandMissing -CommandName "sdk" -CustomMessage "SDKMAN (Posh version)") {
    Install-Module -Name Posh-SDKMan
}

if (Test-CommandMissing -CommandName "java" -CustomMessage "Java 17") {
    sdk install java ${DEFAULT_JAVA_VERSION}
}

if (Test-CommandMissing -CommandName "copilot" -CustomMessage "Github Copilot") {
    winget install GitHub.Copilot
}
