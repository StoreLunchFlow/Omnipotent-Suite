// Test to verify project structure
const fs = require('fs');
const path = require('path');

describe('Project structure verification', () => {
  test('package.json exists', () => {
    expect(fs.existsSync('package.json')).toBe(true);
  });
  
  test('README.md exists', () => {
    expect(fs.existsSync('README.md')).toBe(true);
  });
  
  test('node_modules exists', () => {
    expect(fs.existsSync('node_modules')).toBe(true);
  });
  
  test('tests directory exists', () => {
    expect(fs.existsSync('tests')).toBe(true);
  });
});
