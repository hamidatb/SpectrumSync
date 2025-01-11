// src/routes/friendRoutes.js

const express = require('express');
const router = express.Router();
const friendController = require('../controllers/friendController');
const authMiddleware = require('../middleware/authMiddleware');
const logger = require('../utils/logger');
const loggerMiddleware = require('../middleware/loggerMiddleware');

// Apply the logging middleware to all routes in this router
router.use(loggerMiddleware);

// Apply authentication middleware to all routes
router.use(authMiddleware);

/**
 * @route   POST /api/friends/add
 * @desc    Add a friend
 * @access  Private
 *
 * Example Request:
 * POST /api/friends/add
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 *
 * Body:
 * {
 *   "friendUserId": 2
 * }
 */
router.post('/add', (req, res, next) => {
    logger.log('POST /api/friends/add - Adding a new friend');
    friendController.addFriend(req, res, next);
});

/**
 * @route   POST /api/friends/remove
 * @desc    Remove a friend
 * @access  Private
 *
 * Example Request:
 * POST /api/friends/remove
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 *
 * Body:
 * {
 *   "friendUserId": 2
 * }
 */
router.post('/remove', (req, res, next) => {
    logger.log('POST /api/friends/remove - Removing a friend');
    friendController.removeFriend(req, res, next);
});

/**
 * @route   GET /api/friends/list
 * @desc    Get the authenticated user's friends list
 * @access  Private
 *
 * Example Request:
 * GET /api/friends/list
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 *
 * Response:
 * {
 *   "friends": [2, 3, 4]
 * }
 */
router.get('/list', (req, res, next) => {
    logger.log('GET /api/friends/list - Retrieving friends list');
    friendController.getFriendsList(req, res, next);
});

module.exports = router;