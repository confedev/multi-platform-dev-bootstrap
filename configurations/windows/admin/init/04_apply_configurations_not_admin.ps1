# Imports
. (Join-Path $PSScriptRoot "functions\for_installations.ps1")

$ConfRootDir = getConfRootDir
$SourceDir = Join-Path -Path $ConfRootDir -ChildPath "configurations\windows\admin\files\configurations"

$personalKeyPath = "$HOME\.ssh\id_ed25519_${PERSONAL_ORG}"
if (-not (Test-PathExists -Path $personalKeyPath)) {
    ssh-keygen -t ed25519 -C "${PERSONAL_EMAIL}-${PERSONAL_ORG}" -f $personalKeyPath -N '""'
}

$workKeyPath = "$HOME\.ssh\id_ed25519_${WORK_ORG}"
if (-not (Test-PathExists -Path $workKeyPath)) {
    ssh-keygen -t ed25519 -C "${WORK_EMAIL}-${WORK_ORG}" -f $workKeyPath -N '""'
}

$userToolsBin = Join-Path -Path $HOME -ChildPath ".tools\bin"
Add-PathToEnvironment -Path $userToolsBin

$userToolsScripts = Join-Path -Path $HOME -ChildPath ".tools\scripts"
Add-PathToEnvironment -Path $userToolsScripts

# Copy Files
Copy-ConfigFile -Source (Join-Path -Path $SourceDir -ChildPath "git\.work.gitconfig") -Destination "$env:USERPROFILE\.gitconfig"
Copy-ConfigFile -Source (Join-Path -Path $SourceDir -ChildPath "git\.personal.gitconfig") -Destination "$env:USERPROFILE\$env:PERSONAL_ORG\configurations\.personal.gitconfig"

$ScriptsSourceDir = Join-Path -Path $ConfRootDir -ChildPath "configurations\windows\admin\files\scripts"
$UserToolsScriptsDir = Join-Path -Path $HOME -ChildPath ".tools\scripts"
Copy-Item -Path (Join-Path -Path $ScriptsSourceDir -ChildPath "*") -Destination $UserToolsScriptsDir -Recurse -Force