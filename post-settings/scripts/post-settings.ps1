<#
.SYNOPSIS
    Zips the Desktop\settings folder, Base64 encodes it, and POSTs it to blueprint.forge.com:8080.

.DESCRIPTION
    This script performs the following:
      1. Validates that $env:USERPROFILE\Desktop\settings exists
      2. Compresses the folder into a temporary ZIP archive
      3. Reads the ZIP bytes and converts to a Base64 string
      4. Sends the Base64 payload as JSON to the remote fileshare
      5. Cleans up the temporary ZIP file

.EXAMPLE
    .\post-settings.ps1
    .\post-settings.ps1 -Endpoint "http://blueprint.forge.com:8080/upload"
    .\post-settings.ps1 -SettingsPath "C:\custom\path\settings"
#>

[CmdletBinding()]
param(
    [Parameter()]
    [string]$SettingsPath = "$env:USERPROFILE\Desktop\settings",

    [Parameter()]
    [string]$Endpoint = "http://blueprint.forge.com:8080/upload",

    [Parameter()]
    [string]$AuthToken = ""
)

# ── Strict mode ──────────────────────────────────────────────────────────────
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ── Step 1: Validate source folder ──────────────────────────────────────────
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Post Settings to Remote Fileshare" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

if (-Not (Test-Path $SettingsPath)) {
    Write-Error "Settings folder not found at: $SettingsPath"
    exit 1
}

$itemCount = (Get-ChildItem -Path $SettingsPath -Recurse -File).Count
Write-Host "[1/5] Source folder validated" -ForegroundColor Green
Write-Host "       Path : $SettingsPath"
Write-Host "       Files: $itemCount"
Write-Host ""

# ── Step 2: Compress to ZIP ─────────────────────────────────────────────────
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipPath   = Join-Path $env:TEMP "settings_$timestamp.zip"

if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

Write-Host "[2/5] Compressing folder..." -ForegroundColor Yellow
Compress-Archive -Path $SettingsPath -DestinationPath $zipPath -CompressionLevel Optimal

$zipSizeKB = [math]::Round((Get-Item $zipPath).Length / 1KB, 2)
$zipSizeMB = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
Write-Host "[2/5] Compression complete" -ForegroundColor Green
Write-Host "       Archive: $zipPath"
Write-Host "       Size   : $zipSizeKB KB ($zipSizeMB MB)"
Write-Host ""

# ── Step 3: Base64 encode ───────────────────────────────────────────────────
Write-Host "[3/5] Base64 encoding..." -ForegroundColor Yellow
$zipBytes      = [System.IO.File]::ReadAllBytes($zipPath)
$base64Payload = [System.Convert]::ToBase64String($zipBytes)

$payloadLenMB = [math]::Round($base64Payload.Length / 1MB, 2)
Write-Host "[3/5] Encoding complete" -ForegroundColor Green
Write-Host "       Payload length: $($base64Payload.Length) chars ($payloadLenMB MB)"

# Warn on large payloads
if ($base64Payload.Length -gt 50MB) {
    Write-Warning "Payload exceeds 50 MB — upload may be slow or rejected by the server."
}
Write-Host ""

# ── Step 4: POST to remote fileshare ────────────────────────────────────────
Write-Host "[4/5] Uploading to $Endpoint ..." -ForegroundColor Yellow

$body = @{
    filename  = "settings_$timestamp.zip"
    content   = $base64Payload
    timestamp = $timestamp
    hostname  = $env:COMPUTERNAME
} | ConvertTo-Json -Compress

$headers = @{ "Content-Type" = "application/json" }
if ($AuthToken -ne "") {
    $headers["Authorization"] = "Bearer $AuthToken"
}

try {
    $response = Invoke-RestMethod -Uri $Endpoint `
                                  -Method POST `
                                  -Body $body `
                                  -Headers $headers `
                                  -TimeoutSec 120

    Write-Host "[4/5] Upload successful!" -ForegroundColor Green
    Write-Host "       Server response:"
    $response | ConvertTo-Json -Depth 5 | Write-Host
} catch {
    $statusCode = $null
    if ($_.Exception.Response) {
        $statusCode = [int]$_.Exception.Response.StatusCode
    }
    Write-Error "Upload failed (HTTP $statusCode): $($_.Exception.Message)"
    # Still clean up before exiting
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    exit 1
}
Write-Host ""

# ── Step 5: Clean up ────────────────────────────────────────────────────────
Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
Write-Host "[5/5] Temporary files cleaned up" -ForegroundColor Green
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "  Done! Settings posted successfully." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
