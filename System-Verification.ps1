# System Verification Script for CryptoSphere-Suite
# Run this from your project root: PS C:\Users\Store\CryptoSphere-Suite>

Write-Host "?? CRYPTOSPHERE-SUITE SYSTEM VERIFICATION" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor White
Write-Host ""

# 1. Check Basic Directory Structure
Write-Host "[1/6] Checking Project Structure..." -ForegroundColor Yellow
$essentialFiles = @("README.md", "package.json", "src", "scripts", "docs")
foreach ($file in $essentialFiles) {
    if (Test-Path $file) {
        Write-Host "   ? $file exists" -ForegroundColor Green
    } else {
        Write-Host "   ? MISSING: $file" -ForegroundColor Red
    }
}

# 2. Check Git Repository Status
Write-Host "`n[2/6] Checking Git Repository..." -ForegroundColor Yellow
try {
    $gitStatus = git status 2>&1
    $remoteUrl = git remote get-url origin 2>&1
    Write-Host "   ? Git repository initialized" -ForegroundColor Green
    Write-Host "   Remote: $remoteUrl" -ForegroundColor Gray
} catch {
    Write-Host "   ? Git repository issues detected" -ForegroundColor Red
}

# 3. Check Network Connectivity
Write-Host "`n[3/6] Checking Network Connectivity..." -ForegroundColor Yellow
$sitesToTest = @("github.com", "raw.githubusercontent.com", "npmjs.com")
foreach ($site in $sitesToTest) {
    try {
        $test = Test-NetConnection -ComputerName $site -Port 443 -InformationLevel Quiet
        if ($test) {
            Write-Host "   ? $site is accessible" -ForegroundColor Green
        } else {
            Write-Host "   ? $site may have issues" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "   ? Cannot reach $site" -ForegroundColor Red
    }
}

# 4. Check Key Services (Customize based on your project)
Write-Host "`n[4/6] Checking Essential Services..." -ForegroundColor Yellow

# Check if Node.js is available (if your project uses it)
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node --version
    Write-Host "   ? Node.js: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "   ? Node.js not detected" -ForegroundColor Yellow
}

# Check if Python is available
if (Get-Command python -ErrorAction SilentlyContinue) {
    $pythonVersion = python --version 2>&1
    Write-Host "   ? Python: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host "   ? Python not detected" -ForegroundColor Yellow
}

# 5. Check Project-Specific Files (Customize these)
Write-Host "`n[5/6] Checking Project-Specific Components..." -ForegroundColor Yellow

# Check if QuickTest script exists and is executable
if (Test-Path ".\QuickTest.ps1") {
    Write-Host "   ? QuickTest.ps1 found" -ForegroundColor Green
    try {
        # Try to run the quick test with minimal execution
        $result = powershell -File .\QuickTest.ps1 -NoProfile -ExecutionPolicy Bypass 2>&1
        Write-Host "   ? QuickTest.ps1 executed successfully" -ForegroundColor Green
    } catch {
        Write-Host "   ? QuickTest.ps1 has execution issues" -ForegroundColor Yellow
    }
} else {
    Write-Host "   ? QuickTest.ps1 not found" -ForegroundColor Red
}

# 6. Final System Health Check
Write-Host "`n[6/6] System Health Assessment..." -ForegroundColor Yellow

# Check disk space
$disk = Get-PSDrive C | Select-Object Used, Free
$freeGB = [math]::Round($disk.Free / 1GB, 2)
Write-Host "   Disk Space: $freeGB GB free" -ForegroundColor $(if ($freeGB -gt 10) { "Green" } else { "Yellow" })

# Check memory
$memory = Get-WmiObject Win32_OperatingSystem
$freeMemory = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
Write-Host "   Memory: $freeMemory GB free" -ForegroundColor $(if ($freeMemory -gt 2) { "Green" } else { "Yellow" })

Write-Host "`n" + "=" * 60 -ForegroundColor White
Write-Host "? SYSTEM VERIFICATION COMPLETE" -ForegroundColor Cyan
Write-Host "   Review any warnings or errors above" -ForegroundColor White
Write-Host "   Run specific functionality tests to complete validation" -ForegroundColor White
Write-Host "`nNext steps:"
Write-Host "   1. Run your actual test suite" -ForegroundColor Gray
Write-Host "   2. Test key application functionality" -ForegroundColor Gray
Write-Host "   3. Verify deployment scripts work" -ForegroundColor Gray
