# Imports
. "$PSScriptRoot\..\functions\for_installations.ps1"

$SourceDir = "$PSScriptRoot\..\..\..\02_configuration"

ssh-keygen -t ed25519 -C "${PERSONAL_EMAIL}-${PERSONAL_ORG}" -f "$HOME/.ssh/id_ed25519_${PERSONAL_ORG}" -N ""
ssh-keygen -t ed25519 -C "${WORK_EMAIL}-${WORK_ORG}" -f "$HOME/.ssh/id_ed25519_${WORK_ORG}" -N ""

Copy-ConfigFile -Source "$SourceDir\.work.gitconfig" -Destination "$env:USERPROFILE\.gitconfig"
Copy-ConfigFile -Source "$SourceDir\.personal.gitconfig" -Destination "$env:USERPROFILE\$env:PERSONAL_ORG\02_configuration\.personal.gitconfig