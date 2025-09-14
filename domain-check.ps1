@'
param(
    [Parameter(Mandatory=$true)]
    [string]$TargetDomain
)

Write-Output "[*] Starting OSINT check for domain: $TargetDomain"
Write-Output ""

Write-Output "[+] Performing whois lookup..."
try {
    # This command requires the whois command-line tool.
    # You can install it via `choco install whois` or `winget install JerryNixon.whois`
    whois $TargetDomain | Select-String -Pattern "Registrant", "Admin", "Tech", "Name Server", "Creation Date", "Updated Date"
} catch {
    Write-Output "[!] Error during whois lookup. Is the 'whois' tool installed?"
}

Write-Output ""
Write-Output "[+] Checking DNS A records..."
try {
    Resolve-DnsName -Name $TargetDomain -Type A | Format-Table Name, IPAddress -AutoSize
} catch {
    Write-Output "[!] Error resolving DNS A records."
}

Write-Output ""
Write-Output "[*] Domain check complete."
'@ | Out-File -FilePath ".\src\scripts\osint\domain-check.ps1" -Encoding utf8