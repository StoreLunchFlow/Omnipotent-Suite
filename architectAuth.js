@'
// Middleware to restrict access ONLY to Tier 3: Architect users.

const { getUserTier } = require("../models/User"); // This function would talk to your database

// For now, we'll use the same simulated function as premiumAuth
const simulateGetUserTier = (userId) => {
    const userDatabase = { "test-user-id": "architect" };
    return Promise.resolve(userDatabase[userId]);
};

const architectAuth = async (req, res, next) => {
    try {
        const userId = req.user.id;
        const userTier = await simulateGetUserTier(userId); // Replace with `getUserTier(userId)`

        if (userTier === "architect") {
            next(); // User is an Architect, grant access
        } else {
            return res.status(403).json({
                error: "Access Denied",
                message: "Tier 3: Architect clearance required to access the Command Post."
            });
        }
    } catch (error) {
        console.error("Architect Auth Error:", error);
        res.status(500).json({ error: "Internal Server Error during authorization." });
    }
};

module.exports = { architectAuth };
'@ | Out-File -FilePath ".\src\middleware\architectAuth.js" -Encoding utf8
Write-Host "Architect authentication middleware created." -ForegroundColor Green