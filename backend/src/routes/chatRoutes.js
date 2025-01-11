// src/routes/chatRoutes.js

const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const authMiddleware = require('../middleware/authMiddleware');
const logger = require('../utils/logger');
const loggerMiddleware = require('../middleware/loggerMiddleware');

// Apply the logging middleware to all routes in this router
router.use(loggerMiddleware);

// Apply authentication middleware to all routes
router.use(authMiddleware);

/**
 * @route   POST /api/chats/create
 * @desc    Create a new chat (individual or group) with friends only
 * @access  Private
 *
 * Example Request:
 * POST /api/chats/create
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 *
 * Body (Individual Chat):
 * {
 *   "userIds": [2]  // One other user ID
 * }
 *
 * Body (Group Chat):
 * {
 *   "chatName": "Family Group",
 *   "userIds": [2, 3, 4]  // Multiple user IDs
 * }
 */
router.post('/create', (req, res, next) => {
    logger.log('POST /api/chats/create - Creating a new chat');
    chatController.createChat(req, res, next);
});

/**
 * @route   POST /api/chats/join/:chatId
 * @desc    Join a chat
 * @access  Private
 *
 * Example Request:
 * POST /api/chats/join/1
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 */
router.post('/join/:chatId', (req, res, next) => {
    logger.log(`POST /api/chats/join/${req.params.chatId} - Joining a chat`);
    chatController.joinChat(req, res, next);
});

/**
 * @route   POST /api/chats/leave/:chatId
 * @desc    Leave a chat
 * @access  Private
 *
 * Example Request:
 * POST /api/chats/leave/1
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 */
router.post('/leave/:chatId', (req, res, next) => {
    logger.log(`POST /api/chats/leave/${req.params.chatId} - Leaving a chat`);
    chatController.leaveChat(req, res, next);
});

/**
 * @route   POST /api/chats/message/:chatId
 * @desc    Send a message to a chat
 * @access  Private
 *
 * Example Request:
 * POST /api/chats/message/1
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 *
 * Body:
 * {
 *   "content": "Hello everyone!"
 * }
 */
router.post('/message/:chatId', (req, res, next) => {
    logger.log(`POST /api/chats/message/${req.params.chatId} - Sending a message`);
    chatController.sendMessage(req, res, next);
});

/**
 * @route   GET /api/chats
 * @desc    List all chats that the authenticated user is part of
 * @access  Private
 *
 * Example Request:
 * GET /api/chats
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 */
router.get('/', (req, res, next) => {
    logger.log(`GET /api/chats - Listing all chats for user ${req.user.userId}`);
    chatController.listAllChats(req, res, next);
});

/**
 * @route   GET /api/chats/:chatId/messages
 * @desc    Get the 20 most recent messages from a specific chat
 * @access  Private
 *
 * Example Request:
 * GET /api/chats/1/messages
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 */
router.get('/:chatId/messages', (req, res, next) => {
    const chatId = req.params.chatId;
    logger.log(`GET /api/chats/${chatId}/messages - Fetching recent messages`);
    chatController.getMostRecentChatMessages(req, res, next);
});


/**
 * @route   POST /api/chats/:chatId/invite
 * @desc    Send an invite link to a user to join a specific chat
 * @access  Private
 *
 * Example Request:
 * POST /api/chats/1/invite
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 *
 * Body:
 * {
 *   "inviteeUserId": 5
 * }
 */
router.post('/:chatId/invite', (req, res, next) => {
    const chatId = req.params.chatId;
    logger.log(`POST /api/chats/${chatId}/invite - Sending invite`);
    chatController.sendChatInvite(req, res, next);
});

/**
 * @route   GET /api/chats/invite/accept
 * @desc    Handle invite link clicks to join the chat
 * @access  Private (User must be authenticated)
 *
 * Example Request:
 * GET /api/chats/invite/accept?token=<invite_token>
 *
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 */
router.get('/invite/accept', (req, res, next) => {
    logger.log(`GET /api/chats/invite/accept - Accepting invite`);
    chatController.acceptChatInvite(req, res, next);
});
module.exports = router;
