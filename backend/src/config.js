// src/config.js

// Not using dotenv since this code replies on the Azure side environment variables.

module.exports = {
    JWT_SECRET_AUTH: process.env.JWT_SECRET_AUTH,     // For authentication tokens
    JWT_SECRET_INVITE: process.env.JWT_SECRET_INVITE, // For invite tokens
    BASE_URL: process.env.BASE_URL,
};