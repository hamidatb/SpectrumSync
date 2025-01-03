// src/controllers/authController.js

const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const sql = require('mssql');
const User = require('../models/User');
require('dotenv').config();

// Configure SQL Server connection
// These are in the .env
const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER, 
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT, 10),
};

// Register a new user
exports.register = async (req, res) => {
    const { username, email, password } = req.body;

    // Basic validation
    if (!username || !email || !password) {
        return res.status(400).json({ message: 'Please enter all fields' });
    }

    try {
        // Connect to the database
        await sql.connect(config);

        // Check if user already exists
        const result = await sql.query`SELECT * FROM Users WHERE email = ${email}`;
        if (result.recordset.length > 0) {
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Insert new user
        const insertResult = await sql.query`
            INSERT INTO Users (username, email, password)
            VALUES (${username}, ${email}, ${hashedPassword})
        `;

        // Retrieve the inserted user
        const userResult = await sql.query`SELECT * FROM Users WHERE email = ${email}`;
        const user = userResult.recordset[0];

        // Create JWT token
        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

        res.status(201).json({
            token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
            },
        });
    } catch (error) {
        console.error('Error during registration:', error);
        res.status(500).json({ message: 'Server error' });
    } finally {
        // Close the SQL connection
        await sql.close();
    }
};

// Login user
exports.login = async (req, res) => {
    const { email, password } = req.body;

    // Basic validation
    if (!email || !password) {
        return res.status(400).json({ message: 'Please enter all fields' });
    }

    try {
        // Connect to the database
        await sql.connect(config);

        // Find user by email
        const result = await sql.query`SELECT * FROM Users WHERE email = ${email}`;
        if (result.recordset.length === 0) {
            return res.status(400).json({ message: 'User does not exist' });
        }

        const user = result.recordset[0];

        // Compare password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ message: 'Invalid credentials' });

        // Create JWT token
        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

        res.json({
            token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email,
            },
        });
    } catch (error) {
        console.error('Error during login:', error);
        res.status(500).json({ message: 'Server error' });
    } finally {
        // Close the SQL connection
        await sql.close();
    }
};
