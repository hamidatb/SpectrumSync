// src/controllers/authController.js

const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { CosmosClient } = require('@azure/cosmos');
const User = require('../models/User');
require('dotenv').config();

// Initialize Cosmos DB client
const client = new CosmosClient({
    endpoint: process.env.COSMOS_DB_ENDPOINT,
    key: process.env.COSMOS_DB_KEY
});

const database = client.database(process.env.COSMOS_DB_DATABASE);
const container = database.container(process.env.COSMOS_DB_CONTAINER);

// Register a new user
exports.register = async (req, res) => {
    const { username, email, password } = req.body;

    // Basic validation
    if (!username || !email || !password) {
        return res.status(400).json({ message: 'Please enter all fields' });
    }

    try {
        // Check if user already exists
        const { resources } = await container.items
            .query(`SELECT * FROM Users u WHERE u.email = "${email}"`)
            .fetchAll();

        if (resources.length > 0) {
            return res.status(400).json({ message: 'User already exists' });
        }

        // Hash password
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // Create new user
        const newUser = new User(`${Date.now()}`, username, email, hashedPassword);
        await container.items.create(newUser);

        // Create JWT token
        const token = jwt.sign({ id: newUser.id }, process.env.JWT_SECRET, { expiresIn: 3600 });

        res.status(201).json({
            token,
            user: {
                id: newUser.id,
                username: newUser.username,
                email: newUser.email
            }
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
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
        // Find user by email
        const { resources } = await container.items
            .query(`SELECT * FROM Users u WHERE u.email = "${email}"`)
            .fetchAll();

        if (resources.length === 0) {
            return res.status(400).json({ message: 'User does not exist' });
        }

        const user = resources[0];

        // Compare password
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) return res.status(400).json({ message: 'Invalid credentials' });

        // Create JWT token
        const token = jwt.sign({ id: user.id }, process.env.JWT_SECRET, { expiresIn: 3600 });

        res.json({
            token,
            user: {
                id: user.id,
                username: user.username,
                email: user.email
            }
        });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
};
