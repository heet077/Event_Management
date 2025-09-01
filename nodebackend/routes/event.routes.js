import express from 'express';
import * as Event from '../controllers/event.controller.js';
import upload from '../middlewares/upload.js';

const router = express.Router();

// Get all events
router.post('/getAll', Event.getEvents);

// Get event by ID
router.post('/getById', Event.getEvent);

// Create event with optional cover image upload
router.post('/create', upload.single('cover_image'), Event.createEvent);

// Update event with optional cover image upload
router.post('/update', upload.single('cover_image'), Event.updateEvent);

// Delete event
router.post('/delete', Event.deleteEvent);

// Get event details
router.post('/getDetails', Event.getEventDetails);

export default router;
