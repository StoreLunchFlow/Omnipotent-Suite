@'
const express = require("express");
const { exec } = require("child_process");
const router = express.Router();
const premiumAuth = require("../middleware/premiumAuth");
const { architectAuth } = require("../middleware/architectAuth"); // We will create this next

// GET /api/command/scripts - List available, pre-approved scripts for Tier 3 Architects
router.get("/scripts", architectAuth, (req, res) => {
    // This list is hardcoded for SECURITY. Users can ONLY run these scripts.
    const approvedScripts = {
        "osint_domain": {
            name: "Domain OSINT Probe",
            description: "Runs a whois lookup and DNS record check for a target domain.",
            command: "powershell -ExecutionPolicy Bypass -File \"./scripts/osint/domain-check.ps1\" -TargetDomain "
        },
        "crypto_btc_tx": {
            name: "Bitcoin Transaction Decoder",
            description: "Fetches and analyzes details for a Bitcoin transaction hash using a block explorer API.",
            command: "node \"./scripts/blockchain/btc-lookup.js\" "
        },
        "system_health": {
            name: "Server Health Check",
            description: "Checks system resource usage (CPU, Memory, Disk) on the server.",
            command: "powershell -Command \"Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage; Get-WmiObject -Class Win32_OperatingSystem | Select-Object FreePhysicalMemory, TotalVisibleMemorySize; Get-PSDrive C | Select-Object Used, Free\""
        }
    };
    res.json(approvedScripts);
});

// POST /api/command/execute - Execute a specific approved script
router.post("/execute", architectAuth, (req, res) => {
    const { scriptId, parameters } = req.body;
    const approvedScripts = {
        "osint_domain": { command: "powershell -ExecutionPolicy Bypass -File \"./scripts/osint/domain-check.ps1\" -TargetDomain " },
        "crypto_btc_tx": { command: "node \"./scripts/blockchain/btc-lookup.js\" " },
        "system_health": { command: "powershell -Command \"Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage; Get-WmiObject -Class Win32_OperatingSystem | Select-Object FreePhysicalMemory, TotalVisibleMemorySize; Get-PSDrive C | Select-Object Used, Free\"" }
    };

    // 1. Validate the requested script is approved
    const script = approvedScripts[scriptId];
    if (!script) {
        return res.status(400).json({ error: "Invalid script ID." });
    }

    // 2. Sanitize user input to prevent command injection
    // CRITICAL: This is a basic sanitizer. For production, use a library like `validator`.
    let sanitizedParams = "";
    if (parameters && scriptId !== "system_health") { // Don't sanitize parameters for fixed commands
        sanitizedParams = parameters.replace(/[&|;$<>()\`'"\\]/g, "");
    }
    const fullCommand = script.command + sanitizedParams;

    // 3. Set headers for Server-Sent Events (SSE) for real-time output
    res.setHeader("Content-Type", "text/event-stream");
    res.setHeader("Cache-Control", "no-cache");
    res.setHeader("Connection", "keep-alive");
    res.flushHeaders(); // Flush the headers to establish the SSE connection

    // 4. Execute the command and stream output back to the client
    const childProcess = exec(fullCommand, { windowsHide: true });

    childProcess.stdout.on("data", (data) => {
        // Send output as a SSE message
        res.write(`data: ${data.toString().replace(/\n/g, '\ndata: ')}\n\n`);
    });

    childProcess.stderr.on("data", (data) => {
        res.write(`data: [ERROR] ${data.toString().replace(/\n/g, '\ndata: ')}\n\n`);
    });

    childProcess.on("close", (code) => {
        res.write(`data: [PROCESS COMPLETE] Exit code: ${code}\n\n`);
        res.end(); // End the SSE stream
    });

    // Handle client connection close
    req.on("close", () => {
        if (!childProcess.killed) {
            childProcess.kill(); // Kill the process if the client disconnects
        }
    });
});

module.exports = router;
'@ | Out-File -FilePath ".\src\routes\commandPost.js" -Encoding utf8
Write-Host "Command Post router created. This is the core of Tier 3 access." -ForegroundColor Green