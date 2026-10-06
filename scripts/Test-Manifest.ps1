#Requires -Version 7.3
[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string] $SchemaPath,
    [string] $InstallerPath,
    [string] $ExtractedPath
)

$ErrorActionPreference = 'Stop'
$manifestPath = Join-Path $PSScriptRoot '../bucket/packettracer.json'
$manifestJson = Get-Content -LiteralPath $manifestPath -Raw
if (-not (Test-Json -Json $manifestJson -SchemaFile $SchemaPath)) {
    throw 'The manifest does not conform to the Scoop schema.'
}
$manifest = $manifestJson | ConvertFrom-Json
Write-Output 'PASS: manifest conforms to the official Scoop schema.'

if ($InstallerPath) {
    $actualHash = (Get-FileHash -LiteralPath $InstallerPath -Algorithm SHA256).Hash
    if ($actualHash -ne $manifest.architecture.'64bit'.hash) {
        throw 'Installer SHA256 does not match the manifest.'
    }
    $signature = Get-AuthenticodeSignature -LiteralPath $InstallerPath
    if ($signature.Status -ne 'Valid' -or $signature.SignerCertificate.Subject -notmatch 'CISCO SYSTEMS, INC\.') {
        throw 'Installer does not have a valid Cisco Authenticode signature.'
    }
    Write-Output 'PASS: installer SHA256 and Cisco Authenticode signature.'
}

if ($ExtractedPath) {
    $exePath = Join-Path $ExtractedPath $manifest.bin[0][0]
    $appVersion = (Get-Item -LiteralPath $exePath).VersionInfo.ProductVersion.Trim()
    if ($appVersion -ne $manifest.version -and -not $appVersion.StartsWith("$($manifest.version).")) {
        throw "Extracted application version '$appVersion' does not match the manifest."
    }
    foreach ($shortcut in $manifest.shortcuts) {
        if (-not (Test-Path -LiteralPath (Join-Path $ExtractedPath $shortcut[0]) -PathType Leaf)) {
            throw "Shortcut target is missing: $($shortcut[0])"
        }
    }
    Write-Output "PASS: extracted application version ($appVersion), shim target, and shortcut target."
}
