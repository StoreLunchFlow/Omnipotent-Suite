# SIMULATED TRADING ENGINE v2.1
# NON-PROMOTIONAL, REALISTIC MARKET SIMULATION ONLY
# NO REAL FUNDS OR FINANCIAL ADVICE

$Global:SimulationPortfolio = @{
    CashBalance = 10000.00
    Positions = @{}
    TradeHistory = @()
    MarketConditions = "Normal"
    Commission = 1.00
    SlippageFactor = 0.001
}

function Get-SimulatedMarketData {
    param(
        [string]$Symbol,
        [int]$Days = 30
    )
    
    $volatility = @{"BTC"=0.02; "ETH"=0.03; "AAPL"=0.015; "MSFT"=0.014}[$Symbol]
    $basePrice = @{"BTC"=50000; "ETH"=3000; "AAPL"=180; "MSFT"=300}[$Symbol]
    
    $data = @()
    $currentPrice = $basePrice * (0.95 + (Get-Random -Minimum 0.0 -Maximum 0.1))
    
    for($i=0; $i -lt $Days; $i++) {
        $change = (Get-Random -Minimum (-$volatility) -Maximum $volatility)
        $currentPrice = $currentPrice * (1 + $change)
        $data += [PSCustomObject]@{
            Date = (Get-Date).AddDays(-$Days + $i)
            Symbol = $Symbol
            Open = [math]::Round($currentPrice * (0.998 + (Get-Random -Minimum 0.0 -Maximum 0.004)), 2)
            High = [math]::Round($currentPrice * (1 + (Get-Random -Minimum 0.0 -Maximum 0.01)), 2)
            Low = [math]::Round($currentPrice * (1 - (Get-Random -Minimum 0.0 -Maximum 0.01)), 2)
            Close = [math]::Round($currentPrice, 2)
            Volume = [math]::Round((Get-Random -Minimum 1000000 -Maximum 5000000) * (1 + $change), 0)
        }
    }
    
    return $data
}

function Invoke-SimulatedTrade {
    param(
        [string]$Symbol,
        [ValidateSet("Buy","Sell")]
        [string]$Action,
        [double]$Quantity,
        [double]$LimitPrice
    )
    
    $marketData = Get-SimulatedMarketData -Symbol $Symbol -Days 1
    $currentPrice = $marketData[-1].Close
    
    # Realistic execution logic
    $executionPrice = $currentPrice
    $slippage = $executionPrice * $Global:SimulationPortfolio.SlippageFactor * (Get-Random -Minimum 0.5 -Maximum 2.0)
    
    if($Action -eq "Buy") {
        $executionPrice += $slippage
    } else {
        $executionPrice -= $slippage
    }
    
    if($LimitPrice -gt 0) {
        if(($Action -eq "Buy" -and $executionPrice -gt $LimitPrice) -or 
           ($Action -eq "Sell" -and $executionPrice -lt $LimitPrice)) {
            Write-Host "[SIMULATION] Limit order not filled. Current price: $($executionPrice)" -ForegroundColor Yellow
            return $false
        }
    }
    
    $totalCost = ($executionPrice * $Quantity) + $Global:SimulationPortfolio.Commission
    
    if($Action -eq "Buy") {
        if($Global:SimulationPortfolio.CashBalance -lt $totalCost) {
            Write-Host "[SIMULATION] Insufficient funds for purchase." -ForegroundColor Red
            return $false
        }
        
        $Global:SimulationPortfolio.CashBalance -= $totalCost
        if(-not $Global:SimulationPortfolio.Positions[$Symbol]) {
            $Global:SimulationPortfolio.Positions[$Symbol] = @{
                Quantity = 0
                AvgPrice = 0
            }
        }
        
        $oldQty = $Global:SimulationPortfolio.Positions[$Symbol].Quantity
        $oldAvg = $Global:SimulationPortfolio.Positions[$Symbol].AvgPrice
        
        $newQty = $oldQty + $Quantity
        $newAvg = (($oldQty * $oldAvg) + ($Quantity * $executionPrice)) / $newQty
        
        $Global:SimulationPortfolio.Positions[$Symbol] = @{
            Quantity = $newQty
            AvgPrice = [math]::Round($newAvg, 2)
        }
        
    } else {
        if(-not $Global:SimulationPortfolio.Positions[$Symbol] -or 
           $Global:SimulationPortfolio.Positions[$Symbol].Quantity -lt $Quantity) {
            Write-Host "[SIMULATION] Insufficient holdings to sell." -ForegroundColor Red
            return $false
        }
        
        $Global:SimulationPortfolio.CashBalance += ($executionPrice * $Quantity) - $Global:SimulationPortfolio.Commission
        $Global:SimulationPortfolio.Positions[$Symbol].Quantity -= $Quantity
        
        if($Global:SimulationPortfolio.Positions[$Symbol].Quantity -eq 0) {
            $Global:SimulationPortfolio.Positions.Remove($Symbol)
        }
    }
    
    # Log trade
    $trade = [PSCustomObject]@{
        Timestamp = Get-Date
        Symbol = $Symbol
        Action = $Action
        Quantity = $Quantity
        Price = $executionPrice
        Total = $totalCost
        PortfolioValue = (Get-SimulatedPortfolioValue)
    }
    
    $Global:SimulationPortfolio.TradeHistory += $trade
    
    Write-Host "[SIMULATION] Trade executed: $Action $Quantity $Symbol at $$executionPrice" -ForegroundColor Green
    return $true
}

function Get-SimulatedPortfolioValue {
    $total = $Global:SimulationPortfolio.CashBalance
    foreach($symbol in $Global:SimulationPortfolio.Positions.Keys) {
        $data = Get-SimulatedMarketData -Symbol $symbol -Days 1
        $price = $data[-1].Close
        $total += $price * $Global:SimulationPortfolio.Positions[$symbol].Quantity
    }
    return [math]::Round($total, 2)
}

function Show-SimulatedPortfolio {
    Write-Host "`n=== SIMULATED TRADING PORTFOLIO ===" -ForegroundColor Cyan
    Write-Host "Cash Balance: $$($Global:SimulationPortfolio.CashBalance)" -ForegroundColor White
    
    if($Global:SimulationPortfolio.Positions.Count -gt 0) {
        Write-Host "`nPositions:" -ForegroundColor Yellow
        foreach($symbol in $Global:SimulationPortfolio.Positions.Keys) {
            $data = Get-SimulatedMarketData -Symbol $symbol -Days 1
            $currentPrice = $data[-1].Close
            $position = $Global:SimulationPortfolio.Positions[$symbol]
            $unrealized = ($currentPrice - $position.AvgPrice) * $position.Quantity
            
            Write-Host ("{0}: {1} shares @ ${2} | Current: ${3} | P&L: ${4}" -f 
                $symbol.PadRight(6),
                $position.Quantity,
                $position.AvgPrice,
                $currentPrice,
                [math]::Round($unrealized, 2)) -ForegroundColor $(if($unrealized -ge 0) {"Green"} else {"Red"})
        }
    }
    
    Write-Host "`nTotal Portfolio Value: $$(Get-SimulatedPortfolioValue)" -ForegroundColor Cyan
    Write-Host "=== END SIMULATION ===" -ForegroundColor Cyan
}

Export-ModuleMember -Function *
