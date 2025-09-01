import * as Issuance from '../models/issuance.model.js';
import * as InventoryService from '../services/inventory.service.js';

// Material Issuances
export const createIssuance = async (req, res, next) => {
  try {
    const { event_id, item_id, quantity_issued, notes } = req.body;
    
    // Validate required fields
    if (!event_id || !item_id || !quantity_issued) {
      return res.status(400).json({ 
        message: 'event_id, item_id, and quantity_issued are required' 
      });
    }
    
    // First deduct the material from inventory
    await InventoryService.deductMaterialStock(item_id, quantity_issued);
    
    // Then create the issuance record
    const issuance = await Issuance.issueMaterial({
      event_id,
      item_id,
      quantity_issued,
      notes
    });
    
    res.status(201).json(issuance);
  } catch (err) {
    next(err);
  }
};

export const getIssuancesByEvent = async (req, res, next) => {
  try {
    const { event_id } = req.params;
    const issuances = await Issuance.getIssuancesByEvent(event_id);
    res.json(issuances);
  } catch (err) {
    next(err);
  }
};

export const getAllIssuances = async (req, res, next) => {
  try {
    const issuances = await Issuance.getAllIssuances();
    res.json(issuances);
  } catch (err) {
    next(err);
  }
};

// Tool Issuances
export const createToolIssuance = async (req, res, next) => {
  try {
    const { event_id, tool_id, quantity_issued, condition, notes } = req.body;
    
    // Validate required fields
    if (!event_id || !tool_id || !quantity_issued) {
      return res.status(400).json({ 
        message: 'event_id, tool_id, and quantity_issued are required' 
      });
    }
    
    // First deduct the tool from inventory
    await InventoryService.deductToolStock(tool_id, quantity_issued);
    
    // Then create the issuance record
    const issuance = await Issuance.issueTool({
      event_id,
      tool_id,
      quantity_issued,
      condition: condition || 'Good',
      notes
    });
    
    res.status(201).json(issuance);
  } catch (err) {
    next(err);
  }
};

export const getToolIssuancesByEvent = async (req, res, next) => {
  try {
    const { event_id } = req.params;
    const issuances = await Issuance.getToolIssuancesByEvent(event_id);
    res.json(issuances);
  } catch (err) {
    next(err);
  }
};

export const getAllToolIssuances = async (req, res, next) => {
  try {
    const issuances = await Issuance.getAllToolIssuances();
    res.json(issuances);
  } catch (err) {
    next(err);
  }
}; 