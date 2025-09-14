// Ultra-minimal server - only essential code
const express = require("express");
const app = express();
const PORT = 3000;

// Basic middleware
app.use(express.json());

// Health endpoint only
app.get("/api/health", (req, res) => {
    res.json({ status: "OK", message: "Server is running" });
});

// Start server
app.listen(PORT, () => {
    console.log("Server started on port", PORT);
});

// Basic error handling
process.on("uncaughtException", (error) => {
    console.error("CRITICAL ERROR:", error);
    process.exit(1);
});
