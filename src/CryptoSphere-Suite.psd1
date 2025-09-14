@{
    ModuleVersion = "1.0.0"
    GUID = "' + (New-Guid).ToString() + '"
    Author = "StoreLunchFlow"
    Description = "Elite Cryptocurrency Management Framework"
    PowerShellVersion = "5.1"
    FunctionsToExport = @(
        "Get-CryptoRandomBytes",
        "Invoke-CryptoDonation"
    )
    RootModule = "CryptoSphere-Suite.psm1"
}
