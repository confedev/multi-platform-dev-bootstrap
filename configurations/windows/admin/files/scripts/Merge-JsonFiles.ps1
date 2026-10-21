function Merge-JsonObject {
    param (
        $Json1,
        $Json2
    )

    $result = $Json1.PSObject.Copy()

    foreach ($property in $Json2.PSObject.Properties) {
        $name = $property.Name
        $value = $property.Value

        if ($result.PSObject.Properties[$name]) {
            if ($result.$name -is [PSCustomObject] -and $value -is [PSCustomObject]) {
                $result.$name = Merge-JsonObject -Json1 $result.$name -Json2 $value
            } else {
                $result.$name = $value
            }
        } else {
            $result | Add-Member -MemberType NoteProperty -Name $name -Value $value
        }
    }

    return $result
}

function Merge-JsonFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Path1,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$Path2,

        [Parameter(Mandatory = $true, Position = 2)]
        [string]$OutputPath
    )

    if (-not (Test-Path -Path $Path1)) {
        Write-Host "File '$Path1' does not exist." -ForegroundColor Red
        return
    }

    if (-not (Test-Path -Path $Path2)) {
        Write-Host "File '$Path2' does not exist." -ForegroundColor Red
        return
    }

    $json1 = Get-Content -Path $Path1 -Raw | ConvertFrom-Json
    $json2 = Get-Content -Path $Path2 -Raw | ConvertFrom-Json

    $merged = Merge-JsonObject -Json1 $json1 -Json2 $json2

    $merged | ConvertTo-Json -Depth 100 | Set-Content -Path $OutputPath -Encoding utf8
    Write-Host "Files successfully merged into '$OutputPath'." -ForegroundColor Green
}