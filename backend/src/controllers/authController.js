// controllers/authController.js
// TODO: Refactor this to use an auth model for all data handling.

const jwt = require('jsonwebtoken'); // Authentication token handling
const bcrypt = require('bcryptjs'); // Password hashing
const sql = require('mssql'); // SQL Server connection
const connectToDatabase = require('../utils/dbConnection');
const { validateUserId, validateFields } = require('../utils/validationUtils');
const handleError = require('../utils/errorHandler');
const logger = require('../utils/logger'); 
const { hashToken } = require('../utils/hashToken');
const config = require('../config');

// Validate JWT Secret
const jwtSecret = config.JWT_SECRET_AUTH;
if (!jwtSecret) {
    throw new Error('JWT_SECRET_AUTH is not set in config.js');
}

/**
 * (POST) Register a new user
 */
exports.register = async (req, res, next) => {
    const { username, email, password } = req.body;
    logger.log(`Received registration request: { username: ${username}, email: ${email} }`);

    // Validate required fields
    if (!validateFields(req, res, ['username', 'email', 'password'])) return;

    try {
        const pool = await connectToDatabase();

        // Check if user already exists
        logger.log(`Checking if user already exists with email: ${email}`);

        const userExistsResult = await pool.request()
            .input('email', sql.NVarChar, email)
            .query('SELECT userId FROM Users WHERE email = @email');

        if (userExistsResult.recordset.length > 0) {
            logger.warn(`Registration failed: User already exists with email ${email}`);
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash password
        logger.log('Hashing password...');
        const saltRounds = 12; // Increased salt rounds for better security
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        logger.log('Password hashed successfully.');

        // Insert new user into the database
        logger.log('Inserting new user into the database...');
        const insertResult = await pool.request()
            .input('username', sql.NVarChar, username)
            .input('email', sql.NVarChar, email)
            .input('passwordHash', sql.NVarChar, hashedPassword)
            .query(`
                INSERT INTO Users (username, email, passwordHash)
                VALUES (@username, @email, @passwordHash);
                SELECT SCOPE_IDENTITY() AS userId;
            `);

        const newUserId = insertResult.recordset[0].userId;
        logger.log(`User inserted successfully with userId: ${newUserId}`);

        // Fetch the newly inserted user's details
        logger.log('Fetching the newly inserted user details...');
        const userDetailsResult = await pool.request()
            .input('userId', sql.Int, newUserId)
            .query(`SELECT userId, username, email FROM Users WHERE userId = @userId`);

        const newUser = userDetailsResult.recordset[0];

        logger.log('Creating JWT token...');
        const token = jwt.sign(
            { userId: newUser.userId },
            jwtSecret,
            { expiresIn: '2h' }
        );

        logger.log('JWT token created successfully.');

        // Respond with token and user details
        res.status(201).json({
            message: 'Registration successful',
            token,
            user: {
                userId: newUser.userId,
                username: newUser.username,
                email: newUser.email,
            },
        });
        logger.log('Registration successful.');
    } catch (error) {
        handleError(error, res, 'Error during registration');
    }
};

/**
 * (POST) Authenticate user and get token
 */
exports.login = async (req, res, next) => {
    const { email, password } = req.body;

    // Validate required fields
    if (!validateFields(req, res, ['email', 'password'])) return;

    try {
        const pool = await connectToDatabase();

        // Find user by email
        logger.log(`Searching for user with email: ${email}`);
        const userResult = await pool.request()
            .input('email', sql.NVarChar, email)
            .query('SELECT userId, username, email, passwordHash, role FROM Users WHERE email = @email');

        if (userResult.recordset.length === 0) {
            logger.warn(`Login failed: User not found with email ${email}`);
            return res.status(400).json({ message: 'Invalid credentials' }); // Generic message to prevent email enumeration
        }

        const user = userResult.recordset[0];
        logger.log(`User found: ${user.username} (userId: ${user.userId})`);

        // Compare password
        logger.log('Comparing provided password with stored hash...');
        const isMatch = await bcrypt.compare(password, user.passwordHash);
        if (!isMatch) {
            logger.warn(`Login failed: Invalid password for email ${email}`);
            return res.status(400).json({ message: 'Invalid credentials' });
        }
        logger.log('Password matched successfully.');

        // Create JWT token
        logger.log('Creating JWT token...');
        const token = jwt.sign(
            { userId: user.userId },
            jwtSecret,
            { expiresIn: '2h' }
        );

        logger.log('JWT token created successfully.');

        // Respond with token and user details
        res.status(200).json({
            message: 'Login successful',
            token,
            user: {
                userId: user.userId,
                username: user.username,
                email: user.email,
                role: user.role,
            },
        });
        logger.log('Login successful.');
    } catch (error) {
        logger.error(`Error during login: ${error.message}`);
        res.status(500).json({ message: 'Server error', error: error.message });
    }
};


/**
 * (POST) Log user out
 */
exports.logout = async (req, res, next) => {
    try {
        // Extract the token from the Authorization header
        const token = req.headers.authorization?.split(' ')[1];

        if (!token) {
            logger.warn('Logout failed: No token provided');
            return res.status(400).json({ message: 'No token provided for logout' });
        }

        // Hash the token before storing it (Azure SQL Constraints here)
        const hashedToken = hashToken(token);

        // Store the token in blacklist to implement invalidation
        logger.log('Connecting to the database to store token in blacklist...');
        const pool = await connectToDatabase();

        // Insert the token into a Blacklist table
        await pool.request()
            .input('token', sql.NVarChar, hashedToken)
            .input('expiresAt', sql.DateTime, new Date(Date.now() + 2 * 60 * 60 * 1000)) // Token expires in 2 hours
            .query('INSERT INTO TokenBlacklist (token, expiresAt) VALUES (@token, @expiresAt)');

        logger.log('Hashed token stored in blacklist successfully');

        res.status(200).json({ message: 'Logout successful' });
        logger.log('Logout successful');
    } catch (error) {
        handleError(error, res, 'Error during logout');
    }
};