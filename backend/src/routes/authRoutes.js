const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

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
router.post('/register', authController.register);

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
router.post('/login', authController.login);

module.exports = router;
