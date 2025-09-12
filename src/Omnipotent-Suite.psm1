# Omnipotent-Suite Core Module
# Requires PowerShell 7.0+

# Import Private Functions
Get-ChildItem -Path $PSScriptRoot/Private -Filter *.ps1 -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

# Import Public Functions
Get-ChildItem -Path $PSScriptRoot/Modules -Filter *.ps1 -ErrorAction SilentlyContinue | ForEach-Object {
    . $_.FullName
}

# Module Cleanup
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    Write-Verbose "Omnipotent-Suite module unloaded"
}

Export-ModuleMember -Function * -Alias *
