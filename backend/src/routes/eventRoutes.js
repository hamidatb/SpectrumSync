// routes/eventRoutes.js

const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const authMiddleware = require('../middleware/authMiddleware');
const logger = require('../utils/logger');
const loggerMiddleware = require('../middleware/loggerMiddleware');

// Apply the logging middleware to all routes in this router
router.use(loggerMiddleware);

// Protect all routes below with authentication middleware
router.use(authMiddleware);

/* Routing structure:
- Define routes from most to least specific to prevent accidental matches
- Define static routes (/invites, /) before dynamic routes (/:id) to prevent accidental matching
*/

// Static Routes

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
router.get('/invites', (req, res, next) => {
    logger.log('GET /api/events/invites - Fetching event invitations');
    eventController.getInvites(req, res, next);
});

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
router.post('/', (req, res, next) => {
    logger.log('POST /api/events - Creating a new event');
    eventController.createEvent(req, res, next);
});

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
router.get('/', (req, res, next) => {
    logger.log('GET /api/events - Fetching all events');
    eventController.getEvents(req, res, next);
});

// Dynamic Routes

// ROUTE: Get an event by ID 
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
router.get('/:id', (req, res, next) => {
    logger.log(`GET /api/events/${req.params.id} - Fetching event details`);
    eventController.getEventById(req, res, next);
});

// ROUTE: Get an event by the date of the event 
/**
 * @route   GET /api/events/:date
 * @desc    Get event details by the date
 * @access  Private
 * 
 * Example Request:
 * GET /api/events/2025-04-01
 * 
 * Headers:
 * {
 *   "Authorization": "Bearer <your_token>"
 * }
 * 
 * No request body required.
 */
router.get('/:id', (req, res, next) => {
    logger.log(`GET /api/events/${req.params.date} - Fetching event details`);
    eventController.getEventsByDate(req, res, next);
});

// ROUTE: Update an event by ID
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
router.put('/:id', (req, res, next) => {
    logger.log(`PUT /api/events/${req.params.id} - Updating event`);
    eventController.updateEvent(req, res, next);
});

// ROUTE: Delete an event by ID
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
router.delete('/:id', (req, res, next) => {
    logger.log(`DELETE /api/events/${req.params.id} - Deleting event`);
    eventController.deleteEvent(req, res, next);
});

// ROUTE: Share an event by ID
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
router.post('/:id/share', (req, res, next) => {
    logger.log(`POST /api/events/${req.params.id}/share - Sharing event`);
    eventController.shareEvent(req, res, next);
});

// ROUTE: RSVP attedance status to an event by ID
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
 * {
 *   "status": "Not Attending" // Allowed values: "Attending", "Not Attending"
 * }
 */
router.post('/:id/attend', (req, res, next) => {
    logger.log(`POST /api/events/${req.params.id}/attend - RSVP to event`);
    eventController.attendEvent(req, res, next);
});

module.exports = router;