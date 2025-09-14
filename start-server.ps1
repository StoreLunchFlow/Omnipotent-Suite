Write-Host "🚀 STARTING OMNIPOTENT-SUITE SERVER" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Green

# Check if server.js exists
if (-not (Test-Path ".\src\server.js")) {
    Write-Host "❌ ERROR: server.js not found!" -ForegroundColor Red
    exit 1
}

# Check if node_modules exists
if (-not (Test-Path ".\node_modules")) {
    Write-Host "⚠️  Installing dependencies..." -ForegroundColor Yellow
    npm install
}

Write-Host "✅ Starting server on port 3000..." -ForegroundColor Green
Write-Host "📍 Endpoints:" -ForegroundColor Cyan
Write-Host "   - Health: http://localhost:3000/api/health" -ForegroundColor White
Write-Host "   - Premium: http://localhost:3000/api/premium/content" -ForegroundColor White
Write-Host "   - Command: http://localhost:3000/api/command/scripts" -ForegroundColor White
Write-Host ""
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow

# Start the server
node .\src\server.js
