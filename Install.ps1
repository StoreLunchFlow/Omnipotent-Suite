Write-Host "🚀 CryptoSphere Suite Professional Installation" -ForegroundColor Cyan
Write-Host "💎 Installing institutional-grade cryptocurrency tools..." -ForegroundColor Yellow

# Check prerequisites
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "PowerShell 7.0+ required. Please upgrade."
    exit 1
}

# Create module directory
$modulePath = Join-Path $env:USERPROFILE "Documents\PowerShell\Modules\CryptoSphere-Suite"
New-Item -ItemType Directory -Path $modulePath -Force | Out-Null

# Copy files
Copy-Item -Path ".\src\*" -Destination $modulePath -Recurse -Force

Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host "📖 Run: Import-Module CryptoSphere-Suite" -ForegroundColor White
Write-Host "🎯 Run: Initialize-CryptoEnvironment -Mode Professional" -ForegroundColor White
