// src/controllers/chatController.js

const sql = require('mssql'); // SQL Server connection
const connectToDatabase = require('../utils/dbConnection');
const { validateFields, validateUserId, validateChatId } = require('../utils/validationUtils');
const logger = require('../utils/logger');
const handleError = require('../utils/errorHandler');
const Chat = require('../models/Chat');
const config = require('../config');

/**
 * (POST) Create a new chat (auto valid for friends)
 * Supports both individual and group chats
 */
exports.createChat = async (req, res, next) => {
    const { chatName, userIds } = req.body;
    const creatorId = req.user?.userId;

    // Validate user ID
    if (!validateUserId(req, res)) return;

    // Validate required body fields
    if (!validateFields(req, res, ['userIds'])) return;

    try {
        const pool = await connectToDatabase();

        // Check if user IDs are valid friends
        logger.log(`Checking if user IDs ${userIds} are valid friends of user ${creatorId}`);
        const isValid = await Chat.isValidFriend(pool, creatorId, userIds);

        if (!isValid) {
            logger.warn('Some user IDs are not valid friends.');
            return res.status(400).json({ message: 'Some user IDs are not valid friends.' });
        }

        // Create the chat
        logger.log('Creating new chat');
        const isGroupChat = userIds.length > 1;
        const chat = await Chat.create(pool, chatName, isGroupChat, creatorId);

        // Add members to the chat
        logger.log('Adding members to the chat');
        await Chat.addMembers(pool, chat.chatId, [creatorId, ...userIds]);

        res.status(201).json({ message: 'Chat created successfully', chatId: chat.chatId });
        logger.log('Chat creation process completed successfully.');
    } catch (error) {
        handleError(error, res, 'Error creating chat');
    }
};

/**
 * (POST) Join a chat
 */
exports.joinChat = async (req, res, next) => {
    const chatId = parseInt(req.params.chatId, 10);
    const userId = req.user?.userId;

    // Validate user ID
    if (!validateUserId(req, res)) return;
    // Validate chat ID
    if (!validateChatId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Check if the user is already a member
        logger.log(`Checking if user ${userId} is already a member of chat ${chatId}`);
        const isMember = await Chat.isMember(pool, chatId, userId);

        if (isMember) {
            logger.warn('User is already a member of this chat.');
            return res.status(400).json({ message: 'User is already a member of this chat.' });
        }

        // Add user to the chat
        logger.log('Adding user to the chat');
        await Chat.addMembers(pool, chatId, [userId]);

        res.status(200).json({ message: 'Joined chat successfully' });
        logger.log('User joined chat successfully.');
    } catch (error) {
        handleError(error, res, 'Error joining chat');
    }
};

/**
 * (POST) Leave a chat
 */
exports.leaveChat = async (req, res, next) => {
    const chatId = parseInt(req.params.chatId, 10);
    const userId = req.user?.userId;

    // Validate user ID
    if (!validateUserId(req, res)) return;
    // Validate chat ID
    if (!validateChatId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // TODO: Check if the user is even a member of the chat before removing them
        // Remove user from the chat 
        logger.log(`Removing user ${userId} from chat ${chatId}`);
        await Chat.removeMember(pool, chatId, userId);

        res.status(200).json({ message: 'Left chat successfully' });
        logger.log('User left chat successfully.');
    } catch (error) {
        handleError(error, res, 'Error leaving chat');
    }
};

/**
 * (POST) Send a message to a chat
 */
exports.sendMessage = async (req, res, next) => {
    const chatId = parseInt(req.params.chatId, 10);
    const userId = req.user?.userId;
    const { content } = req.body;

    // Validate user ID
    if (!validateUserId(req, res)) return;

    // Validate required fields
    if (!validateFields(req, res, ['content'])) return;

    // Validate chat ID
    if (!validateChatId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Ensure the user is a member of the chat before sending a message
        logger.log(`Verifying membership of user ${userId} in chat ${chatId}`);
        const isMember = await Chat.isMember(pool, chatId, userId);
        if (!isMember) {
            logger.warn('User is not a member of this chat.');
            return res.status(403).json({ message: 'User is not a member of this chat.' });
        }

        // Insert the message into the Messages table
        logger.log(`Inserting message into Messages table for chat ${chatId}`);
        const messageInsertResult = await pool.request()
            .input('chatId', sql.Int, chatId)
            .input('userId', sql.Int, userId)
            .input('content', sql.NVarChar, content)
            .query(`
                INSERT INTO Messages (chatId, userId, content)
                VALUES (@chatId, @userId, @content);
                SELECT SCOPE_IDENTITY() AS messageId;
            `);

        const messageId = messageInsertResult.recordset[0].messageId;
        logger.log(`Message sent successfully with messageId: ${messageId}`);

        res.status(201).json({ message: 'Message sent successfully', messageId });
    } catch (error) {
        handleError(error, res, 'Error sending message');
    }
};

/**
 * (GET) List all chats the authenticated user is part of
 */
exports.listAllChats = async (req, res, next) => {
    const userId = req.user?.userId;

    try {
        const pool = await connectToDatabase();

        // Fetch chats from the database
        logger.log(`Fetching all chats for user ${userId}`);
        const chats = await Chat.getChatsByUserId(pool, userId);

        res.status(200).json({ chats });
        logger.log(`Successfully retrieved ${chats.length} chats for user ${userId}`);
    } catch (error) {
        handleError(error, res, 'Error retrieving chats');
    }
};

/**
 * (GET) Get the 20 most recent messages from a specific chat
 */
exports.getMostRecentChatMessages = async (req, res, next) => {
    const userId = req.user?.userId;
    const chatId = parseInt(req.params.chatId, 10);

    if (!validateChatId(req, res)) return;
    if (!validateUserId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Verify that the user is a member of the chat
        logger.log(`Verifying membership of user ${userId} in chat ${chatId}`);
        const isMember = await Chat.isMember(pool, chatId, userId);
        if (!isMember) {
            logger.warn('User is not a member of this chat.');
            return res.status(403).json({ message: 'User is not a member of this chat.' });
        }

        // Fetch recent messages
        logger.log(`Fetching recent messages for chat ${chatId}`);
        const messages = await Chat.getRecentMessages(pool, chatId, 20);

        res.status(200).json({ messages });
        logger.log(`Successfully retrieved ${messages.length} messages for chat ${chatId}`);
    } catch (error) {
        handleError(error, res, 'Error retrieving messages');
    }
};

/**
 * (POST) Send a chat invite to a user (possibly not a friend)
 */
exports.sendChatInvite = async (req, res, next) => {
    const chatId = parseInt(req.params.chatId, 10);
    const { inviteeUserId } = req.body;
    const inviterUserId = req.user?.userId;

    // Validate input
    if (!validateUserId(req, res)) return;
    if (!validateChatId(req, res)) return;
    if (!inviteeUserId || typeof inviteeUserId !== 'number') {
        logger.warn('Invalid inviteeUserId');
        return res.status(400).json({ message: 'Invalid inviteeUserId' });
    }

    try {
        const pool = await connectToDatabase();

        // Verify that the inviter is a member of the chat
        logger.log(`Verifying membership of inviter ${inviterUserId} in chat ${chatId}`);
        const isMember = await Chat.isMember(pool, chatId, inviterUserId);
        if (!isMember) {
            logger.warn('Inviter is not a member of this chat.');
            return res.status(403).json({ message: 'You are not a member of this chat.' });
        }

        // Generate an invite token with expiry (e.g., 24 hours)
        const invitePayload = {
            chatId,
            inviteeUserId,
            inviterUserId,
        };
        const token = jwt.sign(invitePayload, config.JWT_SECRET_INVITE, { expiresIn: '24h' });

        // Generate invite link
        const inviteLink = `${config.BASE_URL}/api/chats/invite/accept?token=${token}`;

        // TODO: Send the invite link via email or in-app notification
        // Right now just return the link in the response
        logger.log(`Generated invite link for user ${inviteeUserId}: ${inviteLink}`);

        res.status(200).json({ message: 'Invite sent successfully', inviteLink });
    } catch (error) {
        handleError(error, res, 'Error sending chat invite');
    }
};

/**
 * (GET) Accept a chat invite via the invite link
 */
exports.acceptChatInvite = async (req, res, next) => {
    const { token } = req.query;
    const userId = req.user?.userId;

    if (!token) {
        logger.warn('No token provided in invite acceptance');
        return res.status(400).json({ message: 'Invite token is required.' });
    }

    try {
        // Verify and decode the token
        const decoded = jwt.verify(token, config.JWT_SECRET_INVITE);
        const { chatId, inviteeUserId, inviterUserId } = decoded;

        // Ensure that the inviteeUserId matches the authenticated user
        if (inviteeUserId !== userId) {
            logger.warn('Invite token does not match the authenticated user.');
            return res.status(403).json({ message: 'Invalid invite token.' });
        }

        const pool = await connectToDatabase();

        // Verify that the chat still exists
        logger.log(`Verifying existence of chat ${chatId}`);
        const chatExists = await Chat.doesChatExist(pool, chatId);
        if (!chatExists) {
            logger.warn('Chat does not exist.');
            return res.status(404).json({ message: 'Chat does not exist.' });
        }

        // Add the user to the chat
        logger.log(`Adding user ${userId} to chat ${chatId}`);
        await Chat.addMembers(pool, chatId, [userId]);

        res.status(200).json({ message: 'Successfully joined the chat.' });
        logger.log(`User ${userId} joined chat ${chatId} via invite.`);
    } catch (error) {
        if (error.name === 'TokenExpiredError') {
            logger.warn('Invite token has expired.');
            return res.status(400).json({ message: 'Invite link has expired.' });
        } else if (error.name === 'JsonWebTokenError') {
            logger.warn('Invalid invite token.');
            return res.status(400).json({ message: 'Invalid invite token.' });
        }
        handleError(error, res, 'Error accepting chat invite');
    }
};