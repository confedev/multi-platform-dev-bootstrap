$javaHome = "$env:USERPROFILE\.posh_sdk\java\${DEFAULT_JAVA_VERSION}"
$binPath = "$javaHome\bin"

[Environment]::SetEnvironmentVariable("JAVA_HOME", $javaHome, [EnvironmentVariableTarget]::Machine)

$oldPath = [Environment]::GetEnvironmentVariable("PATH", [EnvironmentVariableTarget]::Machine)

if ($oldPath -notlike "*$binPath*") {
    $newPath = "$oldPath;$binPath"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, [EnvironmentVariableTarget]::Machine)
    Write-Host "Java added to PATH successfully." -ForegroundColor Green
} else {
    Write-Host "Java is already in PATH." -ForegroundColor Yellow
}