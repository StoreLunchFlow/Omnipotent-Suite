// Simulated user database fetch function. Replace with your DB logic.
const getUserTier = (userId) => {
    // Placeholder logic. In reality, you would query a database.
    const userDatabase = {
        "test-user-id": "architect" // Our simulated user from auth.js is an Architect
    };
    return Promise.resolve(userDatabase[userId]);
};

const premiumAuth = async (req, res, next) => {
    try {
        const userId = req.user.id; // Assuming `req.user` is set by `authenticateToken`
        const userTier = await getUserTier(userId);

        if (userTier === "artisan" || userTier === "architect") {
            next(); // User is premium, proceed
        } else {
            return res.status(403).json({
                error: "Access Denied",
                message: "Premium subscription (Tier 2: Artisan) required."
            });
        }
    } catch (error) {
        console.error("Premium Auth Error:", error);
        res.status(500).json({ error: "Internal Server Error during authorization." });
    }
};

module.exports = premiumAuth;
