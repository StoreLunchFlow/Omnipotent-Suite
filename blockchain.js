@'
// Example using a public API. Replace with your own API key for better rate limits.
const https = require('https');

const txHash = process.argv[2]; // Get transaction hash from command line argument

if (!txHash) {
    console.log('Usage: node btc-lookup.js <transaction_hash>');
    process.exit(1);
}

console.log(`[*] Fetching details for BTC transaction: ${txHash}`);

const options = {
  hostname: 'blockstream.info',
  port: 443,
  path: `/api/tx/${txHash}`,
  method: 'GET'
};

const req = https.request(options, (res) => {
  let data = '';

  res.on('data', (chunk) => {
    data += chunk;
  });

  res.on('end', () => {
    try {
      const txData = JSON.parse(data);
      console.log('✅ Transaction Details:');
      console.log(`   - Block Height: ${txData.status.block_height || 'Unconfirmed'}`);
      console.log(`   - Size: ${txData.size} bytes`);
      console.log(`   - Virtual Size: ${txData.vsize} bytes`);
      console.log(`   - Fee: ${txData.fee} satoshis`);
      console.log(`   - Input Count: ${txData.vin.length}`);
      console.log(`   - Output Count: ${txData.vout.length}`);
    } catch (error) {
      console.error('[!] Error parsing API response:', error.message);
    }
  });
});

req.on('error', (error) => {
  console.error('[!] API Request failed:', error.message);
});

req.end();
'@ | Out-File -FilePath ".\src\scripts\blockchain\btc-lookup.js" -Encoding utf8
Write-Host "Example scripts created. The Command Post is now armed." -ForegroundColor Green