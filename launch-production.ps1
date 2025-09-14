Write-Host "🚀 OMNIPOTENT-SUITE PRODUCTION LAUNCH" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green

# Check Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js not found. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Clean up any previous processes
Write-Host "🔄 Cleaning up previous processes..." -ForegroundColor Yellow
Get-Process node -ErrorAction SilentlyContinue | Where-Object { $_.Path -like "*robust-server.js" } | Stop-Process -Force -ErrorAction SilentlyContinue

# Install dependencies if missing
if (-not (Test-Path "node_modules")) {
    Write-Host "📦 Installing dependencies..." -ForegroundColor Yellow
    npm install
}

Write-Host "🎯 Starting robust server..." -ForegroundColor Cyan
Write-Host "📍 Trying ports: 3000, 8080, 8081, 3001, 9090" -ForegroundColor White
Write-Host "⏳ Server will automatically find available port" -ForegroundColor White
Write-Host ""

# Start the robust server
node robust-server.js
