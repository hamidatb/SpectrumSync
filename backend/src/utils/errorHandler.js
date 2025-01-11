// utils/errorHandler.js
const logger = require('./logger');

/**
 * Utility function to handle errors in async routes.
 * Logs the error details and sends a standardized JSON response to the client.
 * @param {Error} error - The error object.
 * @param {Response} res - The response object from Express.
 * @param {String} customMessage - Optional custom message to include in the response.
 */
function handleError(error, res, customMessage = 'Server error') {
    // Log error details for debugging purposes
    logger.error(`Error occurred: ${error.message}`);
    logger.error(`Stack Trace: ${error.stack}`);

    // Determine appropriate status code
    const statusCode = error.statusCode || 500;

    // Send standardized error response to the client
    res.status(statusCode).json({
        message: customMessage,
        error: error.message
    });
}

module.exports = handleError;