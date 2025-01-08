const jwt = require('jsonwebtoken');
require('dotenv').config();

const authMiddleware = (req, res, next) => {
    try {
        // Check if the Authorization header is present
        const authHeader = req.header('Authorization');
        if (!authHeader) {
            console.warn('Authorization header is missing.');
            return res.status(401).json({ message: 'Authorization header is required. Please provide a valid token.' });
        }

        // Check if the header starts with "Bearer"
        const parts = authHeader.split(' ');
        if (parts[0] !== 'Bearer' || parts.length !== 2) {
            console.warn('Authorization header format is incorrect.');
            return res.status(401).json({ message: 'Authorization format is invalid. Use "Bearer <token>".' });
        }

        // Extract the token
        const token = parts[1];

        // Verify the token
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        console.log('Token verified successfully:', decoded);

        // Attach the decoded user to the request object
        req.user = { userId: decoded.userId };
        next(); // Proceed to the next middleware or route handler

    } catch (error) {
        //Handle different JWT errors
        if (error.name === 'TokenExpiredError') {
            console.warn('Token has expired.');
            return res.status(401).json({ message: 'Token has expired. Please log in again.' });
        }

        if (error.name === 'JsonWebTokenError') {
            console.warn('Invalid token.');
            return res.status(401).json({ message: 'Invalid token. Please provide a valid token.' });
        }

        console.error('Authorization error:', error);
        return res.status(500).json({ message: 'Authorization failed due to a server error.' });
    }
};

module.exports = authMiddleware;
