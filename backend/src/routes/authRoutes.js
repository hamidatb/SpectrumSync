// routes/authRoutes.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const logger = require('../utils/logger');
const loggerMiddleware = require('../middleware/loggerMiddleware');

/**  
 * Apply the logging middleware to all routes in this router */
router.use(loggerMiddleware);

/**
 * @route   POST /api/auth/register
 * @desc    Register a new user
 * @access  Public
 * 
 * Example Request:
 * POST /api/auth/register
 * 
 * Headers:
 * {
 *   "Content-Type": "application/json"
 * }
 * 
 * Body:
 * {
 *   "username": "john_doe",
 *   "email": "john@example.com",
 *   "password": "SecureP@ssw0rd!"
 * }
 */
router.post('/register', (req, res, next) => {
    logger.log('POST /api/auth/register - User registration attempt');
    authController.register(req, res, next);
});

/**
 * @route   POST /api/auth/login
 * @desc    Authenticate user and get a token
 * @access  Public
 * 
 * Example Request:
 * POST /api/auth/login
 * 
 * Headers:
 * {
 *   "Content-Type": "application/json"
 * }
 * 
 * Body:
 * {
 *   "email": "john@example.com",
 *   "password": "SecureP@ssw0rd!"
 * }
 */
router.post('/login', (req, res, next) => {
    logger.log('POST /api/auth/login - User login attempt');
    authController.login(req, res, next);
});

/**
 * @route   POST /api/auth/logout
 * @desc    Log out the user and invalidate their token
 * @access  Private
 * 
 * Example Request:
 * POST /api/auth/logout
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 * 
 * No request body required.
 */
router.post('/logout', (req, res, next) => {
    logger.log('POST /api/auth/logout - User logout attempt');
    authController.logout(req, res, next);
});

module.exports = router;
