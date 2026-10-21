# Imports
. (Join-Path $PSScriptRoot "functions\for_installations.ps1")

$ConfRootDir = getConfRootDir
$SourceDir = Join-Path -Path $ConfRootDir -ChildPath "configurations\windows\admin\files\configurations"

Merge-JsonFiles -SourcePaths @(
    (Join-Path -Path $SourceDir -ChildPath "vscode\settings.json"),
    (Join-Path -Path $SourceDir -ChildPath "vscode\cSpell_en.json")
) -DestinationPath "$env:APPDATA\Code\User\settings.json"

# Enabled

if ($false){
    code --install-extension aaron-bond.better-comments
    code --install-extension adpyke.codesnap
    code --install-extension donjayamanne.githistory
    code --install-extension formulahendry.code-runner
    code --install-extension gruntfuggly.todo-tree
    code --install-extension hediet.vscode-drawio
    code --install-extension mhutchie.git-graph
    code --install-extension mikestead.dotenv
    code --install-extension quicktype.quicktype
    code --install-extension shardulm94.trailing-spaces
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension esbenp.prettier-vscode
    code --install-extension firsttris.vscode-jest-runner
    code --install-extension github.vscode-github-actions
    code --install-extension github.vscode-pull-request-github
    code --install-extension golang.go
    code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools
    code --install-extension ms-python.debugpy
    code --install-extension ms-python.python
    code --install-extension ms-python.vscode-pylance
    code --install-extension ms-python.vscode-python-envs
    code --install-extension orta.vscode-jest
    code --install-extension pflannery.vscode-versionlens
    code --install-extension redhat.vscode-xml
    code --install-extension redhat.vscode-yaml
    code --install-extension yoavbls.pretty-ts-errors
    code --install-extension pkief.material-icon-theme
    code --install-extension sonarsource.sonarlint-vscode
    code --install-extension streetsidesoftware.code-spell-checker
    code --install-extension usernamehw.errorlens
    code --install-extension redhat.java
    code --install-extension vscjava.vscode-java-debug
    code --install-extension vscjava.vscode-java-dependency
    code --install-extension vscjava.vscode-java-pack
    code --install-extension vscjava.vscode-java-test
    code --install-extension vscjava.vscode-java-upgrade
    code --install-extension vscjava.vscode-gradle
    code --install-extension vscjava.vscode-maven
}

# Disabled
if ($false) {
    code --install-extension eamodio.gitlens
    code --install-extension alexcvzz.vscode-sqlite
    code --install-extension graphql.vscode-graphql
    code --install-extension graphql.vscode-graphql-syntax
    code --install-extension jock.svg
    code --install-extension tomoki1207.pdf
    code --install-extension vscjava.vscode-spring-boot-dashboard
    code --install-extension yzhang.markdown-asll-in-one
    code --install-extension 42crunch.vscode-openapi
    code --install-extension amazonwebservices.aws-toolkit-vscode
    code --install-extension astro-build.astro-vscode
    code --install-extension atlassian.atlascode
    code --install-extension bradlc.vscode-tailwindcss
    code --install-extension docker.docker
    code --install-extension hashicorp.terraform
    code --install-extension mongodb.mongodb-vscode
    code --install-extension ms-vscode-remote.remote-containers
    code --install-extension semgrep.semgrep
    code --install-extension qwtel.sqlite-viewer
    code --install-extension vmware.vscode-spring-boot
    code --install-extension vscjava.vscode-spring-initializr
}

# Pending vulnerability analysis
if ($false) {
    code --install-extension meganrogge.template-string-converter
    code --install-extension sandcastle.vscode-open
    code --install-extension grapecity.gc-excelviewer
    code --install-extension mechatroner.rainbow-csv
}
