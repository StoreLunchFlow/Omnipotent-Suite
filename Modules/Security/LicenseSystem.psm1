# ENTERPRISE LICENSE SYSTEM v1.5
# OFFLINE-FIRST VALIDATION WITH HARDWARE BINDING

function Get-SystemHardwareId {
    $cpu = (Get-WmiObject -Class Win32_Processor).ProcessorId
    $bios = (Get-WmiObject -Class Win32_BIOS).SerialNumber
    $baseId = "$cpu-$bios"
    $hash = [System.BitConverter]::ToString(
        [System.Security.Cryptography.SHA256]::Create().ComputeHash(
            [System.Text.Encoding]::UTF8.GetBytes($baseId)
        )
    ).Replace("-","").Substring(0, 16)
    return $hash
}

function New-LicenseKey {
    param(
        [string]$CustomerId,
        [datetime]$ExpiryDate,
        [string]$Tier = "Standard"
    )
    
    $hardwareId = Get-SystemHardwareId
    $payload = "$CustomerId|$($ExpiryDate.ToString('yyyy-MM-dd'))|$Tier|$hardwareId"
    $encrypted = ConvertTo-SecureString -String $payload -AsPlainText -Force
    $licenseKey = [System.Convert]::ToBase64String(
        [System.Text.Encoding]::UTF8.GetBytes(
            [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
                [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($encrypted)
            )
        )
    )
    
    return @{
        LicenseKey = $licenseKey
        CustomerId = $CustomerId
        ExpiryDate = $ExpiryDate
        Tier = $Tier
    }
}

function Test-LicenseKey {
    param(
        [string]$LicenseKey
    )
    
    try {
        $decoded = [System.Text.Encoding]::UTF8.GetString(
            [System.Convert]::FromBase64String($LicenseKey)
        )
        
        $secureString = ConvertTo-SecureString -String $decoded -AsPlainText -Force
        $plainText = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
            [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString)
        )
        
        $parts = $plainText -split "\|"
        if($parts.Length -ne 4) { return $false }
        
        $currentHardwareId = Get-SystemHardwareId
        if($parts[3] -ne $currentHardwareId) {
            Write-Host "License hardware binding mismatch." -ForegroundColor Red
            return $false
        }
        
        $expiryDate = [datetime]::ParseExact($parts[1], "yyyy-MM-dd", $null)
        if((Get-Date) -gt $expiryDate) {
            Write-Host "License has expired." -ForegroundColor Red
            return $false
        }
        
        return @{
            Valid = $true
            CustomerId = $parts[0]
            ExpiryDate = $expiryDate
            Tier = $parts[2]
        }
    }
    catch {
        return @{Valid = $false}
    }
}

function Install-License {
    param(
        [string]$LicenseKey,
        [string]$Path = "$env:ProgramData\CryptoSphereSuite\license.key"
    )
    
    $validation = Test-LicenseKey -LicenseKey $LicenseKey
    if(-not $validation.Valid) {
        throw "Invalid license key. Installation failed."
    }
    
    $licenseDir = Split-Path -Path $Path -Parent
    if(-not (Test-Path $licenseDir)) {
        New-Item -ItemType Directory -Path $licenseDir -Force | Out-Null
    }
    
    $LicenseKey | Out-File -FilePath $Path -Encoding UTF8
    Write-Host "License installed successfully. Tier: $($validation.Tier)" -ForegroundColor Green
}

Export-ModuleMember -Function *
