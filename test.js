#!/usr/bin/env node
// Test helper script for CryptoSphere Suite
console.log('?? Running CryptoSphere Suite Tests...');
console.log('==========================================');

// Check if Jest is available
try {
  require('jest');
  console.log('? Jest is available');
} catch (e) {
  console.log('? Jest not found. Run: npm install --save-dev jest');
  process.exit(1);
}

// Run the tests
const { exec } = require('child_process');
exec('npx jest', (error, stdout, stderr) => {
  if (error) {
    console.log(`? Tests failed: ${error}`);
    return;
  }
  console.log(stdout);
  console.log('? All tests completed');
});
