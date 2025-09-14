# Quick Validation Script for CryptoSphere-Suite
Write-Host "Running quick validation..." -ForegroundColor Yellow

# Test basic functions
try {
    $data = Get-SimulatedMarketData -Symbol "ETH" -Days 1
    Write-Host "? Market data working" -ForegroundColor Green
} catch { Write-Host "? Market data failed" -ForegroundColor Red }

try {
    $hwid = Get-SystemHardwareId
    Write-Host "? Hardware ID: $hwid" -ForegroundColor Green
} catch { Write-Host "? Hardware ID failed" -ForegroundColor Red }

Show-SimulatedPortfolio
