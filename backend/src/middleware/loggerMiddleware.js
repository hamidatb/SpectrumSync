// middleware/loggerMiddleware.js
const logger = require('../utils/logger');

const loggerMiddleware = (req, res, next) => {
    logger.log(`Incoming Request: ${req.method} ${req.originalUrl}`);
    next();
};

module.exports = loggerMiddleware;
