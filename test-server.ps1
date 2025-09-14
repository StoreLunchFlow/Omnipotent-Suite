Write-Host "🧪 QUICK SERVER TEST" -ForegroundColor Cyan
Write-Host "===================" -ForegroundColor Cyan

$ports = 3000, 8080, 8081, 3001, 9090
$found = $false

foreach ($port in $ports) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:$port/api/health" -TimeoutSec 1 -ErrorAction Stop
        Write-Host "✅ Server running on port $port" -ForegroundColor Green
        Write-Host "   Status: $($response.status)" -ForegroundColor White
        Write-Host "   Message: $($response.message)" -ForegroundColor White
        $found = $true
        break
    } catch {
        Write-Host "❌ Port $port: No server" -ForegroundColor DarkGray
    }
}

if (-not $found) {
    Write-Host "❌ No server found. Start with: .\launch-production.ps1" -ForegroundColor Red
}
