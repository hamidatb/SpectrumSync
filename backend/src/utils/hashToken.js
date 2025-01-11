// utils/hashToken.js

const crypto = require('crypto');

/**
 * Hashes a token using SHA-256.
 * @param {string} token - The JWT token to be hashed.
 * @returns {string} The hashed token in hexadecimal format.
 */
function hashToken(token) {
    return crypto.createHash('sha256').update(token).digest('hex');
}

module.exports = { hashToken };