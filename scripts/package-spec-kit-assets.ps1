param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("extension", "preset")]
    [string]$PackageType,

    [Parameter(Mandatory = $true)]
    [string]$PackageId,

    [string]$OutputDirectory = "dist"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$packageRoot = Join-Path $repoRoot ($PackageType + "s")
$sourceDir = Join-Path $packageRoot $PackageId

if (-not (Test-Path $sourceDir)) {
    throw "Pacote nao encontrado: $sourceDir"
}

$manifestName = if ($PackageType -eq "extension") { "extension.yml" } else { "preset.yml" }
$manifestPath = Join-Path $sourceDir $manifestName

if (-not (Test-Path $manifestPath)) {
    throw "Manifesto nao encontrado: $manifestPath"
}

$manifestContent = Get-Content -Path $manifestPath -Raw
$versionPattern = if ($PackageType -eq "extension") {
    'extension:\s*(?:\r?\n(?:\s+.*))*?\r?\n\s+version:\s*"([^"]+)"'
}
else {
    'preset:\s*(?:\r?\n(?:\s+.*))*?\r?\n\s+version:\s*"([^"]+)"'
}

$versionMatch = [regex]::Match($manifestContent, $versionPattern)

if (-not $versionMatch.Success) {
    throw "Nao foi possivel identificar a versao em $manifestPath"
}

$version = $versionMatch.Groups[1].Value
$distDir = Join-Path $repoRoot $OutputDirectory
$zipName = "$PackageId-$version.zip"
$zipPath = Join-Path $distDir $zipName

New-Item -ItemType Directory -Path $distDir -Force | Out-Null

if (Test-Path $zipPath) {
    Remove-Item $zipPath -Force
}

Push-Location $sourceDir
try {
    Compress-Archive -Path * -DestinationPath $zipPath -Force
}
finally {
    Pop-Location
}

Write-Output "Empacotado: $zipPath"
