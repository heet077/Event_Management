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
        console.error('Error parsing category_details:', error);
        return res.status(400).json({ error: 'Invalid category_details JSON format' });
      }
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      // Generate the image URL for local storage
      item_image = `/uploads/inventory/items/${req.body.id || 'temp'}/${req.file.filename}`;
    }

    const itemData = { name, category_id, unit, storage_location, notes, item_image, quantity_available };
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
    
    // Format the response to include category-specific details
    const formattedItems = items.map(item => {
      const formattedItem = {
        id: item.id,
        name: item.name,
        category_id: item.category_id,
        category_name: item.category_name,
        unit: item.unit,
        storage_location: item.storage_location,
        notes: item.notes,
        item_image: item.item_image,
        available_quantity: item.available_quantity,
        created_at: item.created_at,
        updated_at: item.updated_at
      };

      // Add category-specific details based on category
      switch (item.category_name) {
        case 'Furniture':
          if (item.furniture_material || item.furniture_dimensions) {
            formattedItem.furniture_details = {
              material: item.furniture_material,
              dimensions: item.furniture_dimensions
            };
          }
          break;
          
        case 'Fabric':
          if (item.fabric_type || item.fabric_pattern || item.fabric_width || item.fabric_length || item.fabric_color) {
            formattedItem.fabric_details = {
              fabric_type: item.fabric_type,
              pattern: item.fabric_pattern,
              width: item.fabric_width,
              length: item.fabric_length,
              color: item.fabric_color
            };
          }
          break;
          
        case 'Frame Structures':
          if (item.frame_type || item.frame_material || item.frame_dimensions) {
            formattedItem.frame_structure_details = {
              frame_type: item.frame_type,
              material: item.frame_material,
              dimensions: item.frame_dimensions
            };
          }
          break;
          
        case 'Carpets':
          if (item.carpet_type || item.carpet_material || item.carpet_size) {
            formattedItem.carpet_details = {
              carpet_type: item.carpet_type,
              material: item.carpet_material,
              size: item.carpet_size
            };
          }
          break;
          
        case 'Thermocol Materials':
          if (item.thermocol_type || item.density || item.thermocol_dimensions) {
            formattedItem.thermocol_details = {
              thermocol_type: item.thermocol_type,
              density: item.density,
              dimensions: item.thermocol_dimensions
            };
          }
          break;
          
        case 'Stationery':
          if (item.stationery_specifications) {
            formattedItem.stationery_details = {
              specifications: item.stationery_specifications
            };
          }
          break;
          
        case 'Murti Sets':
          if (item.set_number || item.murti_material || item.murti_dimensions) {
            formattedItem.murti_set_details = {
              set_number: item.set_number,
              material: item.murti_material,
              dimensions: item.murti_dimensions
            };
          }
          break;
      }

      return formattedItem;
    });

    res.json({
      success: true,
      message: "Inventory items retrieved successfully with complete category details",
      data: formattedItems,
      count: formattedItems.length
    });
  } catch (error) {
    console.error('Error fetching inventory items:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const getInventoryItemList = async (req, res) => {
  try {
    const items = await InventoryModel.getInventoryItemList();
    res.json({
      success: true,
      message: 'Inventory item list retrieved successfully',
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching inventory item list:', error);
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

    // Get old image path before updating
    const oldItem = await InventoryModel.getInventoryItemById(id);
    if (!oldItem) {
      return res.status(404).json({ error: 'Inventory item not found' });
    }
    const oldImagePath = oldItem.item_image;

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

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file) {
      const { handleImageReplacement } = await import('../utils/imageReplacement.js');
      
      await handleImageReplacement({
        itemId: id,
        oldImagePath,
        reqFile: req.file,
        updateItemFunction: InventoryModel.updateInventoryItem,
        updateData: {
          id: parseInt(id),
          name,
          category_id,
          unit,
          storage_location,
          notes
        }
      });
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
      return res.status(400).json({ 
        success: false,
        error: 'Item ID is required' 
      });
    }

    // Validate that id is a number
    const itemId = parseInt(id);
    if (isNaN(itemId)) {
      return res.status(400).json({ 
        success: false,
        error: 'Item ID must be a valid number' 
      });
    }

    // Get item details before deletion for response
    const itemDetails = await InventoryModel.getInventoryItemById(itemId);
    if (!itemDetails) {
      return res.status(404).json({ 
        success: false,
        error: 'Inventory item not found' 
      });
    }

    // Delete the item from all related tables
    const deletedItem = await InventoryModel.deleteInventoryItem(itemId);
    
    // Also delete the item's image file if it exists
    if (itemDetails.item_image) {
      try {
        const { deleteImageFile } = await import('../utils/imageUtils.js');
        await deleteImageFile(itemDetails.item_image);
        
        // Also try to clean up the item's directory
        const path = await import('path');
        const fs = await import('fs');
        const imageDir = path.dirname(itemDetails.item_image);
        const cleanImageDir = imageDir.startsWith('/') ? imageDir.slice(1) : imageDir;
        const fullImageDir = path.resolve(cleanImageDir);
        
        if (fs.existsSync(fullImageDir)) {
          const files = fs.readdirSync(fullImageDir);
          if (files.length === 0) {
            fs.rmdirSync(fullImageDir);
          }
        }
      } catch (imageError) {
        console.warn('Warning: Could not delete image file:', imageError.message);
        // Don't fail the deletion if image cleanup fails
      }
    }

    res.json({
      success: true,
      message: 'Inventory item deleted successfully from all related tables',
      data: {
        deleted_item: deletedItem,
        category_name: itemDetails.category_name,
        deleted_from_tables: [
          'inventory_items',
          'inventory_stock',
          getCategoryTableName(itemDetails.category_id)
        ]
      }
    });
  } catch (error) {
    console.error('Error deleting inventory item:', error);
    
    if (error.message === 'Inventory item not found') {
      return res.status(404).json({ 
        success: false,
        error: 'Inventory item not found' 
      });
    }
    
    if (error.message === 'Invalid category ID') {
      return res.status(400).json({ 
        success: false,
        error: 'Invalid category ID for this item' 
      });
    }
    
    res.status(500).json({ 
      success: false,
      error: 'Internal server error while deleting inventory item' 
    });
  }
};

// Helper function to get category table name
const getCategoryTableName = (categoryId) => {
  switch (categoryId) {
    case 1: return 'stationery';
    case 2: return 'furniture';
    case 3: return 'fabric';
    case 4: return 'frame_structures';
    case 5: return 'carpets';
    case 6: return 'thermocol_materials';
    case 7: return 'murti_sets';
    default: return 'unknown';
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

export const getMaterialIssuanceHistoryByItemId = async (req, res) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id) {
      return res.status(400).json({ 
        success: false,
        error: 'Item ID is required' 
      });
    }

    // Validate that item_id is a number
    const itemId = parseInt(item_id);
    if (isNaN(itemId)) {
      return res.status(400).json({ 
        success: false,
        error: 'Item ID must be a valid number' 
      });
    }

    // Check if the inventory item exists
    const item = await InventoryModel.getInventoryItemById(itemId);
    if (!item) {
      return res.status(404).json({ 
        success: false,
        error: 'Inventory item not found' 
      });
    }

    // Get the issuance history for this item
    const issuanceHistory = await InventoryModel.getMaterialIssuanceHistoryByItemId(itemId);
    
    // Calculate summary statistics
    const totalIssued = issuanceHistory
      .filter(issuance => issuance.transaction_type === 'OUT')
      .reduce((sum, issuance) => sum + parseFloat(issuance.quantity_issued), 0);
    
    const totalReturned = issuanceHistory
      .filter(issuance => issuance.transaction_type === 'IN')
      .reduce((sum, issuance) => sum + parseFloat(issuance.quantity_issued), 0);
    
    const netIssued = totalIssued - totalReturned;

    res.json({
      success: true,
      message: 'Material issuance history retrieved successfully',
      data: {
        item_info: {
          id: item.id,
          name: item.name,
          category_name: item.category_name,
          unit: item.unit,
          storage_location: item.storage_location
        },
        issuance_history: issuanceHistory,
        summary: {
          total_transactions: issuanceHistory.length,
          total_issued: totalIssued,
          total_returned: totalReturned,
          net_issued: netIssued,
          current_stock: item.available_quantity || 0
        },
        count: issuanceHistory.length
      }
    });
  } catch (error) {
    console.error('Error fetching material issuance history:', error);
    res.status(500).json({ 
      success: false,
      error: 'Internal server error while fetching issuance history' 
    });
  }
};

export const getMaterialIssuanceHistoryByEventId = async (req, res) => {
  try {
    const { event_id } = req.body;
    
    if (!event_id) {
      return res.status(400).json({ 
        success: false,
        error: 'Event ID is required' 
      });
    }

    // Validate that event_id is a number
    const eventId = parseInt(event_id);
    if (isNaN(eventId)) {
      return res.status(400).json({ 
        success: false,
        error: 'Event ID must be a valid number' 
      });
    }

    // Get the issuance history for this event
    const issuanceHistory = await InventoryModel.getMaterialIssuanceHistoryByEventId(eventId);
    
    if (issuanceHistory.length === 0) {
      return res.json({
        success: true,
        message: 'No material issuances found for this event',
        data: {
          event_id: eventId,
          issuance_history: [],
          summary: {
            total_transactions: 0,
            total_items_used: 0,
            total_quantity_issued: 0,
            total_quantity_returned: 0,
            net_quantity_issued: 0,
            categories_used: []
          },
          count: 0
        }
      });
    }

    // Calculate summary statistics
    const totalIssued = issuanceHistory
      .filter(issuance => issuance.transaction_type === 'OUT')
      .reduce((sum, issuance) => sum + parseFloat(issuance.quantity_issued), 0);
    
    const totalReturned = issuanceHistory
      .filter(issuance => issuance.transaction_type === 'IN')
      .reduce((sum, issuance) => sum + parseFloat(issuance.quantity_issued), 0);
    
    const netIssued = totalIssued - totalReturned;

    // Get unique items and categories used
    const uniqueItems = [...new Set(issuanceHistory.map(issuance => issuance.item_id))];
    const uniqueCategories = [...new Set(issuanceHistory.map(issuance => issuance.category_name))];

    // Group issuances by item for better organization
    const issuancesByItem = issuanceHistory.reduce((acc, issuance) => {
      const itemId = issuance.item_id;
      if (!acc[itemId]) {
        acc[itemId] = {
          item_info: {
            id: issuance.item_id,
            name: issuance.item_name,
            category_name: issuance.category_name,
            unit: issuance.unit,
            storage_location: issuance.storage_location,
            item_image: issuance.item_image
          },
          transactions: []
        };
      }
      acc[itemId].transactions.push({
        id: issuance.id,
        quantity_issued: issuance.quantity_issued,
        notes: issuance.notes,
        issued_at: issuance.issued_at,
        transaction_type: issuance.transaction_type
      });
      return acc;
    }, {});

    res.json({
      success: true,
      message: 'Event material issuance history retrieved successfully',
      data: {
        event_id: eventId,
        issuance_history: issuanceHistory,
        issuances_by_item: Object.values(issuancesByItem),
        summary: {
          total_transactions: issuanceHistory.length,
          total_items_used: uniqueItems.length,
          total_quantity_issued: totalIssued,
          total_quantity_returned: totalReturned,
          net_quantity_issued: netIssued,
          categories_used: uniqueCategories
        },
        count: issuanceHistory.length
      }
    });
  } catch (error) {
    console.error('Error fetching event material issuance history:', error);
    res.status(500).json({ 
      success: false,
      error: 'Internal server error while fetching event issuance history' 
    });
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

// Category-specific controllers
// Furniture
export const getAllFurnitureItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllFurnitureItems();
    res.json({
      success: true,
      message: "Furniture items retrieved successfully",
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching furniture items:', error);
    res.status(500).json({ error: 'Error fetching furniture items' });
  }
};

export const getFurnitureItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await InventoryModel.getFurnitureItemById(id);
    
    if (!item) {
      return res.status(404).json({ 
        success: false,
        message: 'Furniture item not found' 
      });
    }
    
    res.json({
      success: true,
      message: "Furniture item retrieved successfully",
      data: item
    });
  } catch (error) {
    console.error('Error fetching furniture item:', error);
    res.status(500).json({ error: 'Error fetching furniture item' });
  }
};

// Fabric
export const getAllFabricItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllFabricItems();
    res.json({
      success: true,
      message: "Fabric items retrieved successfully",
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching fabric items:', error);
    res.status(500).json({ error: 'Error fetching fabric items' });
  }
};

export const getFabricItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await InventoryModel.getFabricItemById(id);
    
    if (!item) {
      return res.status(404).json({ 
        success: false,
        message: 'Fabric item not found' 
      });
    }
    
    res.json({
      success: true,
      message: "Fabric item retrieved successfully",
      data: item
    });
  } catch (error) {
    console.error('Error fetching fabric item:', error);
    res.status(500).json({ error: 'Error fetching fabric item' });
  }
};

// Frame Structures
export const getAllFrameStructureItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllFrameStructureItems();
    res.json({
      success: true,
      message: "Frame structure items retrieved successfully",
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching frame structure items:', error);
    res.status(500).json({ error: 'Error fetching frame structure items' });
  }
};

export const getFrameStructureItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await InventoryModel.getFrameStructureItemById(id);
    
    if (!item) {
      return res.status(404).json({ 
        success: false,
        message: 'Frame structure item not found' 
      });
    }
    
    res.json({
      success: true,
      message: "Frame structure item retrieved successfully",
      data: item
    });
  } catch (error) {
    console.error('Error fetching frame structure item:', error);
    res.status(500).json({ error: 'Error fetching frame structure item' });
  }
};

// Carpets
export const getAllCarpetItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllCarpetItems();
    res.json({
      success: true,
      message: "Carpet items retrieved successfully",
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching carpet items:', error);
    res.status(500).json({ error: 'Error fetching carpet items' });
  }
};

export const getCarpetItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await InventoryModel.getCarpetItemById(id);
    
    if (!item) {
      return res.status(404).json({ 
        success: false,
        message: 'Carpet item not found' 
      });
    }
    
    res.json({
      success: true,
      message: "Carpet item retrieved successfully",
      data: item
    });
  } catch (error) {
    console.error('Error fetching carpet item:', error);
    res.status(500).json({ error: 'Error fetching carpet item' });
  }
};

// Thermocol Materials
export const getAllThermocolMaterialItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllThermocolMaterialItems();
    res.json({
      success: true,
      message: "Thermocol material items retrieved successfully",
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching thermocol material items:', error);
    res.status(500).json({ error: 'Error fetching thermocol material items' });
  }
};

export const getThermocolMaterialItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await InventoryModel.getThermocolMaterialItemById(id);
    
    if (!item) {
      return res.status(404).json({ 
        success: false,
        message: 'Thermocol material item not found' 
      });
    }
    
    res.json({
      success: true,
      message: "Thermocol material item retrieved successfully",
      data: item
    });
  } catch (error) {
    console.error('Error fetching thermocol material item:', error);
    res.status(500).json({ error: 'Error fetching thermocol material item' });
  }
};

// Stationery
export const getAllStationeryItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllStationeryItems();
    res.json({
      success: true,
      message: "Stationery items retrieved successfully",
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching stationery items:', error);
    res.status(500).json({ error: 'Error fetching stationery items' });
  }
};

export const getStationeryItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await InventoryModel.getStationeryItemById(id);
    
    if (!item) {
      return res.status(404).json({ 
        success: false,
        message: 'Stationery item not found' 
      });
    }
    
    res.json({
      success: true,
      message: "Stationery item retrieved successfully",
      data: item
    });
  } catch (error) {
    console.error('Error fetching stationery item:', error);
    res.status(500).json({ error: 'Error fetching stationery item' });
  }
};

// Murti Sets
export const getAllMurtiSetItems = async (req, res) => {
  try {
    const items = await InventoryModel.getAllMurtiSetItems();
    res.json({
      success: true,
      message: "Murti set items retrieved successfully",
      data: items,
      count: items.length
    });
  } catch (error) {
    console.error('Error fetching murti set items:', error);
    res.status(500).json({ error: 'Error fetching murti set items' });
  }
};

export const getMurtiSetItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const item = await InventoryModel.getMurtiSetItemById(id);
    
    if (!item) {
      return res.status(404).json({ 
        success: false,
        message: 'Murti set item not found' 
      });
    }
    
    res.json({
      success: true,
      message: "Murti set item retrieved successfully",
      data: item
    });
  } catch (error) {
    console.error('Error fetching murti set item:', error);
    res.status(500).json({ error: 'Error fetching murti set item' });
  }
};

// Category-specific create controllers
// Furniture
export const createFurnitureItem = async (req, res) => {
  try {
    const { name, unit, storage_location, notes, quantity_available, material, dimensions } = req.body;
    
    if (!name || !material || !dimensions) {
      return res.status(400).json({ 
        success: false,
        error: 'Name, material, and dimensions are required for furniture items' 
      });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ 
        success: false,
        error: 'Quantity must be a non-negative number' 
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      name, 
      category_id: 2, // Furniture category ID
      unit, 
      storage_location, 
      notes, 
      item_image, 
      quantity_available,
      material,
      dimensions
    };

    const item = await InventoryModel.createFurnitureItem(itemData);

    // If we have an uploaded file, move it to the correct location
    if (req.file && item) {
      const { handleImageReplacement } = await import('../utils/imageReplacement.js');
      
      await handleImageReplacement({
        itemId: item.id,
        oldImagePath: null, // No old image for new items
        reqFile: req.file,
        updateItemFunction: InventoryModel.updateInventoryItem,
        updateData: {
          id: item.id,
          name: item.name,
          category_id: item.category_id,
          unit: item.unit,
          storage_location: item.storage_location,
          notes: item.notes
        }
      });
    }
    
    // Get complete furniture item details with stock and furniture-specific details
    const completeItem = await InventoryModel.getFurnitureItemById(item.id);
    
    res.status(201).json({
      success: true,
      message: 'Furniture item created successfully',
      data: completeItem
    });
  } catch (error) {
    console.error('Error creating furniture item:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error creating furniture item' 
    });
  }
};

// Fabric
export const createFabricItem = async (req, res) => {
  try {
    const { name, unit, storage_location, notes, quantity_available, fabric_type, pattern, width, length, color } = req.body;
    
    if (!name || !fabric_type) {
      return res.status(400).json({ 
        success: false,
        error: 'Name and fabric_type are required for fabric items' 
      });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ 
        success: false,
        error: 'Quantity must be a non-negative number' 
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      name, 
      category_id: 3, // Fabric category ID
      unit, 
      storage_location, 
      notes, 
      item_image, 
      quantity_available,
      fabric_type,
      pattern,
      width,
      length,
      color
    };

    const item = await InventoryModel.createFabricItem(itemData);

    // Handle image file movement if uploaded
    if (req.file && item) {
      const { handleImageReplacement } = await import('../utils/imageReplacement.js');
      
      await handleImageReplacement({
        itemId: item.id,
        oldImagePath: null, // No old image for new items
        reqFile: req.file,
        updateItemFunction: InventoryModel.updateInventoryItem,
        updateData: {
          id: item.id,
          name: item.name,
          category_id: item.category_id,
          unit: item.unit,
          storage_location: item.storage_location,
          notes: item.notes
        }
      });
    }
    
    // Get complete fabric item details with stock and fabric-specific details
    const completeItem = await InventoryModel.getFabricItemById(item.id);
    
    res.status(201).json({
      success: true,
      message: 'Fabric item created successfully',
      data: completeItem
    });
  } catch (error) {
    console.error('Error creating fabric item:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error creating fabric item' 
    });
  }
};

// Frame Structures
export const createFrameStructureItem = async (req, res) => {
  try {
    const { name, unit, storage_location, notes, quantity_available, frame_type, material, dimensions } = req.body;
    
    if (!name || !frame_type || !material || !dimensions) {
      return res.status(400).json({ 
        success: false,
        error: 'Name, frame_type, material, and dimensions are required for frame structure items' 
      });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ 
        success: false,
        error: 'Quantity must be a non-negative number' 
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      name, 
      category_id: 4, // Frame Structures category ID
      unit, 
      storage_location, 
      notes, 
      item_image, 
      quantity_available,
      frame_type,
      material,
      dimensions
    };

    const item = await InventoryModel.createFrameStructureItem(itemData);

    // Handle image file movement if uploaded
    if (req.file && item) {
      const fs = await import('fs');
      const path = await import('path');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', item.id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      fs.renameSync(tempPath, finalPath);
      
      const updatedItem = await InventoryModel.updateInventoryItem({
        id: item.id,
        name: item.name,
        category_id: item.category_id,
        unit: item.unit,
        storage_location: item.storage_location,
        notes: item.notes,
        item_image: `/uploads/inventory/items/${item.id}/${req.file.filename}`
      });
      
      // Get complete frame structure item details with stock and frame-specific details
      const completeItem = await InventoryModel.getFrameStructureItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Frame structure item created successfully',
        data: completeItem
      });
    } else {
      // Get complete frame structure item details with stock and frame-specific details
      const completeItem = await InventoryModel.getFrameStructureItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Frame structure item created successfully',
        data: completeItem
      });
    }
  } catch (error) {
    console.error('Error creating frame structure item:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error creating frame structure item' 
    });
  }
};

// Carpets
export const createCarpetItem = async (req, res) => {
  try {
    const { name, unit, storage_location, notes, quantity_available, carpet_type, material, size } = req.body;
    
    if (!name || !carpet_type || !material || !size) {
      return res.status(400).json({ 
        success: false,
        error: 'Name, carpet_type, material, and size are required for carpet items' 
      });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ 
        success: false,
        error: 'Quantity must be a non-negative number' 
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      name, 
      category_id: 5, // Carpets category ID
      unit, 
      storage_location, 
      notes, 
      item_image, 
      quantity_available,
      carpet_type,
      material,
      size
    };

    const item = await InventoryModel.createCarpetItem(itemData);

    // Handle image file movement if uploaded
    if (req.file && item) {
      const fs = await import('fs');
      const path = await import('path');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', item.id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      fs.renameSync(tempPath, finalPath);
      
      const updatedItem = await InventoryModel.updateInventoryItem({
        id: item.id,
        name: item.name,
        category_id: item.category_id,
        unit: item.unit,
        storage_location: item.storage_location,
        notes: item.notes,
        item_image: `/uploads/inventory/items/${item.id}/${req.file.filename}`
      });
      
      // Get complete carpet item details with stock and carpet-specific details
      const completeItem = await InventoryModel.getCarpetItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Carpet item created successfully',
        data: completeItem
      });
    } else {
      // Get complete carpet item details with stock and carpet-specific details
      const completeItem = await InventoryModel.getCarpetItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Carpet item created successfully',
        data: completeItem
      });
    }
  } catch (error) {
    console.error('Error creating carpet item:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error creating carpet item' 
    });
  }
};

// Thermocol Materials
export const createThermocolMaterialItem = async (req, res) => {
  try {
    const { name, unit, storage_location, notes, quantity_available, thermocol_type, dimensions, density } = req.body;
    
    if (!name || !thermocol_type || !dimensions) {
      return res.status(400).json({ 
        success: false,
        error: 'Name, thermocol_type, and dimensions are required for thermocol material items' 
      });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ 
        success: false,
        error: 'Quantity must be a non-negative number' 
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      name, 
      category_id: 6, // Thermocol Materials category ID
      unit, 
      storage_location, 
      notes, 
      item_image, 
      quantity_available,
      thermocol_type,
      dimensions,
      density
    };

    const item = await InventoryModel.createThermocolMaterialItem(itemData);

    // Handle image file movement if uploaded
    if (req.file && item) {
      const fs = await import('fs');
      const path = await import('path');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', item.id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      fs.renameSync(tempPath, finalPath);
      
      const updatedItem = await InventoryModel.updateInventoryItem({
        id: item.id,
        name: item.name,
        category_id: item.category_id,
        unit: item.unit,
        storage_location: item.storage_location,
        notes: item.notes,
        item_image: `/uploads/inventory/items/${item.id}/${req.file.filename}`
      });
      
      // Get complete thermocol material item details with stock and thermocol-specific details
      const completeItem = await InventoryModel.getThermocolMaterialItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Thermocol material item created successfully',
        data: completeItem
      });
    } else {
      // Get complete thermocol material item details with stock and thermocol-specific details
      const completeItem = await InventoryModel.getThermocolMaterialItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Thermocol material item created successfully',
        data: completeItem
      });
    }
  } catch (error) {
    console.error('Error creating thermocol material item:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error creating thermocol material item' 
    });
  }
};

// Stationery
export const createStationeryItem = async (req, res) => {
  try {
    const { name, unit, storage_location, notes, quantity_available, specifications } = req.body;
    
    if (!name || !specifications) {
      return res.status(400).json({ 
        success: false,
        error: 'Name and specifications are required for stationery items' 
      });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ 
        success: false,
        error: 'Quantity must be a non-negative number' 
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      name, 
      category_id: 1, // Stationery category ID
      unit, 
      storage_location, 
      notes, 
      item_image, 
      quantity_available,
      specifications
    };

    const item = await InventoryModel.createStationeryItem(itemData);

    // Handle image file movement if uploaded
    if (req.file && item) {
      const fs = await import('fs');
      const path = await import('path');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', item.id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      fs.renameSync(tempPath, finalPath);
      
      const updatedItem = await InventoryModel.updateInventoryItem({
        id: item.id,
        name: item.name,
        category_id: item.category_id,
        unit: item.unit,
        storage_location: item.storage_location,
        notes: item.notes,
        item_image: `/uploads/inventory/items/${item.id}/${req.file.filename}`
      });
      
      // Get complete stationery item details with stock and stationery-specific details
      const completeItem = await InventoryModel.getStationeryItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Stationery item created successfully',
        data: completeItem
      });
    } else {
      // Get complete stationery item details with stock and stationery-specific details
      const completeItem = await InventoryModel.getStationeryItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Stationery item created successfully',
        data: completeItem
      });
    }
  } catch (error) {
    console.error('Error creating stationery item:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error creating stationery item' 
    });
  }
};

// Murti Sets
export const createMurtiSetItem = async (req, res) => {
  try {
    const { name, unit, storage_location, notes, quantity_available, set_number, material, dimensions } = req.body;
    
    if (!name || !set_number || !material || !dimensions) {
      return res.status(400).json({ 
        success: false,
        error: 'Name, set_number, material, and dimensions are required for murti set items' 
      });
    }

    // Validate quantity if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({ 
        success: false,
        error: 'Quantity must be a non-negative number' 
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      name, 
      category_id: 7, // Murti Sets category ID
      unit, 
      storage_location, 
      notes, 
      item_image, 
      quantity_available,
      set_number,
      material,
      dimensions
    };

    const item = await InventoryModel.createMurtiSetItem(itemData);

    // Handle image file movement if uploaded
    if (req.file && item) {
      const fs = await import('fs');
      const path = await import('path');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', item.id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      fs.renameSync(tempPath, finalPath);
      
      const updatedItem = await InventoryModel.updateInventoryItem({
        id: item.id,
        name: item.name,
        category_id: item.category_id,
        unit: item.unit,
        storage_location: item.storage_location,
        notes: item.notes,
        item_image: `/uploads/inventory/items/${item.id}/${req.file.filename}`
      });
      
      // Get complete murti set item details with stock and murti-specific details
      const completeItem = await InventoryModel.getMurtiSetItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Murti set item created successfully',
        data: completeItem
      });
    } else {
      // Get complete murti set item details with stock and murti-specific details
      const completeItem = await InventoryModel.getMurtiSetItemById(item.id);
      
      res.status(201).json({
        success: true,
        message: 'Murti set item created successfully',
        data: completeItem
      });
    }
  } catch (error) {
    console.error('Error creating murti set item:', error);
    res.status(500).json({ 
      success: false,
      error: 'Error creating murti set item' 
    });
  }
};

// Category-specific update controllers
// Furniture
export const updateFurnitureItem = async (req, res) => {
  try {
    const { id, name, unit, storage_location, notes, material, dimensions, quantity_available } = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        error: 'Item ID is required'
      });
    }

    if (!name || !material || !dimensions) {
      return res.status(400).json({
        success: false,
        error: 'Name, material, and dimensions are required for furniture items'
      });
    }

    // Validate quantity_available if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({
        success: false,
        error: 'Quantity must be a non-negative number'
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      id,
      name, 
      unit, 
      storage_location, 
      notes, 
      item_image,
      material,
      dimensions,
      quantity_available
    };

    const result = await InventoryModel.updateFurnitureItem(itemData);
    const { updatedItem, oldImagePath } = result;

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file && updatedItem) {
      const fs = await import('fs');
      const path = await import('path');
      const { deleteImageFile } = await import('../utils/imageUtils.js');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Delete the old image if it exists
      if (oldImagePath) {
        await deleteImageFile(oldImagePath);
      }
      
      // Update the item with the correct image path
      await InventoryModel.updateInventoryItem({
        id: parseInt(id),
        name,
        category_id: 2,
        unit,
        storage_location,
        notes,
        item_image: `/uploads/inventory/items/${id}/${req.file.filename}`
      });
    }

    // Get complete furniture item details with stock and furniture-specific details
    const completeItem = await InventoryModel.getFurnitureItemById(parseInt(id));

    res.json({
      success: true,
      message: 'Furniture item updated successfully',
      data: completeItem
    });
  } catch (error) {
    console.error('Error updating furniture item:', error);
    res.status(500).json({
      success: false,
      error: 'Error updating furniture item'
    });
  }
};

// Fabric
export const updateFabricItem = async (req, res) => {
  try {
    const { id, name, unit, storage_location, notes, fabric_type, pattern, width, length, color, quantity_available } = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        error: 'Item ID is required'
      });
    }

    if (!name || !fabric_type || !pattern || !width || !length || !color) {
      return res.status(400).json({
        success: false,
        error: 'Name, fabric type, pattern, width, length, and color are required for fabric items'
      });
    }

    // Validate quantity_available if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({
        success: false,
        error: 'Quantity must be a non-negative number'
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      id,
      name, 
      unit, 
      storage_location, 
      notes, 
      item_image,
      fabric_type,
      pattern,
      width,
      length,
      color,
      quantity_available
    };

    const result = await InventoryModel.updateFabricItem(itemData);
    const { updatedItem, oldImagePath } = result;

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file && updatedItem) {
      const fs = await import('fs');
      const path = await import('path');
      const { deleteImageFile } = await import('../utils/imageUtils.js');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Delete the old image if it exists
      if (oldImagePath) {
        await deleteImageFile(oldImagePath);
      }
      
      // Update the item with the correct image path
      await InventoryModel.updateInventoryItem({
        id: parseInt(id),
        name,
        category_id: 3,
        unit,
        storage_location,
        notes,
        item_image: `/uploads/inventory/items/${id}/${req.file.filename}`
      });
    }

    // Get complete fabric item details with stock and fabric-specific details
    const completeItem = await InventoryModel.getFabricItemById(parseInt(id));

    res.json({
      success: true,
      message: 'Fabric item updated successfully',
      data: completeItem
    });
  } catch (error) {
    console.error('Error updating fabric item:', error);
    res.status(500).json({
      success: false,
      error: 'Error updating fabric item'
    });
  }
};

// Frame Structures
export const updateFrameStructureItem = async (req, res) => {
  try {
    const { id, name, unit, storage_location, notes, frame_type, material, dimensions, quantity_available } = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        error: 'Item ID is required'
      });
    }

    if (!name || !frame_type || !material || !dimensions) {
      return res.status(400).json({
        success: false,
        error: 'Name, frame type, material, and dimensions are required for frame structure items'
      });
    }

    // Validate quantity_available if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({
        success: false,
        error: 'Quantity must be a non-negative number'
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      id,
      name, 
      unit, 
      storage_location, 
      notes, 
      item_image,
      frame_type,
      material,
      dimensions,
      quantity_available
    };

    const result = await InventoryModel.updateFrameStructureItem(itemData);
    const { updatedItem, oldImagePath } = result;

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file && updatedItem) {
      const fs = await import('fs');
      const path = await import('path');
      const { deleteImageFile } = await import('../utils/imageUtils.js');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Delete the old image if it exists
      if (oldImagePath) {
        await deleteImageFile(oldImagePath);
      }
      
      // Update the item with the correct image path
      await InventoryModel.updateInventoryItem({
        id: parseInt(id),
        name,
        category_id: 4,
        unit,
        storage_location,
        notes,
        item_image: `/uploads/inventory/items/${id}/${req.file.filename}`
      });
    }

    // Get complete frame structure item details with stock and frame structure-specific details
    const completeItem = await InventoryModel.getFrameStructureItemById(parseInt(id));

    res.json({
      success: true,
      message: 'Frame structure item updated successfully',
      data: completeItem
    });
  } catch (error) {
    console.error('Error updating frame structure item:', error);
    res.status(500).json({
      success: false,
      error: 'Error updating frame structure item'
    });
  }
};

// Carpets
export const updateCarpetItem = async (req, res) => {
  try {
    const { id, name, unit, storage_location, notes, carpet_type, material, size, quantity_available } = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        error: 'Item ID is required'
      });
    }

    if (!name || !carpet_type || !material || !size) {
      return res.status(400).json({
        success: false,
        error: 'Name, carpet type, material, and size are required for carpet items'
      });
    }

    // Validate quantity_available if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({
        success: false,
        error: 'Quantity must be a non-negative number'
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      id,
      name, 
      unit, 
      storage_location, 
      notes, 
      item_image,
      carpet_type,
      material,
      size,
      quantity_available
    };

    const result = await InventoryModel.updateCarpetItem(itemData);
    const { updatedItem, oldImagePath } = result;

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file && updatedItem) {
      const fs = await import('fs');
      const path = await import('path');
      const { deleteImageFile } = await import('../utils/imageUtils.js');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Delete the old image if it exists
      if (oldImagePath) {
        await deleteImageFile(oldImagePath);
      }
      
      // Update the item with the correct image path
      await InventoryModel.updateInventoryItem({
        id: parseInt(id),
        name,
        category_id: 5,
        unit,
        storage_location,
        notes,
        item_image: `/uploads/inventory/items/${id}/${req.file.filename}`
      });
    }

    // Get complete carpet item details with stock and carpet-specific details
    const completeItem = await InventoryModel.getCarpetItemById(parseInt(id));

    res.json({
      success: true,
      message: 'Carpet item updated successfully',
      data: completeItem
    });
  } catch (error) {
    console.error('Error updating carpet item:', error);
    res.status(500).json({
      success: false,
      error: 'Error updating carpet item'
    });
  }
};

// Thermocol Materials
export const updateThermocolMaterialItem = async (req, res) => {
  try {
    const { id, name, unit, storage_location, notes, thermocol_type, density, dimensions, quantity_available } = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        error: 'Item ID is required'
      });
    }

    if (!name || !thermocol_type || !density || !dimensions) {
      return res.status(400).json({
        success: false,
        error: 'Name, thermocol_type, density, and dimensions are required for thermocol material items'
      });
    }

    // Validate quantity_available if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({
        success: false,
        error: 'Quantity must be a non-negative number'
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      id,
      name, 
      unit, 
      storage_location, 
      notes, 
      item_image,
      thermocol_type,
      density,
      dimensions,
      quantity_available
    };

    const result = await InventoryModel.updateThermocolMaterialItem(itemData);
    const { updatedItem, oldImagePath } = result;

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file && updatedItem) {
      const fs = await import('fs');
      const path = await import('path');
      const { deleteImageFile } = await import('../utils/imageUtils.js');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Delete the old image if it exists
      if (oldImagePath) {
        await deleteImageFile(oldImagePath);
      }
      
      // Update the item with the correct image path
      await InventoryModel.updateInventoryItem({
        id: parseInt(id),
        name,
        category_id: 6,
        unit,
        storage_location,
        notes,
        item_image: `/uploads/inventory/items/${id}/${req.file.filename}`
      });
    }

    // Get complete thermocol material item details with stock and thermocol material-specific details
    const completeItem = await InventoryModel.getThermocolMaterialItemById(parseInt(id));

    // Format the response to include thermocol_details object
    const formattedResponse = {
      ...completeItem,
      thermocol_details: {
        thermocol_type: completeItem.thermocol_type,
        density: completeItem.density,
        dimensions: completeItem.dimensions
      }
    };

    res.json({
      success: true,
      message: 'Thermocol material item updated successfully',
      data: formattedResponse
    });
  } catch (error) {
    console.error('Error updating thermocol material item:', error);
    res.status(500).json({
      success: false,
      error: 'Error updating thermocol material item'
    });
  }
};

// Stationery
export const updateStationeryItem = async (req, res) => {
  try {
    const { id, name, unit, storage_location, notes, specifications, quantity_available } = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        error: 'Item ID is required'
      });
    }

    if (!name || !specifications) {
      return res.status(400).json({
        success: false,
        error: 'Name and specifications are required for stationery items'
      });
    }

    // Validate quantity_available if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({
        success: false,
        error: 'Quantity must be a non-negative number'
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      id,
      name, 
      unit, 
      storage_location, 
      notes, 
      item_image,
      specifications,
      quantity_available
    };

    const result = await InventoryModel.updateStationeryItem(itemData);
    const { updatedItem, oldImagePath } = result;

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file && updatedItem) {
      const fs = await import('fs');
      const path = await import('path');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Delete the old image if it exists
      if (oldImagePath) {
        const { deleteImageFile } = await import('../utils/imageUtils.js');
        await deleteImageFile(oldImagePath);
      }
      
      // Update the item with the correct image path
      await InventoryModel.updateInventoryItem({
        id: parseInt(id),
        name,
        category_id: 1,
        unit,
        storage_location,
        notes,
        item_image: `/uploads/inventory/items/${id}/${req.file.filename}`
      });
    }

    // Get complete stationery item details with stock and stationery-specific details
    const completeItem = await InventoryModel.getStationeryItemById(parseInt(id));

    // Format the response to include stationery_details object
    const formattedResponse = {
      ...completeItem,
      stationery_details: {
        specifications: completeItem.specifications
      }
    };

    res.json({
      success: true,
      message: 'Stationery item updated successfully',
      data: formattedResponse
    });
  } catch (error) {
    console.error('Error updating stationery item:', error);
    res.status(500).json({
      success: false,
      error: 'Error updating stationery item'
    });
  }
};

// Murti Sets
export const updateMurtiSetItem = async (req, res) => {
  try {
    const { id, name, unit, storage_location, notes, set_number, material, dimensions, quantity_available } = req.body;

    if (!id) {
      return res.status(400).json({
        success: false,
        error: 'Item ID is required'
      });
    }

    if (!name || !set_number || !material || !dimensions) {
      return res.status(400).json({
        success: false,
        error: 'Name, set number, material, and dimensions are required for murti set items'
      });
    }

    // Validate quantity_available if provided
    if (quantity_available !== undefined && (isNaN(quantity_available) || quantity_available < 0)) {
      return res.status(400).json({
        success: false,
        error: 'Quantity must be a non-negative number'
      });
    }

    // Handle image upload
    let item_image = null;
    if (req.file) {
      item_image = `/uploads/inventory/items/temp/${req.file.filename}`;
    }

    const itemData = { 
      id,
      name, 
      unit, 
      storage_location, 
      notes, 
      item_image,
      set_number,
      material,
      dimensions,
      quantity_available
    };

    const result = await InventoryModel.updateMurtiSetItem(itemData);
    const { updatedItem, oldImagePath } = result;

    // If we have an uploaded file, move it to the correct location and delete old image
    if (req.file && updatedItem) {
      const fs = await import('fs');
      const path = await import('path');
      const { deleteImageFile } = await import('../utils/imageUtils.js');
      
      const tempPath = req.file.path;
      const finalDir = path.join('uploads', 'inventory', 'items', id.toString());
      const finalPath = path.join(finalDir, req.file.filename);
      
      // Create the final directory if it doesn't exist
      if (!fs.existsSync(finalDir)) {
        fs.mkdirSync(finalDir, { recursive: true });
      }
      
      // Move the file to the final location
      fs.renameSync(tempPath, finalPath);
      
      // Delete the old image if it exists
      if (oldImagePath) {
        await deleteImageFile(oldImagePath);
      }
      
      // Update the item with the correct image path
      await InventoryModel.updateInventoryItem({
        id: parseInt(id),
        name,
        category_id: 7,
        unit,
        storage_location,
        notes,
        item_image: `/uploads/inventory/items/${id}/${req.file.filename}`
      });
    }

    // Get complete murti set item details with stock and murti set-specific details
    const completeItem = await InventoryModel.getMurtiSetItemById(parseInt(id));

    res.json({
      success: true,
      message: 'Murti set item updated successfully',
      data: completeItem
    });
  } catch (error) {
    console.error('Error updating murti set item:', error);
    res.status(500).json({
      success: false,
      error: 'Error updating murti set item'
    });
  }
}; 