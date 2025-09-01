import * as InventoryModel from '../models/inventory.model.js';

// Categories
export const createCategory = async (req, res) => {
  try {
    const { name } = req.body;
    
    if (!name) {
      return res.status(400).json({ error: 'Category name is required' });
    }

    const category = await InventoryModel.createCategory({ name });
    res.status(201).json({
      success: true,
      message: 'Category created successfully',
      data: category
    });
  } catch (error) {
    console.error('Error creating category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getAllCategories = async (req, res) => {
  try {
    const categories = await InventoryModel.getAllCategories();
    res.json({
      success: true,
      data: categories
    });
  } catch (error) {
    console.error('Error fetching categories:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getCategoryById = async (req, res) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Category ID is required' });
    }

    const category = await InventoryModel.getCategoryById(id);
    if (!category) {
      return res.status(404).json({ error: 'Category not found' });
    }

    res.json({
      success: true,
      data: category
    });
  } catch (error) {
    console.error('Error fetching category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const updateCategory = async (req, res) => {
  try {
    const { id, name } = req.body;
    
    if (!id || !name) {
      return res.status(400).json({ error: 'Category ID and name are required' });
    }

    const category = await InventoryModel.updateCategory({ id, name });
    if (!category) {
      return res.status(404).json({ error: 'Category not found' });
    }

    res.json({
      success: true,
      message: 'Category updated successfully',
      data: category
    });
  } catch (error) {
    console.error('Error updating category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const deleteCategory = async (req, res) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Category ID is required' });
    }

    const category = await InventoryModel.deleteCategory(id);
    if (!category) {
      return res.status(404).json({ error: 'Category not found' });
    }

    res.json({
      success: true,
      message: 'Category deleted successfully',
      data: category
    });
  } catch (error) {
    console.error('Error deleting category:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Inventory Items
export const createInventoryItem = async (req, res) => {
  try {
    const { name, category_id, unit, storage_location, notes, category_details, quantity_available } = req.body;
    
    if (!name || !category_id) {
      return res.status(400).json({ error: 'Item name and category ID are required' });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ error: 'Quantity must be a non-negative number' });
    }

    // Parse category_details if it's a string (from form data)
    let parsedCategoryDetails = null;
    if (category_details) {
      try {
        parsedCategoryDetails = typeof category_details === 'string' 
          ? JSON.parse(category_details) 
          : category_details;
      } catch (error) {
        return res.status(400).json({ error: 'Invalid category_details JSON format' });
      }
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      // Generate the image URL for local storage
      item_image = `/uploads/inventory/items/${req.body.id || 'temp'}/${req.file.filename}`;
    }

    const itemData = { name, category_id, unit, storage_location, notes, item_image };
    const item = await InventoryModel.createInventoryItemWithDetails(itemData, parsedCategoryDetails);

    // If we have an uploaded file and the item was created successfully, move the file to the correct location
    if (req.file && item) {
      const fs = await import('fs');
      const path = await import('path');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', item.id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Update the item with the correct image path
      const updatedItem = await InventoryModel.updateInventoryItem({
        id: item.id,
        name: item.name,
        category_id: item.category_id,
        unit: item.unit,
        storage_location: item.storage_location,
        notes: item.notes,
        item_image: `/uploads/inventory/items/${item.id}/${req.file.filename}`
      });
      
      // Update stock with the provided quantity
      if (quantity_available !== undefined) {
        await InventoryModel.updateStock({ 
          item_id: item.id, 
          quantity_available: parseFloat(quantity_available) 
        });
      }
      
      res.status(201).json({
        success: true,
        message: 'Inventory item created successfully',
        data: updatedItem
      });
    } else {
      // Update stock with the provided quantity
      if (quantity_available !== undefined) {
        await InventoryModel.updateStock({ 
          item_id: item.id, 
          quantity_available: parseFloat(quantity_available) 
        });
      }
      
      res.status(201).json({
        success: true,
        message: 'Inventory item created successfully',
        data: item
      });
    }
  } catch (error) {
    console.error('Error creating inventory item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getAllInventoryItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllInventoryItems();
    res.json({
      success: true,
      data: items
    });
  } catch (error) {
    console.error('Error fetching inventory items:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getInventoryItemById = async (req, res) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Item ID is required' });
    }

    const item = await InventoryModel.getInventoryItemWithDetails(id);
    if (!item) {
      return res.status(404).json({ error: 'Inventory item not found' });
    }

    res.json({
      success: true,
      data: item
    });
  } catch (error) {
    console.error('Error fetching inventory item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const updateInventoryItem = async (req, res) => {
  try {
    const { id, name, category_id, unit, storage_location, notes } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Item ID is required' });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      // Generate the image URL for local storage
      item_image = `/uploads/inventory/items/${id}/${req.file.filename}`;
    }

    const item = await InventoryModel.updateInventoryItem({ 
      id, name, category_id, unit, storage_location, notes, item_image 
    });
    if (!item) {
      return res.status(404).json({ error: 'Inventory item not found' });
    }

    res.json({
      success: true,
      message: 'Inventory item updated successfully',
      data: item
    });
  } catch (error) {
    console.error('Error updating inventory item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const deleteInventoryItem = async (req, res) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Item ID is required' });
    }

    const item = await InventoryModel.deleteInventoryItem(id);
    if (!item) {
      return res.status(404).json({ error: 'Inventory item not found' });
    }

    res.json({
      success: true,
      message: 'Inventory item deleted successfully',
      data: item
    });
  } catch (error) {
    console.error('Error deleting inventory item:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Stock
export const createStock = async (req, res) => {
  try {
    const { item_id, quantity_available } = req.body;
    
    if (!item_id || quantity_available === undefined) {
      return res.status(400).json({ error: 'Item ID and quantity are required' });
    }

    const stock = await InventoryModel.createStock({ item_id, quantity_available });
    res.status(201).json({
      success: true,
      message: 'Stock created successfully',
      data: stock
    });
  } catch (error) {
    console.error('Error creating stock:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getStockByItemId = async (req, res) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id) {
      return res.status(400).json({ error: 'Item ID is required' });
    }

    const stock = await InventoryModel.getStockByItemId(item_id);
    if (!stock) {
      return res.status(404).json({ error: 'Stock not found for this item' });
    }

    res.json({
      success: true,
      data: stock
    });
  } catch (error) {
    console.error('Error fetching stock:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const updateStock = async (req, res) => {
  try {
    const { item_id, quantity_available } = req.body;
    
    if (!item_id || quantity_available === undefined) {
      return res.status(400).json({ error: 'Item ID and quantity are required' });
    }

    const stock = await InventoryModel.updateStock({ item_id, quantity_available });
    if (!stock) {
      return res.status(404).json({ error: 'Stock not found for this item' });
    }

    res.json({
      success: true,
      message: 'Stock updated successfully',
      data: stock
    });
  } catch (error) {
    console.error('Error updating stock:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getAllStock = async (req, res) => {
  try {
    const stock = await InventoryModel.getAllStock();
    res.json({
      success: true,
      data: stock
    });
  } catch (error) {
    console.error('Error fetching stock:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Material Issuances
export const createMaterialIssuance = async (req, res) => {
  try {
    const { item_id, transaction_type, quantity, event_id, notes } = req.body;
    
    if (!item_id || !transaction_type || !quantity) {
      return res.status(400).json({ error: 'Item ID, transaction type, and quantity are required' });
    }

    if (!['IN', 'OUT'].includes(transaction_type)) {
      return res.status(400).json({ error: 'Transaction type must be either IN or OUT' });
    }

    // Validate quantity as a valid positive number
    const quantityNum = parseFloat(quantity);
    if (isNaN(quantityNum) || quantityNum <= 0) {
      return res.status(400).json({ error: 'Quantity must be a valid positive number' });
    }

    // Check if stock exists for this item
    const currentStock = await InventoryModel.getStockByItemId(item_id);
    if (!currentStock) {
      return res.status(404).json({ error: 'Stock record not found for this item. Please create stock first.' });
    }

    // For OUT transactions, check if we have enough stock to deduct
    if (transaction_type === 'OUT') {
      const currentStockNum = parseFloat(currentStock.quantity_available);
      if (currentStockNum < quantityNum) {
        return res.status(400).json({ 
          error: 'Insufficient stock for issue transaction', 
          current_stock: currentStockNum,
          requested_quantity: quantityNum,
          message: 'Cannot issue more items than currently available in stock'
        });
      }
    }

    const issuance = await InventoryModel.createMaterialIssuance({ 
      item_id, transaction_type, quantity: quantityNum, event_id, notes 
    });

    // Get updated stock information
    const updatedStock = await InventoryModel.getStockByItemId(item_id);

    res.status(201).json({
      success: true,
      message: `Material issuance created successfully. Stock ${transaction_type === 'OUT' ? 'deducted' : 'added'}.`,
      data: {
        issuance,
        stock_update: {
          previous_quantity: currentStock.quantity_available,
          new_quantity: updatedStock.quantity_available,
          change: transaction_type === 'OUT' ? -quantityNum : quantityNum
        }
      }
    });
  } catch (error) {
    console.error('Error creating material issuance:', error);
    if (error.message.includes('Stock record not found')) {
      return res.status(404).json({ error: 'Stock record not found for this item. Please create stock first.' });
    }
    if (error.message.includes('Cannot deduct more than available stock')) {
      return res.status(400).json({ error: 'Insufficient stock for this transaction' });
    }
    if (error.message.includes('Invalid quantity calculation')) {
      return res.status(400).json({ error: 'Invalid quantity value provided' });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getAllMaterialIssuances = async (req, res) => {
  try {
    const issuances = await InventoryModel.getAllMaterialIssuances();
    res.json({
      success: true,
      data: issuances
    });
  } catch (error) {
    console.error('Error fetching material issuances:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getMaterialIssuanceById = async (req, res) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Issuance ID is required' });
    }

    const issuance = await InventoryModel.getMaterialIssuanceById(id);
    if (!issuance) {
      return res.status(404).json({ error: 'Material issuance not found' });
    }

    res.json({
      success: true,
      data: issuance
    });
  } catch (error) {
    console.error('Error fetching material issuance:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const updateMaterialIssuance = async (req, res) => {
  try {
    const { id, item_id, transaction_type, quantity, event_id, notes } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Issuance ID is required' });
    }

    if (transaction_type && !['IN', 'OUT'].includes(transaction_type)) {
      return res.status(400).json({ error: 'Transaction type must be either IN or OUT' });
    }

    if (quantity !== undefined) {
      const quantityNum = parseFloat(quantity);
      if (isNaN(quantityNum) || quantityNum <= 0) {
        return res.status(400).json({ error: 'Quantity must be a valid positive number' });
      }
    }

    // Get the original issuance to validate changes
    const originalIssuance = await InventoryModel.getMaterialIssuanceById(id);
    if (!originalIssuance) {
      return res.status(404).json({ error: 'Material issuance not found' });
    }

    // Check if stock exists for the target item
    const currentStock = await InventoryModel.getStockByItemId(item_id || originalIssuance.item_id);
    if (!currentStock) {
      return res.status(404).json({ error: 'Stock record not found for this item. Please create stock first.' });
    }

    // For OUT transactions, check if we have enough stock to deduct
    if (transaction_type === 'OUT' && quantity !== undefined) {
      const quantityNum = parseFloat(quantity);
      const currentStockNum = parseFloat(currentStock.quantity_available);
      
      if (currentStockNum < quantityNum) {
        return res.status(400).json({ 
          error: 'Insufficient stock for issue transaction', 
          current_stock: currentStockNum,
          requested_quantity: quantityNum,
          message: 'Cannot issue more items than currently available in stock'
        });
      }
    }

    const issuance = await InventoryModel.updateMaterialIssuance({ 
      id, item_id, transaction_type, quantity, event_id, notes 
    });
    if (!issuance) {
      return res.status(404).json({ error: 'Material issuance not found' });
    }

    // Get updated stock information
    const updatedStock = await InventoryModel.getStockByItemId(issuance.item_id);

    res.json({
      success: true,
      message: `Material issuance updated successfully. Stock adjusted accordingly.`,
      data: {
        issuance,
        stock_update: {
          new_quantity: updatedStock.quantity_available
        }
      }
    });
  } catch (error) {
    console.error('Error updating material issuance:', error);
    if (error.message.includes('Stock record not found')) {
      return res.status(404).json({ error: 'Stock record not found for this item. Please create stock first.' });
    }
    if (error.message.includes('Cannot deduct more than available stock')) {
      return res.status(400).json({ error: 'Insufficient stock for this transaction' });
    }
    if (error.message.includes('Material issuance not found')) {
      return res.status(404).json({ error: 'Material issuance not found' });
    }
    if (error.message.includes('Invalid quantity calculation')) {
      return res.status(400).json({ error: 'Invalid quantity value provided' });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const deleteMaterialIssuance = async (req, res) => {
  try {
    const { id } = req.body;
    
    if (!id) {
      return res.status(400).json({ error: 'Issuance ID is required' });
    }

    // Get the original issuance to show stock impact
    const originalIssuance = await InventoryModel.getMaterialIssuanceById(id);
    if (!originalIssuance) {
      return res.status(404).json({ error: 'Material issuance not found' });
    }

    const issuance = await InventoryModel.deleteMaterialIssuance(id);
    if (!issuance) {
      return res.status(404).json({ error: 'Material issuance not found' });
    }

    // Get updated stock information
    const updatedStock = await InventoryModel.getStockByItemId(issuance.item_id);

    res.json({
      success: true,
      message: `Material issuance deleted successfully. Stock adjusted accordingly.`,
      data: {
        deleted_issuance: issuance,
        stock_update: {
          new_quantity: updatedStock.quantity_available
        }
      }
    });
  } catch (error) {
    console.error('Error deleting material issuance:', error);
    if (error.message.includes('Material issuance not found')) {
      return res.status(404).json({ error: 'Material issuance not found' });
    }
    if (error.message.includes('Stock record not found')) {
      return res.status(404).json({ error: 'Stock record not found for this item' });
    }
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Transactions (Stock Movements)
export const recordTransaction = async (req, res) => {
  try {
    const { item_id, transaction_type, quantity, event_id, notes } = req.body;
    
    if (!item_id || !transaction_type || !quantity) {
      return res.status(400).json({ error: 'Item ID, transaction type, and quantity are required' });
    }

    if (!['IN', 'OUT'].includes(transaction_type)) {
      return res.status(400).json({ error: 'Transaction type must be either IN or OUT' });
    }

    if (quantity <= 0) {
      return res.status(400).json({ error: 'Quantity must be greater than 0' });
    }

    // Get current stock
    const currentStock = await InventoryModel.getStockByItemId(item_id);
    if (!currentStock) {
      return res.status(404).json({ error: 'Stock not found for this item' });
    }

    // Check if we have enough stock for OUT transactions
    if (transaction_type === 'OUT' && currentStock.quantity_available < quantity) {
      return res.status(400).json({ 
        error: 'Insufficient stock', 
        current_stock: currentStock.quantity_available,
        requested_quantity: quantity
      });
    }

    // Calculate new quantity
    const newQuantity = transaction_type === 'IN' 
      ? currentStock.quantity_available + quantity
      : currentStock.quantity_available - quantity;

    // Update stock
    const updatedStock = await InventoryModel.updateStock({ 
      item_id, 
      quantity_available: newQuantity 
    });

    // Create material issuance record
    const issuance = await InventoryModel.createMaterialIssuance({ 
      item_id, transaction_type, quantity, event_id, notes 
    });

    res.status(201).json({
      success: true,
      message: 'Transaction recorded successfully',
      data: {
        transaction: issuance,
        updated_stock: updatedStock
      }
    });
  } catch (error) {
    console.error('Error recording transaction:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getStockBalance = async (req, res) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id) {
      return res.status(400).json({ error: 'Item ID is required' });
    }

    const stock = await InventoryModel.getStockByItemId(item_id);
    if (!stock) {
      return res.status(404).json({ error: 'Stock not found for this item' });
    }

    res.json({
      success: true,
      data: {
        item_id,
        quantity_available: stock.quantity_available
      }
    });
  } catch (error) {
    console.error('Error fetching stock balance:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
}; 