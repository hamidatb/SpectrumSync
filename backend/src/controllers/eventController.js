// src/controllers/eventController.js

const sql = require('mssql');
const Event = require('../models/Event');
require('dotenv').config();

// Configure SQL Server connection
const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER, // e.g., 'your_server.database.windows.net'
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT, 10),
    options: {
        encrypt: true, // Use this if you're on Windows Azure
    },
};

// Create a new event
exports.createEvent = async (req, res) => {
    const { title, description, date, location } = req.body;

    // Basic validation
    if (!title || !date || !location) {
        return res.status(400).json({ message: 'Please enter all required fields' });
    }

    try {
        // Connect to the database
        await sql.connect(config);

        // Insert new event
        const insertResult = await sql.query`
            INSERT INTO Events (title, description, date, location, userId)
            VALUES (${title}, ${description || null}, ${date}, ${location}, ${req.user.id})
        `;

        res.status(201).json({ message: 'Event created successfully' });
    } catch (error) {
        console.error('Error creating event:', error);
        res.status(500).json({ message: 'Server error' });
    } finally {
        // Close the SQL connection
        await sql.close();
    }
};

// Get all events for a user
exports.getEvents = async (req, res) => {
    try {
        // Connect to the database
        await sql.connect(config);

        // Retrieve events
        const result = await sql.query`
            SELECT * FROM Events WHERE userId = ${req.user.id} ORDER BY date ASC
        `;

        res.status(200).json(result.recordset);
    } catch (error) {
        console.error('Error fetching events:', error);
        res.status(500).json({ message: 'Server error' });
    } finally {
        // Close the SQL connection
        await sql.close();
    }
};
