function Invoke-CryptoDonation {
    <#
    .SYNOPSIS
        Displays cryptocurrency wallet addresses for donations.
    .DESCRIPTION
        This command displays Bitcoin and Ethereum wallet addresses to facilitate donations.
    .EXAMPLE
        Invoke-CryptoDonation
    #>
    [CmdletBinding()]
    param ()

    # Integrated wallet addresses from directive
    $BtcWalletLegacy = "DyKdgcW2ACBf5urpxNmTrHCBGkRaA9ft8MBUZPu2YV3R"
    $BtcWalletSegWit = "bc1qtdv9rgs9z8kwazxsflt3h5aed8m2nejzsww5z8"
    $EthWallet = "0x49e59C205fF3217BEb72aBdFF7a0Fcf1d37EFa64"

    # ANSI color formatting for premium look
    $colorHeader = "`e[38;5;39m"
    $colorAccent = "`e[38;5;214m"
    $colorLabel = "`e[1;37m"
    $colorReset = "`e[0m"

    $Output = @"

$colorHeader╔══════════════════════════════════════════════════════════════╗
$colorHeader║                     Support This Project                     ║
$colorHeader╚══════════════════════════════════════════════════════════════╝$colorReset

Thank you for considering a donation!

$colorLabel• Bitcoin (BTC - Legacy):$colorReset
  $colorAccent$BtcWalletLegacy$colorReset

$colorLabel• Bitcoin (BTC - SegWit):$colorReset
  $colorAccent$BtcWalletSegWit$colorReset

$colorLabel• Ethereum (ETH):$colorReset
  $colorAccent$EthWallet$colorReset

"@

    Write-Host $Output
}
