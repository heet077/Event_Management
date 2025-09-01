import * as ToolInventory from '../models/toolInventory.model.js';
import * as InventoryService from '../services/inventory.service.js';

export const getAllToolInventory = async (req, res, next) => {
  try {
    const inventory = await ToolInventory.getAllToolInventory();
    res.json(inventory);
  } catch (err) {
    next(err);
  }
};

export const getToolInventoryByToolId = async (req, res, next) => {
  try {
    const { tool_id } = req.params;
    const inventory = await ToolInventory.getToolInventoryByToolId(tool_id);
    if (!inventory) {
      return res.status(404).json({ message: 'Tool inventory not found' });
    }
    res.json(inventory);
  } catch (err) {
    next(err);
  }
};

export const createToolInventory = async (req, res, next) => {
  try {
    const { tool_id, quantity_available, condition } = req.body;
    
    if (!tool_id) {
      return res.status(400).json({ 
        message: 'tool_id is required' 
      });
    }
    
    const inventory = await ToolInventory.createToolInventory({
      tool_id,
      quantity_available: quantity_available || 0,
      condition: condition || 'Good'
    });
    
    res.status(201).json(inventory);
  } catch (err) {
    next(err);
  }
};

export const updateToolInventory = async (req, res, next) => {
  try {
    const { tool_id, quantity_available, condition } = req.body;
    
    if (!tool_id) {
      return res.status(400).json({ 
        message: 'tool_id is required' 
      });
    }
    
    const updated = await ToolInventory.updateToolInventory(tool_id, {
      quantity_available,
      condition
    });
    
    res.json(updated);
  } catch (err) {
    next(err);
  }
};

export const adjustToolQuantity = async (req, res, next) => {
  try {
    const { tool_id, quantity_change } = req.body;
    
    if (!tool_id || quantity_change === undefined) {
      return res.status(400).json({ 
        message: 'tool_id and quantity_change are required' 
      });
    }
    
    const updated = await ToolInventory.adjustToolQuantity(tool_id, quantity_change);
    res.json(updated);
  } catch (err) {
    next(err);
  }
};

export const deductToolStock = async (req, res, next) => {
  try {
    const { tool_id, qty } = req.body;
    
    if (!tool_id || !qty) {
      return res.status(400).json({ 
        message: 'tool_id and qty are required' 
      });
    }
    
    const updated = await InventoryService.deductToolStock(tool_id, qty);
    res.json(updated);
  } catch (err) {
    next(err);
  }
};
