// src/controllers/friendController.js

const sql = require('mssql'); // SQL Server connection
const connectToDatabase = require('../utils/dbConnection');
const handleError = require('../utils/errorHandler');
const { validateFields, validateUserId } = require('../utils/validationUtils');
const logger = require('../utils/logger');
const Friend = require('../models/Friend');

/**
 * (POST) Add a friend
 */
exports.addFriend = async (req, res) => {
    const { friendUserId } = req.body;
    const userId = req.user.userId;

    // Validate required fields
    if (!validateFields(req, res, ['friendUserId'])) return;
    if (!validateUserId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Check if the friendship already exists
        logger.log(`Checking if friendship already exists between user ${userId} and ${friendUserId}`);
        const alreadyFriends = await Friend.isFriend(pool, userId, friendUserId);

        if (alreadyFriends) {
            logger.warn(`Friendship already exists between user ${userId} and ${friendUserId}`);
            return res.status(400).json({ message: 'Friendship already exists' });
        }

        // Add the new friendship
        logger.log(`Adding friendship between user ${userId} and ${friendUserId}`);
        await Friend.addFriend(pool, userId, friendUserId);

        logger.log(`Friendship added successfully between user ${userId} and ${friendUserId}`);
        res.status(201).json({ message: 'Friend added successfully' });
    } catch (error) {
        handleError(error, res, 'Error adding friend');
    }
};

/**
 * (POST) Remove a friend
 */
exports.removeFriend = async (req, res) => {
    const { friendUserId } = req.body;
    const userId = req.user.userId;

    // Validate required fields
    if (!validateFields(req, res, ['friendUserId'])) return;
    if (!validateUserId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Check if the friendship exists
        logger.log(`Checking if friendship exists between user ${userId} and ${friendUserId}`);
        const isFriend = await Friend.isFriend(pool, userId, friendUserId);

        if (!isFriend) {
            logger.warn(`No friendship found between user ${userId} and ${friendUserId}`);
            return res.status(404).json({ message: 'Friend not found' });
        }

        // Remove the friendship
        logger.log(`Removing friendship between user ${userId} and ${friendUserId}`);
        await Friend.removeFriend(pool, userId, friendUserId);

        logger.log(`Friendship removed successfully between user ${userId} and ${friendUserId}`);
        res.status(200).json({ message: 'Friend removed successfully' });
    } catch (error) {
        handleError(error, res, 'Error removing friend');
    }
};

/**
 * (GET) Get friends list
 */
exports.getFriendsList = async (req, res) => {
    const userId = req.user.userId;

    // Validate user ID
    if (!validateUserId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Retrieve friends list
        logger.log(`Retrieving friends list for user ${userId}`);
        const friendsList = await Friend.getFriendsList(pool, userId);

        res.status(200).json({ friends: friendsList });
        logger.log(`Friends list retrieved successfully for user ${userId}`);
    } catch (error) {
        handleError(error, res, 'Error retrieving friends list');
    }
};