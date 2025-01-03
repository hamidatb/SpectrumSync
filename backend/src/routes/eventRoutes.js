// src/routes/eventRoutes.js

const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const authMiddleware = require('../middleware/authMiddleware');

// Protect all routes below
router.use(authMiddleware);

// @route   POST /api/events
// @desc    Create a new event
// @access  Private
router.post('/', eventController.createEvent);

// @route   GET /api/events
// @desc    Get all events for the authenticated user
// @access  Private
router.get('/', eventController.getEvents);

module.exports = router;
