# CryptoSphere-Suite License System Module
# Version: 2.0 - Fixed Edition

function Get-SystemHardwareId {
    $computerInfo = Get-WmiObject -Class Win32_ComputerSystemProduct
    return ($computerInfo.UUID -replace '-', '').Substring(0, 16)
}

function New-LicenseKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$CustomerId,
        
        [Parameter(Mandatory=$false)]
        [DateTime]$ExpiryDate,
        
        [Parameter(Mandatory=$true)]
        [ValidateSet("Basic", "Professional", "Enterprise")]
        [string]$Tier
    )

    # Set default expiry if not provided (6 months from now)
    if (-not $ExpiryDate) {
        $ExpiryDate = (Get-Date).AddMonths(6)
        Write-Host "??  Using default expiry date: $($ExpiryDate.ToString('yyyy-MM-dd'))" -ForegroundColor Yellow
    }

    # Create license payload
    $payload = "$CustomerId|$($ExpiryDate.ToString('yyyy-MM-dd'))|$Tier|$(Get-SystemHardwareId)"
    
    # Generate secure hash
    $hash = New-Object System.Security.Cryptography.SHA256Managed
    $signature = [System.BitConverter]::ToString($hash.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($payload))) -replace '-'
    
    # Combine payload and signature
    $licenseData = "$payload|$signature"
    
    # Return as Base64 encoded license key
    $licenseKey = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($licenseData))
    
    return @{
        LicenseKey = $licenseKey
        CustomerId = $CustomerId
        ExpiryDate = $ExpiryDate
        Tier = $Tier
    }
}

function Test-LicenseKey {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$LicenseKey
    )
    
    try {
        # Decode from Base64
        $decodedData = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($LicenseKey))
        $parts = $decodedData -split '\|'
        
        if ($parts.Count -ne 5) {
            return @{ Valid = $false; Reason = "Invalid license format" }
        }
        
        $customerId = $parts[0]
        $expiryDate = [DateTime]::ParseExact($parts[1], 'yyyy-MM-dd', $null)
        $tier = $parts[2]
        $hardwareId = $parts[3]
        $signature = $parts[4]
        
        # Recreate payload for validation
        $validationPayload = "$customerId|$($expiryDate.ToString('yyyy-MM-dd'))|$tier|$hardwareId"
        $hash = New-Object System.Security.Cryptography.SHA256Managed
        $expectedSignature = [System.BitConverter]::ToString($hash.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($validationPayload))) -replace '-'
        
        $isValid = ($signature -eq $expectedSignature) -and (Get-SystemHardwareId -eq $hardwareId) -and ($expiryDate -gt (Get-Date))
        
        return @{
            Valid = $isValid
            CustomerId = $customerId
            ExpiryDate = $expiryDate
            Tier = $tier
            Reason = if (-not $isValid) { "License validation failed" } else { "Valid" }
        }
    }
    catch {
        return @{ Valid = $false; Reason = "Corrupted license data: $($_.Exception.Message)" }
    }
}

Export-ModuleMember -Function New-LicenseKey, Test-LicenseKey, Get-SystemHardwareId
