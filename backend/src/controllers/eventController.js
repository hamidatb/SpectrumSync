// controllers/eventController.js

const sql = require('mssql');
const connectToDatabase = require('../utils/dbConnection');
const { validateUserId, validateEventId, validateFields } = require('../utils/validationUtils');
const handleError = require('../utils/errorHandler');
const { ATTENDEE_STATUS } = require('../utils/constants');
const logger = require('../utils/logger'); 

/**
 * (POST) Create a new event
 */
exports.createEvent = async (req, res, next) => {
    const { title, description, date, location, withWho } = req.body;
    const userId = req.user.userId;

    logger.log(`Received request to create a new event: { title: ${title}, description: ${description}, date: ${date}, location: ${location} }`);

    if (!validateUserId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Insert new event
        const insertResult = await pool.request()
            .input('title', sql.NVarChar, title)
            .input('description', sql.NVarChar, description || null)
            .input('date', sql.DateTime, date)
            .input('location', sql.NVarChar, location && location.trim() !== '' ? location.trim() : null)
            .input('userId', sql.Int, userId)
            .input('withWho', sql.NVarChar, Array.isArray(withWho) ? withWho.join(',') : withWho || null)
            .query(`
                INSERT INTO Events (title, description, date, location, userId, withWho) 
                VALUES (@title, @description, @date, @location, @userId, @withWho);
        
                SELECT * FROM Events WHERE eventId = SCOPE_IDENTITY();
            `);

        const newEvent = insertResult.recordset[0];
        logger.log(`Event inserted successfully: ${JSON.stringify(newEvent)}`);

        // Return the inserted event details
        res.status(201).json({
            message: 'Event created successfully',
            event: newEvent
        });
    } catch (error) {
        handleError(error, res, 'Error creating event');
    }
};

/**
 * (GET) Retrieve all events for a user 
 */
exports.getEvents = async (req, res, next) => {    
    if (!validateUserId(req, res)) return;

    const userId = req.user.userId;
    logger.log(`Received request to fetch events for userId: ${userId}`);

    try {
        const pool = await connectToDatabase();

        logger.log('Fetching events from the database...');
        const result = await pool.request()
            .input('userId', sql.Int, userId)
            .query('SELECT * FROM Events WHERE userId = @userId ORDER BY date ASC');
        

        // Make sure the withWho param is sent over as a LIST
        const events = result.recordset.map(event => {
            let withWhoArray = [];

            if (event.withWho && event.withWho !== 'N/A') {
                withWhoArray = event.withWho
                .split(',')
                .map(person => person.trim())
                .filter(person => person.length > 0);
            }
            return {
                ...event,
                withWho: withWhoArray
            };
        });
        logger.log(`Events fetched successfully: ${JSON.stringify(events)}`);
        res.status(200).json(events);
    } catch (error) {
        handleError(error, res, 'Error fetching events');
    }
};

/**
 * (GET) Retrieve event details by id
 */
exports.getEventById = async (req, res, next) => {
    if (!validateUserId(req, res)) return;
    if (!validateEventId(req, res)) return;
    
    const userId = req.user.userId;
    const eventId = req.params.id;
    logger.log(`Received request to get event details: { eventId: ${eventId}, userId: ${userId} }`);

    try {
        const pool = await connectToDatabase();

        const eventDetails = await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('userId', sql.Int, userId)
            .query(
                'SELECT * FROM Events WHERE eventId = @eventId AND userId = @userId'
            );
        
        if (eventDetails.recordset.length === 0) {
            logger.warn(`No event found for the provided ID: ${eventId}`);
            return res.status(404).json({ message: 'Event not found.' });
        }

        logger.log(`Event details retrieved successfully: ${JSON.stringify(eventDetails.recordset[0])}`);
        res.status(200).json({
            message: 'Event details retrieved successfully',
            event: eventDetails.recordset[0],
        });
    } catch (error){
        handleError(error, res, 'Error retrieving event details');
    }
};

/**
 * (GET) Get the events of a specific day
 */
exports.getEventsByDate = async (req, res, next) => {    
    if (!validateUserId(req, res)) return;

    const userId = req.user.userId;
    const date = req.params.date; // I have to send ?date=2025-05-01

    logger.log(`Received request to fetch events on ${date} for userId: ${userId}`);

    try {
        const pool = await connectToDatabase();

        logger.log('Fetching events from the database...');
        const result = await pool.request()
            .input('userId', sql.Int, userId)
            // Note: The way I'm casting date here does mean I can't do indexing on this after 
            .query("SELECT * FROM Events WHERE userId = @userId AND CAST(date AS DATE) = @date ORDER BY date ASC;");
        

        const events = result.recordset.map(event => {
            let withWhoArray = [];

            if (event.withWho && event.withWho !== 'N/A') {
                withWhoArray = event.withWho
                .split(',')
                .map(person => person.trim())
                .filter(person => person.length > 0);
            }
            return {
                ...event,
                withWho: withWhoArray
            };
        });
        logger.log(`Events fetched successfully: ${JSON.stringify(events)}`);
        res.status(200).json(events);
    } catch (error) {
        handleError(error, res, 'Error fetching events');
    }
};


/**
 * (PUT) Edit an event by ID
 */
exports.updateEvent = async (req, res, next) => {
    const { title, description, date, location, withWho } = req.body;
    const userId = req.user.userId;
    const eventId = req.params.id;

    logger.log(`Received request to edit event: { eventId: ${eventId}, userId: ${userId}, title: ${title}, description: ${description}, date: ${date}, location: ${location} }`);

    // Validate required fields
    if (!validateFields(req, res, ['title', 'date', 'location'])) return;
    if (!validateUserId(req, res)) return;
    if (!validateEventId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Check if the event exists and belongs to the user
        const eventCheck = await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('userId', sql.Int, userId)
            .query('SELECT * FROM Events WHERE eventId = @eventId AND userId = @userId');
        
        if (eventCheck.recordset.length === 0){
            logger.warn(`No event found for the provided ID: ${eventId}`);
            return res.status(404).json({ message: 'Event not found.' });
        }

        // Update the event
        const updateResult = await pool.request()
            .input('title', sql.NVarChar, title)
            .input('description', sql.NVarChar, description || null)
            .input('date', sql.DateTime, date)
            .input('location', sql.NVarChar, location && location.trim() !== '' ? location.trim() : null)
            .input('eventId', sql.Int, eventId)
            .input('withWho', sql.NVarChar, Array.isArray(withWho) ? withWho.join(',') : withWho || null)
            .query(`
                UPDATE Events
                SET title = @title, description = @description, date = @date, location = @location, withWho = @withWho
                WHERE eventId = @eventId;
        
                SELECT * FROM Events WHERE eventId = @eventId;
            `);

        const updatedEvent = updateResult.recordset[0];
        logger.log(`Event updated successfully: ${JSON.stringify(updatedEvent)}`);

        res.status(200).json({
            message: 'Event updated successfully',
            event: updatedEvent
        });
    } catch (error) {
        handleError(error, res, 'Error editing event');
    }
};

/**
 * (DELETE) Delete an event by ID
 */
exports.deleteEvent = async (req, res, next) => {
    const userId = req.user.userId;
    const eventId = req.params.id;

    logger.log(`Received request to delete event: { eventId: ${eventId}, userId: ${userId} }`);

    if (!validateUserId(req, res)) return;
    if (!validateEventId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Check if the event exists and belongs to the user
        const eventCheck = await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('userId', sql.Int, userId)
            .query('SELECT * FROM Events WHERE eventId = @eventId AND userId = @userId');

        if (eventCheck.recordset.length === 0){
            logger.warn(`No event found for the provided ID: ${eventId}`);
            return res.status(404).json({ message: 'Event not found.' });
        }

        // Delete the event
        await pool.request()
            .input('eventId', sql.Int, eventId)
            .query('DELETE FROM Events WHERE eventId = @eventId');

        logger.log(`Event deleted successfully: ${eventId}`);
        res.status(200).json({ message: 'Event deleted successfully.' });
    } catch (error) {
        handleError(error, res, 'Error deleting event');
    }
};

/**
 * (POST) Share an event with other users
 */
exports.shareEvent = async (req, res, next) => {
    const { email } = req.body;
    const userId = req.user.userId;
    const eventId = req.params.id;

    logger.log(`Received request to share event: { eventId: ${eventId}, userId: ${userId}, email: ${email} }`);

    // Validate required fields
    if (!validateFields(req, res, ['email'])) return;
    if (!validateUserId(req, res)) return;
    if (!validateEventId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Check if the event exists and belongs to the user
        const eventCheck = await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('userId', sql.Int, userId)
            .query('SELECT * FROM Events WHERE eventId = @eventId AND userId = @userId');

        if (eventCheck.recordset.length === 0){
            logger.warn(`No event found for the provided ID: ${eventId}`);
            return res.status(404).json({ message: 'Event not found.' });
        }

        // Find the user to share with by email
        const userResult = await pool.request()
            .input('email', sql.NVarChar, email)
            .query('SELECT userId FROM Users WHERE email = @email');


        if (userResult.recordset.length === 0){
            logger.warn(`No user found with the provided email: ${email}`);
            return res.status(404).json({ message: 'User to share with not found.' });
        }

        const sharedUserId = userResult.recordset[0].userId;

        // Check if the event is already shared with the user
        const shareCheck = await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('sharedUserId', sql.Int, sharedUserId)
            .query('SELECT * FROM EventAttendees WHERE eventId = @eventId AND userId = @sharedUserId');

        if (shareCheck.recordset.length > 0){
            logger.warn(`Event already shared with user: ${email}`);
            return res.status(400).json({ message: 'Event already shared with this user.' });
        }

        // Share the event by adding to EventAttendees with status 'Pending'
        await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('sharedUserId', sql.Int, sharedUserId)
            .query('INSERT INTO EventAttendees (eventId, userId, status) VALUES (@eventId, @sharedUserId, \'Pending\')');

        logger.log(`Event ${eventId} shared with user ID ${sharedUserId} (${email}) successfully.`);
        res.status(200).json({ message: 'Event shared successfully.' });
    } catch (error) {
        handleError(error, res, 'Error sharing event');
    }
};

/**
 * (POST) RSVP to an event
 */
exports.attendEvent = async (req, res, next) => {
    const userId = req.user.userId;
    const eventId = req.params.id;
    const { status } = req.body; // Expecting 'Attending' or 'Not Attending'

    logger.log(`Received request to RSVP to event: { eventId: ${eventId}, userId: ${userId}, status: ${status} }`);

    // Validate user and event IDs
    if (!validateUserId(req, res)) return;
    if (!validateEventId(req, res)) return;

    // Validate status
    if (!status || !Object.values(ATTENDEE_STATUS).includes(status)) {
        logger.warn(`Invalid RSVP status provided: ${status}`);
        return res.status(400).json({ message: 'Invalid RSVP status. Allowed values are "Attending" and "Not Attending".' });
    }

    try {
        const pool = await connectToDatabase();

        // Check if the event exists
        const eventCheck = await pool.request()
            .input('eventId', sql.Int, eventId)
            .query('SELECT * FROM Events WHERE eventId = @eventId');

        if (eventCheck.recordset.length === 0){
            logger.warn(`No event found for the provided ID: ${eventId}`);
            return res.status(404).json({ message: 'Event not found.' });
        }

        // Check if the user is already an attendee
        const attendeeCheck = await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('userId', sql.Int, userId)
            .query('SELECT * FROM EventAttendees WHERE eventId = @eventId AND userId = @userId');

        if (attendeeCheck.recordset.length > 0){
            const currentStatus = attendeeCheck.recordset[0].status;
            if (currentStatus === ATTENDEE_STATUS.ATTENDING || currentStatus === ATTENDEE_STATUS.NOT_ATTENDING){
                logger.warn(`User has already RSVPed to the event: ${eventId} with status: ${currentStatus}`);
                return res.status(400).json({ message: `You have already RSVPed as "${currentStatus}".` });
            } else if (currentStatus === ATTENDEE_STATUS.PENDING){
                // Update status to the new value
                await pool.request()
                    .input('eventId', sql.Int, eventId)
                    .input('userId', sql.Int, userId)
                    .input('status', sql.NVarChar, status)
                    .query('UPDATE EventAttendees SET status = @status WHERE eventId = @eventId AND userId = @userId');

                logger.log(`User ${userId} updated RSVP to "${status}" for event ${eventId} successfully.`);
                return res.status(200).json({ message: `RSVP updated to "${status}".` });
            }
        }

        // If not already an attendee, add with the specified status
        await pool.request()
            .input('eventId', sql.Int, eventId)
            .input('userId', sql.Int, userId)
            .input('status', sql.NVarChar, status)
            .query('INSERT INTO EventAttendees (eventId, userId, status) VALUES (@eventId, @userId, @status)');

        logger.log(`User ${userId} RSVPed as "${status}" to event ${eventId} successfully.`);
        res.status(200).json({ message: `RSVP as "${status}" successful.` });
    } catch (error) {
        handleError(error, res, 'Error RSVPing to event');
    }
};

/**
 * (GET) Get all event invitations for the authenticated user
 */
exports.getInvites = async (req, res, next) => {
    const userId = req.user.userId;

    logger.log(`Received request to get all invitation details for userId: ${userId}`);

    // Validate user ID
    if (!validateUserId(req, res)) return;

    try {
        const pool = await connectToDatabase();

        // Retrieve invitations (shared events with status 'Pending')
        const invitesResult = await pool.request()
            .input('userId', sql.Int, userId)
            .input('status', sql.NVarChar, ATTENDEE_STATUS.PENDING)
            .query(`
                SELECT 
                    E.eventId as eventId, 
                    E.title, 
                    E.description, 
                    E.date, 
                    E.location, 
                    U.userId as ownerId, 
                    U.email as ownerEmail
                FROM EventAttendees EA
                JOIN Events E ON EA.eventId = E.eventId
                JOIN Users U ON E.userId = U.userId
                WHERE EA.userId = @userId AND EA.status = @status
                ORDER BY E.date ASC
            `);

        logger.log(`Fetched ${invitesResult.recordset.length} invitation(s) successfully.`);
        res.status(200).json({
            message: 'Invitations retrieved successfully',
            invitations: invitesResult.recordset
        });
    } catch (error) {
        handleError(error, res, 'Error fetching invitations');
    }
};