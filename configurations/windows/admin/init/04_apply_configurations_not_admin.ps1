# Imports
. (Join-Path $PSScriptRoot "functions\for_installations.ps1")

$SourceDir = Join-Path $PSScriptRoot "..\files\configurations"

ssh-keygen -t ed25519 -C "${PERSONAL_EMAIL}-${PERSONAL_ORG}" -f "$HOME/.ssh/id_ed25519_${PERSONAL_ORG}" -N ""
ssh-keygen -t ed25519 -C "${WORK_EMAIL}-${WORK_ORG}" -f "$HOME/.ssh/id_ed25519_${WORK_ORG}" -N ""

Copy-ConfigFile -Source "$SourceDir\.work.gitconfig" -Destination "$env:USERPROFILE\.gitconfig"
Copy-ConfigFile -Source "$SourceDir\.personal.gitconfig" -Destination "$env:USERPROFILE\$env:PERSONAL_ORG\configurations\.personal.gitconfig"

$userToolsBin = Join-Path -Path $HOME -ChildPath ".tools\bin"
Add-PathToEnvironment -Path $userToolsBin