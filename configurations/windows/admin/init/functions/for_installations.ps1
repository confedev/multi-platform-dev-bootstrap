function Test-CommandMissing {
    param (
        [Parameter(Mandatory = $true)]
        [string]$CommandName,
        
        [Parameter(Mandatory = $false)]
        [string]$CustomMessage
    )

    $isMissing = -not (Get-Command $CommandName -ErrorAction SilentlyContinue)

    if ($isMissing) {
        if ($PSBoundParameters.ContainsKey('CustomMessage') -and $CustomMessage) {
            Write-Host "$CustomMessage is not installed (Validated command: $CommandName)" -ForegroundColor Red
        } else {
            Write-Host "$CommandName is not installed." -ForegroundColor Red
        }
    } else {
        if ($PSBoundParameters.ContainsKey('CustomMessage') -and $CustomMessage) {
            Write-Host "$CustomMessage is already installed (Validated command: $CommandName)" -ForegroundColor Green
        } else {
            Write-Host "$CommandName is already installed." -ForegroundColor Green
        }
    }

    return $isMissing
}

function Test-AppPathMissing {
    param (
        [Parameter(Mandatory = $true)]
        [string]$RelativePath,
        
        [Parameter(Mandatory = $true)]
        [string]$CustomMessage
    )

    $fullPaths = @(
        "$env:LOCALAPPDATA\$RelativePath",
        "$env:ProgramFiles\$RelativePath",
        "${env:ProgramFiles(x86)}\$RelativePath"
    )

    $isInstalled = $false
    foreach ($path in $fullPaths) {
        if (Test-Path $path) {
            $isInstalled = $true
            break
        }
    }

    $isMissing = -not $isInstalled

    if ($isMissing) {
        Write-Host "$CustomMessage is not installed." -ForegroundColor Red
    } else {
        Write-Host "$CustomMessage is already installed." -ForegroundColor Green
    }

    return $isMissing
}

function Invoke-DownloadAndInstall {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Url,
        
        [Parameter(Mandatory = $true)]
        [string]$AppName,
        
        [Parameter(Mandatory = $false)]
        [switch]$Silent,

        [Parameter(Mandatory = $false)]
        [string]$Extension = ".exe"
    )

    $fileName = [System.IO.Path]::GetFileName($Url) -replace '\s+', '_'
    
    if ([string]::IsNullOrWhiteSpace($fileName)) {
        $fileName = "installer"
    }
    
    if (-not $fileName.EndsWith($Extension, [System.StringComparison]::OrdinalIgnoreCase)) {
        $fileName += $Extension
    }
    
    $output = "$env:TEMP\$fileName"

    Write-Host "Downloading $AppName to: $output" -ForegroundColor Cyan
    Invoke-WebRequest -Uri $Url -OutFile $output

    if ($Silent) {
        Write-Host "Installing $AppName silently..." -ForegroundColor Yellow
        # CORRECCIÓN: Se eliminaron las comillas forzadas alrededor de $output
        Start-Process -FilePath $output -ArgumentList "/SILENT" -Wait
    } else {
        Write-Host "Opening $AppName installer..." -ForegroundColor Yellow
        # CORRECCIÓN: Se eliminaron las comillas forzadas alrededor de $output
        Start-Process -FilePath $output -Wait
    }

    if (-not [string]::IsNullOrWhiteSpace($output) -and (Test-Path -Path $output)) {
        Remove-Item -Path $output -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "$AppName installation finished." -ForegroundColor Green
}


function Copy-ConfigFile {
    param (
        [string]$Source,
        [string]$Destination
    )
    
    $DestDir = Split-Path -Path $Destination -Parent
    if (-Not (Test-Path $DestDir)) {
        New-Item -ItemType Directory -Force -Path $DestDir | Out-Null
    }
    
    Copy-Item -Path $Source -Destination $Destination -Force
}

$Global:SelectedBrowser = "default"

function Open-Url {
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [string]$Url,

        [Parameter(Mandatory=$false, Position=1)]
        [string]$Text = ""
    )

    $displayMessage = if ([string]::IsNullOrWhiteSpace($Text)) { $Url } else { $Text }

    Write-Host "Opening $displayMessage in the browser..." -ForegroundColor Cyan

    if ($Url -notmatch "^https?://") {
        $Url = "https://$Url"
    }

    try {
        switch ($Global:SelectedBrowser.ToLower()) {
            "chrome"  { Start-Process "chrome.exe" -ArgumentList $Url }
            "edge"    { Start-Process "msedge.exe" -ArgumentList $Url }
            "brave"   { Start-Process "brave.exe" -ArgumentList $Url }
            "firefox" { Start-Process "firefox.exe" -ArgumentList $Url }
            default   { Start-Process $Url }
        }
    }
    catch {
        Write-Error "An error occurred while trying to open the URL: $_"
    }
}

function Add-PathToEnvironment {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$Path,

        [Parameter(Mandatory = $false)]
        [bool]$IsMachine = $false
    )

    process {
        $targetScope = if ($IsMachine) { "Machine" } else { "User" }

        if (-not (Test-Path -Path $Path)) {
            New-Item -ItemType Directory -Path $Path -Force | Out-Null
        }

        $resolvedPath = (Resolve-Path -Path $Path).ProviderPath

        $currentPath = [Environment]::GetEnvironmentVariable("Path", $targetScope)

        $pathArray = if ($currentPath) { $currentPath -split ';' } else { @() }
        $normalizedPathArray = $pathArray | ForEach-Object { $_.TrimEnd('\') }
        $normalizedTargetPath = $resolvedPath.TrimEnd('\')

        if ($normalizedPathArray -notcontains $normalizedTargetPath) {
            $newPath = if ([string]::IsNullOrWhiteSpace($currentPath)) {
                $resolvedPath
            } else {
                "$currentPath;$resolvedPath"
            }

            [Environment]::SetEnvironmentVariable("Path", $newPath, $targetScope)
            
            $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

            Write-Host "Path '$resolvedPath' successfully added to the $targetScope environment variable." -ForegroundColor Green
        } else {
            Write-Host "Path '$resolvedPath' already exists in the $targetScope environment variable." -ForegroundColor Yellow
        }
    }
}

function Save-BinaryToToolsBin {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$Url,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$OutputFileName,

        [Parameter(Mandatory = $false)]
        [string]$CustomMessage
    )

    process {
        $toolsBinDir = Join-Path -Path $HOME -ChildPath ".tools\bin"
        if (-not (Test-Path -Path $toolsBinDir)) {
            New-Item -ItemType Directory -Path $toolsBinDir -Force | Out-Null
        }

        if ([string]::IsNullOrWhiteSpace($OutputFileName)) {
            $OutputFileName = [System.IO.Path]::GetFileName(($Url -split '\?')[0])
        }

        $destinationPath = Join-Path -Path $toolsBinDir -ChildPath $OutputFileName

        if (-not [string]::IsNullOrWhiteSpace($CustomMessage)) {
            Write-Host "Downloading $CustomMessage..." -ForegroundColor Cyan
        } else {
            Write-Host "Downloading binary from '$Url'..." -ForegroundColor Cyan
        }

        try {
            Invoke-WebRequest -Uri $Url -OutFile $destinationPath -UseBasicParsing
            Write-Host "Binary successfully saved to '$destinationPath'." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to download binary: $_" -ForegroundColor Red
        }
    }
}