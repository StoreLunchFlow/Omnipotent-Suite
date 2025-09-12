function Get-CryptoRandomBytes {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [int]$ByteCount,
        
        [Parameter(Mandatory=$false)]
        [ValidateSet('ByteArray', 'Hex', 'Base64')]
        [string]$OutputFormat = 'ByteArray'
    )
    
    begin {
        Write-Debug "Initializing RNG provider"
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new()
    }
    
    process {
        Write-Debug "Generating $ByteCount random bytes"
        $bytes = New-Object byte[] $ByteCount
        $rng.GetBytes($bytes)
        
        switch ($OutputFormat) {
            'Hex' {
                $hexString = ($bytes | ForEach-Object { $_.ToString('X2') }) -join ''
                Write-Debug "Returning hex format"
                return $hexString
            }
            'Base64' {
                $base64String = [System.Convert]::ToBase64String($bytes)
                Write-Debug "Returning Base64 format"
                return $base64String
            }
            default {
                Write-Debug "Returning byte array"
                return $bytes
            }
        }
    }
    
    end {
        Write-Debug "Cleaning up RNG resources"
        if ($rng) { $rng.Dispose() }
        Write-Debug "Get-CryptoRandomBytes function completed"
    }
}
