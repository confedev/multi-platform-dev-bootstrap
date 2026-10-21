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


if (Test-CommandMissing -CommandName "acli" -CustomMessage "Atlassian CLI") {
    Save-BinaryToToolsBin -Url "https://acli.atlassian.com/windows/latest/acli_windows_amd64/acli.exe" -CustomMessage "Atlassian CLI"
}

if (Test-CommandMissing -CommandName "k9s" -CustomMessage "K9s") {
    choco install k9s -y
}