// controllers/authController.js

const jwt = require('jsonwebtoken'); // Authentication token handling
const bcrypt = require('bcryptjs'); // Password hashing
const sql = require('mssql'); // SQL Server connection
const connectToDatabase = require('../utils/dbConnection');
const { validateFields } = require('../utils/validationUtils');
const handleError = require('../utils/errorHandler');
require('dotenv').config(); // Load environment variables from .env

// Validate JWT Secret
const jwtSecret = process.env.JWT_SECRET;
if (!jwtSecret) {
    throw new Error('JWT_SECRET is not set in environment variables.');
}

/**
 * (POST) Register a new user
 */
exports.register = async (req, res) => {
    const { username, email, password } = req.body;
    console.log('Received registration request:', { username, email });

    // Validate required fields
    if (!validateFields(req, res, ['username', 'email', 'password'])) return;

    try {
        const pool = await connectToDatabase();

        // Check if user already exists
        console.log(`Checking if user already exists with email: ${email}`);

        const userExistsResult = await pool.request()
            .input('email', sql.NVarChar, email)
            .query('SELECT userId FROM Users WHERE email = @email');

        if (userExistsResult.recordset.length > 0) {
            console.warn(`Registration failed: User already exists with email ${email}`);
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash password
        console.log('Hashing password...');
        const saltRounds = 12; // Increased salt rounds for better security
        const hashedPassword = await bcrypt.hash(password, saltRounds);
        console.log('Password hashed successfully.');

        // Insert new user into the database
        // Insert new user into the database
        console.log('Inserting new user into the database...');
        const insertResult = await pool.request()
            .input('username', sql.NVarChar, username)
            .input('email', sql.NVarChar, email)
            .input('passwordHash', sql.NVarChar, hashedPassword)
            .query(`
                INSERT INTO Users (username, email, passwordHash) 
                OUTPUT INSERTED.userId, INSERTED.username, INSERTED.email 
                VALUES (@username, @email, @passwordHash)
            `);

        console.log('User inserted successfully.');

        // Create JWT token
        console.log('Creating JWT token...');
        const token = jwt.sign(
            { userId: newUser.userId },
            jwtSecret,
            { expiresIn: '2h' }
        );
        
        console.log('JWT token created successfully.');

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
        console.log('Registration successful.');
    } catch (error) {
        handleError(error, res, 'Error during registration');
    } 
};

/**
 * (POST) Authenticate user and get token
 */
exports.login = async (req, res) => {
    const { email, password } = req.body;

    // Validate required fields
    if (!validateFields(req, res, ['email', 'password'])) return;

    try {
        const pool = await connectToDatabase();

        // Find user by email
        console.log(`Searching for user with email: ${email}`);
        const userResult = await pool.request()
            .input('email', sql.NVarChar, email)
            .query('SELECT userId, username, email, passwordHash FROM Users WHERE email = @email');

        if (userResult.recordset.length === 0) {
            console.warn(`Login failed: User not found with email ${email}`);
            return res.status(400).json({ message: 'Invalid credentials' }); // Generic message to prevent email enumeration
        }

        const user = userResult.recordset[0];
        console.log(`User found: ${user.username} (userId: ${user.userId})`);

        // Compare password
        console.log('Comparing provided password with stored hash...');
        const isMatch = await bcrypt.compare(password, user.passwordHash);
        if (!isMatch) {
            console.warn(`Login failed: Invalid password for email ${email}`);
            return res.status(400).json({ message: 'Invalid credentials' });
        }
        console.log('Password matched successfully.');

        // Create JWT token
        console.log('Creating JWT token...');
        const token = jwt.sign(
            { userId: user.userId },
            jwtSecret,
            { expiresIn: '2h' }
        );        

        console.log('JWT token created successfully.');

        // Respond with token and user details
        res.status(200).json({
            message: 'Login successful',
            token,
            user: {
                userId: user.userId,
                username: user.username,
                email: user.email,
            },
        });
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ message: 'Server error', error: error.message });
    } 
};
