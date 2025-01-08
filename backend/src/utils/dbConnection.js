// utils/dbConnection.js

const sql = require('mssql');
require('dotenv').config();

// Configure SQL Server connection
const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT, 10),
};

// Function to connect to the SQL server
const connectToDatabase = async () => {
    try {
        console.log('Connecting to SQL server...');
        const pool = await sql.connect(config);
        console.log('SQL server connected.');
        return pool;
    } catch (error) {
        console.error('Error connecting to the SQL server:', error);
        throw new Error('Database connection failed.');
    }
};

// Export the function for use in other files
module.exports = connectToDatabase;
