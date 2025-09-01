import * as Event from '../models/event.model.js';
import * as Gallery from '../models/gallery.model.js';
import * as Cost from '../models/cost.model.js';
import * as Issuance from '../models/issuance.model.js';
import fs from 'fs';
import path from 'path';

export const getEvents = async (req, res, next) => {
  try {
    const data = await Event.getAllEvents();
    res.json({
      success: true,
      message: 'Events retrieved successfully',
      data: data,
      count: data.length
    });
  } catch (err) {
    next(err);
  }
};

export const getEvent = async (req, res, next) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Event ID is required',
        details: [{ field: 'id', message: 'Event ID is required in request body' }]
      });
    }
    
    const data = await Event.getEventById(id);
    if (!data) {
      return res.status(404).json({
        success: false,
        message: 'Event not found',
        details: [{ field: 'id', message: `Event with ID ${id} does not exist` }]
      });
    }
    
    res.json({
      success: true,
      message: 'Event retrieved successfully',
      data: data
    });
  } catch (err) {
    next(err);
  }
};

export const createEvent = async (req, res, next) => {
  try {
    console.log('🎯 Creating new event...');
    console.log('📋 Request body:', req.body);
    console.log('📁 File uploaded:', req.file ? 'Yes' : 'No');
    
    let coverImageUrl = req.body.cover_image;
    
    // Handle file upload if present
    if (req.file) {
      console.log(`🖼️ Processing cover image upload to local storage...`);
      
      // Create event first to get the ID
      const eventData = {
        ...req.body,
        cover_image: null // We'll update this after moving the file
      };
      
      const event = await Event.createEvent(eventData);
      console.log(`✅ Event created with ID: ${event.id}`);
      
      // Create event-specific folder
      const eventDir = path.join('uploads', 'events', event.id.toString());
      if (!fs.existsSync(eventDir)) {
        fs.mkdirSync(eventDir, { recursive: true });
      }
      
      // Move the uploaded file to the event folder with proper naming
      const oldPath = req.file.path;
      const ext = path.extname(req.file.originalname);
      const newFileName = `cover_image_${event.id}${ext}`;
      const newPath = path.join(eventDir, newFileName);
      
      // Move the file
      fs.renameSync(oldPath, newPath);
      console.log(`✅ File moved from ${oldPath} to ${newPath}`);
      
      // Update the event with the new image path
      const localImageUrl = `/uploads/events/${event.id}/${newFileName}`;
      const updatedEvent = await Event.updateEvent(event.id, {
        template_id: event.template_id,
        year_id: event.year_id,
        date: event.date,
        location: event.location,
        description: event.description,
        cover_image: localImageUrl
      });
      
      console.log('✅ Event created successfully with local cover image');
      res.status(201).json(updatedEvent);
      
    } else if (coverImageUrl) {
      // URL provided but no file upload
      const event = await Event.createEvent(req.body);
      res.status(201).json(event);
    } else {
      // No file upload and no URL, create event normally
      const event = await Event.createEvent(req.body);
      res.status(201).json(event);
    }
  } catch (err) {
    console.error('❌ Error in createEvent:', err);
    next(err);
  }
};

export const updateEvent = async (req, res, next) => {
  try {
    console.log('🎯 Updating event...');
    console.log('📋 Request body:', req.body);
    console.log('📁 File uploaded:', req.file ? 'Yes' : 'No');
    
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Event ID is required',
        details: [{ field: 'id', message: 'Event ID is required in request body' }]
      });
    }
    
    // Handle file upload if present
    if (req.file) {
      console.log(`🖼️ Processing cover image update to local storage...`);
      
      // Get the existing event to check for old image
      const existingEvent = await Event.getEventById(id);
      
      // If there's an existing local image, delete it
      if (existingEvent && existingEvent.cover_image && existingEvent.cover_image.startsWith('/uploads/events/')) {
        const oldImagePath = path.join(process.cwd(), existingEvent.cover_image);
        if (fs.existsSync(oldImagePath)) {
          try {
            fs.unlinkSync(oldImagePath);
            console.log(`✅ Deleted old cover image: ${existingEvent.cover_image}`);
          } catch (deleteError) {
            console.log(`⚠️ Could not delete old image: ${deleteError.message}`);
          }
        }
      }
      
      // Ensure event folder exists
      const eventDir = path.join('uploads', 'events', id.toString());
      if (!fs.existsSync(eventDir)) {
        fs.mkdirSync(eventDir, { recursive: true });
      }
      
      // Move the uploaded file to the event folder with proper naming
      const oldPath = req.file.path;
      const ext = path.extname(req.file.originalname);
      const newFileName = `cover_image_${id}${ext}`;
      const newPath = path.join(eventDir, newFileName);
      
      // Move the file
      fs.renameSync(oldPath, newPath);
      console.log(`✅ File moved from ${oldPath} to ${newPath}`);
      
      // Generate the local URL for the new uploaded image
      const localImageUrl = `/uploads/events/${id}/${newFileName}`;
      console.log(`✅ New image stored locally at: ${localImageUrl}`);
      
      // Update event with new local image URL
      const updatedEvent = await Event.updateEvent(id, {
        ...req.body,
        cover_image: localImageUrl
      });
      
      console.log('✅ Event updated successfully with new local cover image');
      res.json(updatedEvent);
      
    } else {
      // No file upload, update event normally
      const event = await Event.updateEvent(id, req.body);
      res.json(event);
    }
  } catch (err) {
    console.error('❌ Error in updateEvent:', err);
    next(err);
  }
};

export const deleteEvent = async (req, res, next) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Event ID is required',
        details: [{ field: 'id', message: 'Event ID is required in request body' }]
      });
    }
    
    // Get the existing event to check for cover image
    const existingEvent = await Event.getEventById(id);
    
    // Delete the event from database
    await Event.deleteEvent(id);
    
    // Clean up the event folder and all its contents
    if (existingEvent && existingEvent.cover_image && existingEvent.cover_image.startsWith('/uploads/events/')) {
      const eventDir = path.join(process.cwd(), 'uploads', 'events', id.toString());
      if (fs.existsSync(eventDir)) {
        try {
          // Remove the entire event directory and all its contents
          fs.rmSync(eventDir, { recursive: true, force: true });
          console.log(`✅ Deleted event folder: ${eventDir}`);
        } catch (deleteError) {
          console.log(`⚠️ Could not delete event folder: ${deleteError.message}`);
        }
      }
    }
    
    res.json({
      success: true,
      message: 'Event deleted successfully',
      data: { deletedEventId: id }
    });
  } catch (err) {
    next(err);
  }
};

export const getEventDetails = async (req, res, next) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'Event ID is required',
        details: [{ field: 'id', message: 'Event ID is required in request body' }]
      });
    }
    
    const event_id = id;
    // Fetch event details
    const event = await Event.getEventById(event_id);
    // Fetch gallery (design and final images)
    const gallery = await Gallery.getImagesByEvent(event_id);
    // Fetch cost summary
    const cost = await Cost.getEventCost(event_id);
    // Fetch issuances
    const issuances = await Issuance.getIssuancesByEvent(event_id);

    res.json({
      event,
      gallery,
      cost,
      issuances
    });
  } catch (err) {
    next(err);
  }
};


