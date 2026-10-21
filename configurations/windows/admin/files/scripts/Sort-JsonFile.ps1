function Sort-JsonObject {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $InputObject
    )

    if ($InputObject -is [System.Collections.IDictionary]) {
        $sortedHash = [ordered]@{}
        $InputObject.Keys | Sort-Object | ForEach-Object {
            $sortedHash[$_] = Sort-JsonObject -InputObject $InputObject[$_]
        }
        return $sortedHash
    }
    elseif ($InputObject -is [PSCustomObject]) {
        $sortedHash = [ordered]@{}
        $InputObject.PSObject.Properties | Sort-Object Name | ForEach-Object {
            $sortedHash[$_.Name] = Sort-JsonObject -InputObject $_.Value
        }
        return $sortedHash
    }
    elseif ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $sortedList = [System.Collections.Generic.List[object]]::new()
        foreach ($item in $InputObject) {
            $sortedList.Add((Sort-JsonObject -InputObject $item))
        }
        return $sortedList
    }
    else {
        return $InputObject
    }
}

function Sort-JsonFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$OutputPath = $Path
    )

    if (-not (Test-Path -Path $Path)) {
        Write-Host "File '$Path' does not exist." -ForegroundColor Red
        return
    }

    $jsonRaw = Get-Content -Path $Path -Raw
    if ([string]::IsNullOrWhiteSpace($jsonRaw)) {
        Write-Host "File '$Path' is empty." -ForegroundColor Yellow
        return
    }

    $jsonObject = $jsonRaw | ConvertFrom-Json
    $sortedObject = Sort-JsonObject -InputObject $jsonObject

    $sortedObject | ConvertTo-Json -Depth 100 | Set-Content -Path $OutputPath -Encoding utf8
    Write-Host "JSON successfully sorted and saved to '$OutputPath'." -ForegroundColor Green
}