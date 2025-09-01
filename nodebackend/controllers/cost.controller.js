import * as Cost from '../models/cost.model.js';
import fs from 'fs';
import path from 'path';

// Get all cost items for an event
export const getEventCostItems = async (req, res, next) => {
  try {
    const { event_id } = req.body;

    if (!event_id || isNaN(event_id)) {
      return res.status(400).json({ message: 'Valid event_id is required' });
    }

    const costItems = await Cost.getEventCostItems(event_id);
    const totalCost = await Cost.getEventCostTotal(event_id);

    res.json({
      success: true,
      message: 'Cost items retrieved successfully',
      data: {
        event_id: parseInt(event_id),
        cost_items: costItems,
        total_cost: totalCost
      }
    });
  } catch (err) {
    next(err);
  }
};

// Create a new cost item for an event
export const createCostItem = async (req, res, next) => {
  try {
    const { event_id, description, amount, document_url, document_type } = req.body;

    if (!event_id || !description || !amount) {
      return res.status(400).json({ 
        success: false,
        message: 'event_id, description, and amount are required' 
      });
    }

    const costItem = await Cost.createCostItem({
      event_id,
      description,
      amount,
      document_url,
      document_type
    });

    res.status(201).json({
      success: true,
      message: 'Cost item created successfully',
      data: costItem
    });
  } catch (err) {
    next(err);
  }
};

// Create a new cost item with file upload
export const createCostItemWithFile = async (req, res, next) => {
  try {
    const { event_id, description, amount } = req.body;

    if (!event_id || !description || !amount) {
      return res.status(400).json({ 
        success: false,
        message: 'event_id, description, and amount are required' 
      });
    }

    let document_url = null;
    let document_type = null;

    if (req.file) {
      try {
        // Create local folder structure for cost documents
        const eventDir = path.join('uploads', 'events', event_id.toString());
        const costDir = path.join(eventDir, 'cost');
        
        // Ensure directories exist
        if (!fs.existsSync(eventDir)) {
          fs.mkdirSync(eventDir, { recursive: true });
        }
        if (!fs.existsSync(costDir)) {
          fs.mkdirSync(costDir, { recursive: true });
        }
        
        console.log(`📁 Created local folder structure: ${costDir}`);
        
        // Get the next file number for this event
        const existingFiles = fs.readdirSync(costDir);
        const costFiles = existingFiles.filter(file => file.startsWith('cost_'));
        const nextNumber = costFiles.length + 1;
        
        // Determine file extension and type
        const ext = path.extname(req.file.originalname).toLowerCase();
        const isImage = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].includes(ext);
        const isPdf = ext === '.pdf';
        
        if (!isImage && !isPdf) {
          // Clean up uploaded file
          if (fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
          }
          return res.status(400).json({
            success: false,
            message: 'Only image and PDF files are allowed'
          });
        }
        
        // Generate new filename
        const fileType = isImage ? 'image' : 'document';
        const newFileName = `cost_${fileType}_${nextNumber}${ext}`;
        const newPath = path.join(costDir, newFileName);
        
        // Move the file to the cost folder
        fs.renameSync(req.file.path, newPath);
        console.log(`✅ File moved from ${req.file.path} to ${newPath}`);
        
        // Generate the local URL for the document
        document_url = `/uploads/events/${event_id}/cost/${newFileName}`;
        document_type = isImage ? 'image' : 'pdf';
        
      } catch (error) {
        console.error('❌ Local storage error:', error);
        // Clean up uploaded file if local storage failed
        if (fs.existsSync(req.file.path)) {
          fs.unlinkSync(req.file.path);
        }
        return res.status(500).json({ 
          success: false,
          message: 'Failed to store document locally', 
          error: error.message 
        });
      }
    }

    const costItem = await Cost.createCostItem({
      event_id,
      description,
      amount,
      document_url,
      document_type
    });

    res.status(201).json({
      success: true,
      message: 'Cost item created successfully',
      data: costItem
    });
  } catch (err) {
    next(err);
  }
};

// Update a cost item
export const updateCostItem = async (req, res, next) => {
  try {
    const { id, description, amount, document_url, document_type } = req.body;

    if (!id || isNaN(id)) {
      return res.status(400).json({ 
        success: false,
        message: 'Valid cost item ID is required' 
      });
    }

    const updated = await Cost.updateCostItem(id, {
      description,
      amount,
      document_url,
      document_type
    });

    if (!updated) {
      return res.status(404).json({ 
        success: false,
        message: 'Cost item not found' 
      });
    }

    res.json({
      success: true,
      message: 'Cost item updated successfully',
      data: updated
    });
  } catch (err) {
    next(err);
  }
};

// Update a cost item with file upload
export const updateCostItemWithFile = async (req, res, next) => {
  try {
    const { id, description, amount } = req.body;

    if (!id || isNaN(id)) {
      return res.status(400).json({ 
        success: false,
        message: 'Valid cost item ID is required' 
      });
    }

    // Get existing cost item to find event_id and old document
    const existingItem = await Cost.getCostItemById(id);
    if (!existingItem) {
      return res.status(404).json({ 
        success: false,
        message: 'Cost item not found' 
      });
    }

    let document_url = existingItem.document_url;
    let document_type = existingItem.document_type;

    if (req.file) {
      try {
        // Delete old document if it exists
        if (existingItem.document_url && existingItem.document_url.startsWith('/uploads/')) {
          const oldFilePath = path.join('.', existingItem.document_url);
          if (fs.existsSync(oldFilePath)) {
            fs.unlinkSync(oldFilePath);
            console.log(`🗑️ Deleted old document: ${oldFilePath}`);
          }
        }

        // Create local folder structure for cost documents
        const eventDir = path.join('uploads', 'events', existingItem.event_id.toString());
        const costDir = path.join(eventDir, 'cost');
        
        // Ensure directories exist
        if (!fs.existsSync(eventDir)) {
          fs.mkdirSync(eventDir, { recursive: true });
        }
        if (!fs.existsSync(costDir)) {
          fs.mkdirSync(costDir, { recursive: true });
        }
        
        console.log(`📁 Created local folder structure: ${costDir}`);
        
        // Get the next file number for this event
        const existingFiles = fs.readdirSync(costDir);
        const costFiles = existingFiles.filter(file => file.startsWith('cost_'));
        const nextNumber = costFiles.length + 1;
        
        // Determine file extension and type
        const ext = path.extname(req.file.originalname).toLowerCase();
        const isImage = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'].includes(ext);
        const isPdf = ext === '.pdf';
        
        if (!isImage && !isPdf) {
          // Clean up uploaded file
          if (fs.existsSync(req.file.path)) {
            fs.unlinkSync(req.file.path);
          }
          return res.status(400).json({
            success: false,
            message: 'Only image and PDF files are allowed'
          });
        }
        
        // Generate new filename
        const fileType = isImage ? 'image' : 'document';
        const newFileName = `cost_${fileType}_${nextNumber}${ext}`;
        const newPath = path.join(costDir, newFileName);
        
        // Move the file to the cost folder
        fs.renameSync(req.file.path, newPath);
        console.log(`✅ File moved from ${req.file.path} to ${newPath}`);
        
        // Generate the local URL for the document
        document_url = `/uploads/events/${existingItem.event_id}/cost/${newFileName}`;
        document_type = isImage ? 'image' : 'pdf';
        
      } catch (error) {
        console.error('❌ Local storage error:', error);
        // Clean up uploaded file if local storage failed
        if (fs.existsSync(req.file.path)) {
          fs.unlinkSync(req.file.path);
        }
        return res.status(500).json({ 
          success: false,
          message: 'Failed to store document locally', 
          error: error.message 
        });
      }
    }

    const updated = await Cost.updateCostItem(id, {
      description,
      amount,
      document_url,
      document_type
    });

    res.json({
      success: true,
      message: 'Cost item updated successfully',
      data: updated
    });
  } catch (err) {
    next(err);
  }
};

// Delete a cost item
export const deleteCostItem = async (req, res, next) => {
  try {
    const { id } = req.params;

    if (isNaN(id)) {
      return res.status(400).json({ message: 'Invalid cost item ID' });
    }

    // Get the cost item to find the document path
    const costItem = await Cost.getCostItemById(id);
    if (costItem && costItem.document_url && costItem.document_url.startsWith('/uploads/')) {
      const filePath = path.join('.', costItem.document_url);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
        console.log(`🗑️ Deleted document: ${filePath}`);
      }
    }

    await Cost.deleteCostItem(id);
    res.json({ 
      success: true,
      message: 'Cost item deleted successfully' 
    });
  } catch (err) {
    next(err);
  }
};

// Legacy endpoints for backward compatibility
export const addEventCostSummary = async (req, res, next) => {
  try {
    const { event_id, material_cost, misc_cost } = req.body;

    if (isNaN(event_id)) {
      return res.status(400).json({ message: 'Invalid event ID' });
    }

    const result = await Cost.createOrUpdateCost(event_id, material_cost, misc_cost);
    res.status(201).json(result);
  } catch (err) {
    next(err);
  }
};

export const getEventCostSummary = async (req, res, next) => {
  try {
    const { event_id } = req.params;

    if (isNaN(event_id)) {
      return res.status(400).json({ message: 'Invalid event ID' });
    }

    const summary = await Cost.getEventCost(event_id);
    res.json(summary);
  } catch (err) {
    next(err);
  }
};

export const updateEventCostSummary = async (req, res, next) => {
  try {
    const { event_id } = req.params;
    const { material_cost, misc_cost } = req.body;

    if (isNaN(event_id)) {
      return res.status(400).json({ message: 'Invalid event ID' });
    }

    const result = await Cost.createOrUpdateCost(event_id, material_cost, misc_cost);
    res.json(result);
  } catch (err) {
    next(err);
  }
};

export const deleteEventCostSummary = async (req, res, next) => {
  try {
    const { event_id } = req.params;

    if (isNaN(event_id)) {
      return res.status(400).json({ message: 'Invalid event ID' });
    }

    // Delete all cost items for the event
    const costItems = await Cost.getEventCostItems(event_id);
    for (const item of costItems) {
      await Cost.deleteCostItem(item.id);
    }

    res.json({ message: 'Event cost deleted successfully' });
  } catch (err) {
    next(err);
  }
};
