console.log("Testing basic Node.js functionality...");

// Test if require works
try {
    const express = require("express");
    console.log("✅ Express module loaded successfully");
} catch (e) {
    console.log("❌ Express module error:", e.message);
    process.exit(1);
}

// Test basic HTTP server
const http = require("http");
const server = http.createServer((req, res) => {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "OK", message: "Basic server working" }));
});

server.listen(3000, () => {
    console.log("✅ Basic HTTP server running on port 3000");
});
