const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const authMiddleware = require('../middleware/authMiddleware');

// Protect all routes below
router.use(authMiddleware);

// define routes from most to least specific to prevent accidental matches
/**
 * @route   GET /api/events/:id
 * @desc    Get event details by ID
 * @access  Private
 * 
 * Example Request:
 * GET /api/events/1
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 * 
 * No request body required.
 */
router.get('/:id', eventController.getEventById);

/**
 * @route   PUT /api/events/:id
 * @desc    Edit an event by ID
 * @access  Private
 * 
 * Example Request:
 * PUT /api/events/1
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 * 
 * Body:
 * {
 *   "title": "Updated Team Meeting",
 *   "description": "Monthly sync-up with the team - Updated",
 *   "date": "2025-01-20T15:00:00Z",
 *   "location": "Google Meet"
 * }
 */
router.put('/:id', eventController.updateEvent);

/**
 * @route   DELETE /api/events/:id
 * @desc    Delete an event by ID
 * @access  Private
 * 
 * Example Request:
 * DELETE /api/events/1
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 * 
 * No request body required.
 */
router.delete('/:id', eventController.deleteEvent);

/**
 * @route   POST /api/events/:id/share
 * @desc    Share an event with other users
 * @access  Private
 * 
 * Example Request:
 * POST /api/events/1/share
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 * 
 * Body:
 * {
 *   "email": "example@example.com"
 * }
 */
router.post('/:id/share', eventController.shareEvent);

/**
 * @route   POST /api/events/:id/attend
 * @desc    RSVP to an event
 * @access  Private
 * 
 * Example Request:
 * POST /api/events/1/attend
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 * 
 * No request body required.
 */
router.post('/:id/attend', eventController.attendEvent);

/**
 * @route   GET /api/events/invites
 * @desc    Get event invitations for the authenticated user
 * @access  Private
 * 
 * Example Request:
 * GET /api/events/invites
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 * 
 * No request body required.
 */
router.get('/invites', eventController.getInvites);

/**
 * @route   POST /api/events
 * @desc    Create a new event
 * @access  Private
 * 
 * Example Request:
 * POST /api/events
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>",
 *   "Content-Type": "application/json"
 * }
 * 
 * Body:
 * {
 *   "title": "Team Meeting",
 *   "description": "Monthly sync-up with the team",
 *   "date": "2025-01-15T14:30:00Z",
 *   "location": "Zoom"
 * }
 */
router.post('/', eventController.createEvent);

/**
 * @route   GET /api/events
 * @desc    Get all events for the authenticated user
 * @access  Private
 * 
 * Example Request:
 * GET /api/events
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 * 
 * No request body required.
 */
router.get('/', eventController.getEvents);

module.exports = router;