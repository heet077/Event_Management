import pool from '../config/db.js';

// Categories
export const createCategory = async ({ name }) => {
  const result = await pool.query(
    'INSERT INTO categories (name) VALUES ($1) RETURNING *',
    [name]
  );
  return result.rows[0];
};

export const getAllCategories = async () => {
  const result = await pool.query('SELECT * FROM categories ORDER BY name');
  return result.rows;
};

export const getCategoryById = async (id) => {
  const result = await pool.query('SELECT * FROM categories WHERE id = $1', [id]);
  return result.rows[0];
};

export const updateCategory = async ({ id, name }) => {
  const result = await pool.query(
    'UPDATE categories SET name = $1 WHERE id = $2 RETURNING *',
    [name, id]
  );
  return result.rows[0];
};

export const deleteCategory = async (id) => {
  const result = await pool.query('DELETE FROM categories WHERE id = $1 RETURNING *', [id]);
  return result.rows[0];
};

// Inventory Items
export const createInventoryItem = async ({ name, category_id, unit, storage_location, notes, item_image }) => {
  const result = await pool.query(
    'INSERT INTO inventory_items (name, category_id, unit, storage_location, notes, item_image) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
    [name, category_id, unit, storage_location, notes, item_image]
  );
  return result.rows[0];
};

export const getAllInventoryItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getInventoryItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    WHERE ii.id = $1
  `, [id]);
  return result.rows[0];
};

export const updateInventoryItem = async ({ id, name, category_id, unit, storage_location, notes, item_image }) => {
  const result = await pool.query(
    'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5, item_image = $6 WHERE id = $7 RETURNING *',
    [name, category_id, unit, storage_location, notes, item_image, id]
  );
  return result.rows[0];
};

export const deleteInventoryItem = async (id) => {
  const result = await pool.query('DELETE FROM inventory_items WHERE id = $1 RETURNING *', [id]);
  return result.rows[0];
};

// Stock
export const createStock = async ({ item_id, quantity_available }) => {
  const result = await pool.query(
    'INSERT INTO inventory_stock (item_id, quantity_available) VALUES ($1, $2) RETURNING *',
    [item_id, quantity_available]
  );
  return result.rows[0];
};

export const getStockByItemId = async (item_id) => {
  const result = await pool.query(
    'SELECT * FROM inventory_stock WHERE item_id = $1',
    [item_id]
  );
  return result.rows[0];
};

export const updateStock = async ({ item_id, quantity_available }) => {
  const result = await pool.query(
    'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2 RETURNING *',
    [quantity_available, item_id]
  );
  return result.rows[0];
};

export const getAllStock = async () => {
  const result = await pool.query(`
    SELECT 
      is.*,
      ii.name as item_name,
      c.name as category_name
    FROM inventory_stock is
    LEFT JOIN inventory_items ii ON is.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    ORDER BY ii.name
  `);
  return result.rows;
};

// Material Issuances
export const createMaterialIssuance = async ({ item_id, transaction_type, quantity, event_id, notes }) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the material issuance record
    const result = await client.query(
      'INSERT INTO material_issuances (item_id, transaction_type, quantity_issued, event_id, notes) VALUES ($1, $2, $3, $4, $5) RETURNING *',
      [item_id, transaction_type, quantity, event_id, notes]
    );
    
    // Update stock based on transaction type
    await updateStockForTransaction(client, item_id, transaction_type, quantity);
    
    await client.query('COMMIT');
    return result.rows[0];
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Helper function to update stock for transactions
export const updateStockForTransaction = async (client, item_id, transaction_type, quantity) => {
  // Get current stock
  const stockResult = await client.query(
    'SELECT quantity_available FROM inventory_stock WHERE item_id = $1',
    [item_id]
  );
  
  if (stockResult.rows.length === 0) {
    throw new Error('Stock record not found for this item');
  }
  
  const currentStock = parseFloat(stockResult.rows[0].quantity_available) || 0;
  const quantityNum = parseFloat(quantity) || 0;
  let newQuantity;
  
  // Update stock based on transaction type
  if (transaction_type === 'OUT') {
    // Items are being taken out - deduct from stock (debit)
    newQuantity = currentStock - quantityNum;
    if (newQuantity < 0) {
      throw new Error('Cannot deduct more than available stock');
    }
  } else if (transaction_type === 'IN') {
    // Items are being returned - add to stock (credit)
    newQuantity = currentStock + quantityNum;
  } else {
    throw new Error('Invalid transaction type');
  }
  
  // Ensure newQuantity is a valid number
  if (isNaN(newQuantity)) {
    throw new Error('Invalid quantity calculation');
  }
  
  // Update the stock
  await client.query(
    'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
    [newQuantity, item_id]
  );
  
  return newQuantity;
};

export const getAllMaterialIssuances = async () => {
  const result = await pool.query(`
    SELECT 
      mi.*,
      ii.name as item_name,
      c.name as category_name
    FROM material_issuances mi
    LEFT JOIN inventory_items ii ON mi.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    ORDER BY mi.created_at DESC
  `);
  return result.rows;
};

export const getMaterialIssuanceById = async (id) => {
  const result = await pool.query(`
    SELECT 
      mi.*,
      ii.name as item_name,
      c.name as category_name
    FROM material_issuances mi
    LEFT JOIN inventory_items ii ON mi.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    WHERE mi.id = $1
  `, [id]);
  return result.rows[0];
};

export const updateMaterialIssuance = async ({ id, item_id, transaction_type, quantity, event_id, notes }) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Get the original issuance to calculate stock adjustment
    const originalResult = await client.query(
      'SELECT item_id, transaction_type, quantity_issued FROM material_issuances WHERE id = $1',
      [id]
    );
    
    if (originalResult.rows.length === 0) {
      throw new Error('Material issuance not found');
    }
    
    const original = originalResult.rows[0];
    
    // Check if we're updating from OUT to IN with the same quantity
    const isSameQuantity = parseFloat(original.quantity_issued) === parseFloat(quantity);
    const isOutToIn = original.transaction_type === 'OUT' && transaction_type === 'IN';
    
    if (isOutToIn && isSameQuantity) {
      // Special case: OUT to IN with same quantity - just reverse the OUT
      await updateStockForTransaction(client, original.item_id, 'IN', original.quantity_issued);
    } else {
      // General case: reverse original and apply new
      // First, reverse the original transaction effect on stock
      if (original.transaction_type === 'OUT') {
        // Original was OUT (deducted from stock), so reverse by adding back
        await updateStockForTransaction(client, original.item_id, 'IN', original.quantity_issued);
      } else if (original.transaction_type === 'IN') {
        // Original was IN (added to stock), so reverse by deducting
        await updateStockForTransaction(client, original.item_id, 'OUT', original.quantity_issued);
      }
      
      // Then, apply the new transaction effect on stock
      await updateStockForTransaction(client, item_id, transaction_type, quantity);
    }
    
    // Update the material issuance record
    const result = await client.query(
      'UPDATE material_issuances SET item_id = $1, transaction_type = $2, quantity_issued = $3, event_id = $4, notes = $5 WHERE id = $6 RETURNING *',
      [item_id, transaction_type, quantity, event_id, notes, id]
    );
    
    await client.query('COMMIT');
    return result.rows[0];
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

export const deleteMaterialIssuance = async (id) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Get the issuance details before deleting
    const issuanceResult = await client.query(
      'SELECT item_id, transaction_type, quantity_issued FROM material_issuances WHERE id = $1',
      [id]
    );
    
    if (issuanceResult.rows.length === 0) {
      throw new Error('Material issuance not found');
    }
    
    const issuance = issuanceResult.rows[0];
    
    // Reverse the stock effect
    if (issuance.transaction_type === 'OUT') {
      // Original was OUT (deducted from stock), so reverse by adding back
      await updateStockForTransaction(client, issuance.item_id, 'IN', issuance.quantity_issued);
    } else if (issuance.transaction_type === 'IN') {
      // Original was IN (added to stock), so reverse by deducting
      await updateStockForTransaction(client, issuance.item_id, 'OUT', issuance.quantity_issued);
    }
    
    // Delete the material issuance record
    const result = await client.query('DELETE FROM material_issuances WHERE id = $1 RETURNING *', [id]);
    
    await client.query('COMMIT');
    return result.rows[0];
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Category-specific detail tables
// Furniture
export const createFurniture = async ({ item_id, material, dimensions }) => {
  const result = await pool.query(
    'INSERT INTO furniture (item_id, material, dimensions) VALUES ($1, $2, $3) RETURNING *',
    [item_id, material, dimensions]
  );
  return result.rows[0];
};

export const getFurnitureByItemId = async (item_id) => {
  const result = await pool.query('SELECT * FROM furniture WHERE item_id = $1', [item_id]);
  return result.rows[0];
};

export const updateFurniture = async ({ item_id, material, dimensions }) => {
  const result = await pool.query(
    'UPDATE furniture SET material = $1, dimensions = $2 WHERE item_id = $3 RETURNING *',
    [material, dimensions, item_id]
  );
  return result.rows[0];
};

// Fabric
export const createFabric = async ({ item_id, fabric_type, pattern, width, length, color }) => {
  const result = await pool.query(
    'INSERT INTO fabric (item_id, fabric_type, pattern, width, length, color) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
    [item_id, fabric_type, pattern, width, length, color]
  );
  return result.rows[0];
};

export const getFabricByItemId = async (item_id) => {
  const result = await pool.query('SELECT * FROM fabric WHERE item_id = $1', [item_id]);
  return result.rows[0];
};

export const updateFabric = async ({ item_id, fabric_type, pattern, width, length, color }) => {
  const result = await pool.query(
    'UPDATE fabric SET fabric_type = $1, pattern = $2, width = $3, length = $4, color = $5 WHERE item_id = $6 RETURNING *',
    [fabric_type, pattern, width, length, color, item_id]
  );
  return result.rows[0];
};

// Frame Structures
export const createFrameStructure = async ({ item_id, frame_type, material, dimensions }) => {
  const result = await pool.query(
    'INSERT INTO frame_structures (item_id, frame_type, material, dimensions) VALUES ($1, $2, $3, $4) RETURNING *',
    [item_id, frame_type, material, dimensions]
  );
  return result.rows[0];
};

export const getFrameStructureByItemId = async (item_id) => {
  const result = await pool.query('SELECT * FROM frame_structures WHERE item_id = $1', [item_id]);
  return result.rows[0];
};

export const updateFrameStructure = async ({ item_id, frame_type, material, dimensions }) => {
  const result = await pool.query(
    'UPDATE frame_structures SET frame_type = $1, material = $2, dimensions = $3 WHERE item_id = $4 RETURNING *',
    [frame_type, material, dimensions, item_id]
  );
  return result.rows[0];
};

// Carpets
export const createCarpet = async ({ item_id, carpet_type, material, size }) => {
  const result = await pool.query(
    'INSERT INTO carpets (item_id, carpet_type, material, size) VALUES ($1, $2, $3, $4) RETURNING *',
    [item_id, carpet_type, material, size]
  );
  return result.rows[0];
};

export const getCarpetByItemId = async (item_id) => {
  const result = await pool.query('SELECT * FROM carpets WHERE item_id = $1', [item_id]);
  return result.rows[0];
};

export const updateCarpet = async ({ item_id, carpet_type, material, size }) => {
  const result = await pool.query(
    'UPDATE carpets SET carpet_type = $1, material = $2, size = $3 WHERE item_id = $4 RETURNING *',
    [carpet_type, material, size, item_id]
  );
  return result.rows[0];
};

// Thermocol Materials
export const createThermocolMaterial = async ({ item_id, thermocol_type, dimensions, density }) => {
  const result = await pool.query(
    'INSERT INTO thermocol_materials (item_id, thermocol_type, dimensions, density) VALUES ($1, $2, $3, $4) RETURNING *',
    [item_id, thermocol_type, dimensions, density]
  );
  return result.rows[0];
};

export const getThermocolMaterialByItemId = async (item_id) => {
  const result = await pool.query('SELECT * FROM thermocol_materials WHERE item_id = $1', [item_id]);
  return result.rows[0];
};

export const updateThermocolMaterial = async ({ item_id, thermocol_type, dimensions, density }) => {
  const result = await pool.query(
    'UPDATE thermocol_materials SET thermocol_type = $1, dimensions = $2, density = $3 WHERE item_id = $4 RETURNING *',
    [thermocol_type, dimensions, density, item_id]
  );
  return result.rows[0];
};

// Stationery
export const createStationery = async ({ item_id, specifications }) => {
  const result = await pool.query(
    'INSERT INTO stationery (item_id, specifications) VALUES ($1, $2) RETURNING *',
    [item_id, specifications]
  );
  return result.rows[0];
};

export const getStationeryByItemId = async (item_id) => {
  const result = await pool.query('SELECT * FROM stationery WHERE item_id = $1', [item_id]);
  return result.rows[0];
};

export const updateStationery = async ({ item_id, specifications }) => {
  const result = await pool.query(
    'UPDATE stationery SET specifications = $1 WHERE item_id = $2 RETURNING *',
    [specifications, item_id]
  );
  return result.rows[0];
};

// Murti Sets
export const createMurtiSet = async ({ item_id, set_number, material, dimensions }) => {
  const result = await pool.query(
    'INSERT INTO murti_sets (item_id, set_number, material, dimensions) VALUES ($1, $2, $3, $4) RETURNING *',
    [item_id, set_number, material, dimensions]
  );
  return result.rows[0];
};

export const getMurtiSetByItemId = async (item_id) => {
  const result = await pool.query('SELECT * FROM murti_sets WHERE item_id = $1', [item_id]);
  return result.rows[0];
};

export const updateMurtiSet = async ({ item_id, set_number, material, dimensions }) => {
  const result = await pool.query(
    'UPDATE murti_sets SET set_number = $1, material = $2, dimensions = $3 WHERE item_id = $4 RETURNING *',
    [set_number, material, dimensions, item_id]
  );
  return result.rows[0];
};

// Helper function to get inventory item with category-specific details
export const getInventoryItemWithDetails = async (id) => {
  const item = await getInventoryItemById(id);
  if (!item) return null;

  const category = await getCategoryById(item.category_id);
  if (!category) return item;

  let details = null;
  switch (category.name.toLowerCase()) {
    case 'furniture':
      details = await getFurnitureByItemId(id);
      break;
    case 'fabric':
      details = await getFabricByItemId(id);
      break;
    case 'frame_structures':
    case 'frame structures':
      details = await getFrameStructureByItemId(id);
      break;
    case 'carpets':
      details = await getCarpetByItemId(id);
      break;
    case 'thermocol_materials':
    case 'thermocol materials':
      details = await getThermocolMaterialByItemId(id);
      break;
    case 'stationery':
      details = await getStationeryByItemId(id);
      break;
    case 'murti_sets':
    case 'murti sets':
      details = await getMurtiSetByItemId(id);
      break;
  }

  return {
    ...item,
    category_details: details
  };
};

// Helper function to create inventory item with category-specific details
export const createInventoryItemWithDetails = async (itemData, categoryDetails) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // If category details are provided, create them
    if (categoryDetails) {
      const category = await getCategoryById(itemData.category_id);
      if (category) {
        switch (category.name.toLowerCase()) {
          case 'furniture':
            await createFurniture({ item_id: item.id, ...categoryDetails });
            break;
          case 'fabric':
            await createFabric({ item_id: item.id, ...categoryDetails });
            break;
          case 'frame_structures':
          case 'frame structures':
            await createFrameStructure({ item_id: item.id, ...categoryDetails });
            break;
          case 'carpets':
            await createCarpet({ item_id: item.id, ...categoryDetails });
            break;
          case 'thermocol_materials':
          case 'thermocol materials':
            await createThermocolMaterial({ item_id: item.id, ...categoryDetails });
            break;
          case 'stationery':
            await createStationery({ item_id: item.id, ...categoryDetails });
            break;
          case 'murti_sets':
          case 'murti sets':
            await createMurtiSet({ item_id: item.id, ...categoryDetails });
            break;
        }
      }
    }
    
    // Initialize stock with 0 quantity
    await createStock({ item_id: item.id, quantity_available: 0 });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};
