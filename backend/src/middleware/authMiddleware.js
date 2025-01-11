const jwt = require('jsonwebtoken');
const sql = require('mssql');
const connectToDatabase = require('../utils/dbConnection');
const logger = require('../utils/logger');
const handleError = require('../utils/errorHandler');
require('dotenv').config();
const { hashToken } = require('../utils/hashToken');

const authMiddleware = async (req, res, next) => {
    try {
        // Check if the Authorization header is present
        const authHeader = req.header('Authorization');
        if (!authHeader) {
            logger.warn('Authorization header is missing.');
            return res.status(401).json({ message: 'Authorization header is required. Please provide a valid token.' });
        }

        // Check if the header starts with "Bearer"
        const parts = authHeader.split(' ');
        if (parts[0] !== 'Bearer' || parts.length !== 2) {
            logger.warn('Authorization header format is incorrect.');
            return res.status(401).json({ message: 'Authorization format is invalid. Use "Bearer <token>".' });
        }

        // Extract the token
        const token = parts[1];

        // Hash the incoming token
        const hashedToken = hashToken(token);

        // Check if the hashed token exists in the blacklist
        const pool = await connectToDatabase();
        const blacklistCheck = await pool.request()
            .input('token', sql.NVarChar, hashedToken)
            .query('SELECT * FROM TokenBlacklist WHERE token = @token');

        if (blacklistCheck.recordset.length > 0) {
            logger.warn(`Token is blacklisted: ${hashToken}`);
            return res.status(401).json({ message: 'Token is blacklisted. Please log in again.' });
        }

        // Verify the token
        try {
            const decoded = jwt.verify(token, process.env.JWT_SECRET_AUTH);
            logger.log(`Token verified successfully for userId: ${decoded.userId}`);

            // Attach the decoded user to the request object
            req.user = { userId: decoded.userId };
            next(); // Proceed to the next middleware or route handler
        } catch (error) {
            if (error.name === 'TokenExpiredError') {
                logger.warn('Token has expired.');
                return res.status(401).json({ message: 'Token has expired. Please log in again.' });
            }

            if (error.name === 'JsonWebTokenError') {
                logger.warn('Invalid token.');
                return res.status(401).json({ message: 'Invalid token. Please provide a valid token.' });
            }
            throw error; // Rethrow the error to be handled by the outer catch block
        }
    } catch (error) {
        handleError(error, res, 'Authorization failed due to a server error.');
    }
};

module.exports = authMiddleware;
