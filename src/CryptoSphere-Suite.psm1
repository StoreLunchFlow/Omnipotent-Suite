# Dot-source all function files from the Public directory
$PublicFunctions = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )

foreach ($File in $PublicFunctions) {
    try {
        . $File.FullName
        Write-Verbose "Imported function from: $($File.Name)"
    }
    catch {
        Write-Error "Failed to import function from $($File.Name): $_"
    }
}
