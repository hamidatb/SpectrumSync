// utils/validationUtils.js

/**
 * Utility function to validate the presence of required fields in the request body.
 * @param {Object} req - The Express request object.
 * @param {Object} res - The Express response object.
 * @param {Array<string>} requiredFields - An array of required field names to check.
 * @returns {Boolean} - Returns true if all required fields are present, otherwise sends a 400 response.
 */
const validateFields = (req, res, requiredFields) => {
    const missingFields = requiredFields.filter(field => !req.body[field]);

    if (missingFields.length > 0) {
        console.warn('Missing required fields:', missingFields);
        res.status(400).json({
            message: `The following fields are required: ${missingFields.join(', ')}`,
        });
        return false;
    }

    return true;
};

/**
 * Utility function to validate the user ID from the authenticated request.
 * @param {Object} req - The Express request object.
 * @param {Object} res - The Express response object.
 * @returns {Boolean} - Returns true if userId is valid, otherwise sends a 401 response.
 */
const validateUserId = (req, res) => {
    const userId = req.user?.userId;
    if (!userId) {
        console.warn('User ID is missing from the request. Authorization failed.');
        res.status(401).json({ message: 'Unauthorized. Please log in again.' });
        return false;
    }
    return true;
};

/**
 * Utility function to validate the event ID from the request parameters.
 * @param {Object} req - The Express request object.
 * @param {Object} res - The Express response object.
 * @returns {Boolean} - Returns true if eventId is valid, otherwise sends a 400 response.
 */
const validateEventId = (req, res) => {
    const eventId = req.params?.id;
    if (!eventId) {
        console.warn('Event ID is missing from the request.');
        res.status(400).json({ message: 'Event ID is required.' });
        return false;
    }
    if (isNaN(parseInt(eventId, 10))) {
        console.warn('Invalid Event ID format:', eventId);
        res.status(400).json({ message: 'Event ID must be a valid number.' });
        return false;
    }
    return true;
};

/**
 * Utility function to validate the chat ID's existence from the request parameters.
 * @param {Object} req - The Express request object.
 * @param {Object} res - The Express response object.
 * @returns {Boolean} - Returns true if chatId is valid, otherwise sends a 400 response.
 */
const validateChatId = (req, res) => {
    const chatId = req.params?.chatId;
    if (!chatId) {
        console.warn('Chat ID is missing from the request.');
        res.status(400).json({ message: 'Chat ID is required.' });
        return false;
    }
    if (isNaN(parseInt(chatId, 10))) { // Corrected here
        console.warn('Invalid Chat ID format:', chatId); // And here
        res.status(400).json({ message: 'Chat ID must be a valid number.' });
        return false;
    }
    return true;
};

module.exports = {
    validateUserId,
    validateEventId,
    validateFields,
    validateChatId
};
