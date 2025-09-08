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
      c.name as category_name,
      COALESCE(stock.quantity_available, 0) as available_quantity,
      -- Furniture details
      f.material as furniture_material,
      f.dimensions as furniture_dimensions,
      -- Fabric details
      fab.fabric_type,
      fab.pattern as fabric_pattern,
      fab.width as fabric_width,
      fab.length as fabric_length,
      fab.color as fabric_color,
      -- Frame Structure details
      fs.frame_type,
      fs.material as frame_material,
      fs.dimensions as frame_dimensions,
      -- Carpet details
      car.carpet_type,
      car.material as carpet_material,
      car.size as carpet_size,
      -- Thermocol Material details
      tm.thermocol_type,
      tm.density,
      tm.dimensions as thermocol_dimensions,
      -- Stationery details
      s.specifications as stationery_specifications,
      -- Murti Set details
      ms.set_number,
      ms.material as murti_material,
      ms.dimensions as murti_dimensions
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    LEFT JOIN furniture f ON ii.id = f.item_id
    LEFT JOIN fabric fab ON ii.id = fab.item_id
    LEFT JOIN frame_structures fs ON ii.id = fs.item_id
    LEFT JOIN carpets car ON ii.id = car.item_id
    LEFT JOIN thermocol_materials tm ON ii.id = tm.item_id
    LEFT JOIN stationery s ON ii.id = s.item_id
    LEFT JOIN murti_sets ms ON ii.id = ms.item_id
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getInventoryItemList = async () => {
  const result = await pool.query('SELECT id, name FROM inventory_items ORDER BY name ASC');
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
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the item details to determine the category
    const itemResult = await client.query(
      'SELECT id, category_id, name FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (itemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const item = itemResult.rows[0];
    const categoryId = item.category_id;
    
    // Delete from category-specific table based on category_id
    switch (categoryId) {
      case 1: // Stationery
        await client.query('DELETE FROM stationery WHERE item_id = $1', [id]);
        break;
      case 2: // Furniture
        await client.query('DELETE FROM furniture WHERE item_id = $1', [id]);
        break;
      case 3: // Fabric
        await client.query('DELETE FROM fabric WHERE item_id = $1', [id]);
        break;
      case 4: // Frame Structures
        await client.query('DELETE FROM frame_structures WHERE item_id = $1', [id]);
        break;
      case 5: // Carpets
        await client.query('DELETE FROM carpets WHERE item_id = $1', [id]);
        break;
      case 6: // Thermocol Materials
        await client.query('DELETE FROM thermocol_materials WHERE item_id = $1', [id]);
        break;
      case 7: // Murti Sets
        await client.query('DELETE FROM murti_sets WHERE item_id = $1', [id]);
        break;
      default:
        throw new Error('Invalid category ID');
    }
    
    // Delete from inventory_stock table
    await client.query('DELETE FROM inventory_stock WHERE item_id = $1', [id]);
    
    // Delete from inventory_items table (this will cascade delete any other references)
    const deleteResult = await client.query('DELETE FROM inventory_items WHERE id = $1 RETURNING *', [id]);
    
    await client.query('COMMIT');
    return deleteResult.rows[0];
    
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
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

export const getMaterialIssuanceHistoryByItemId = async (itemId) => {
  const result = await pool.query(`
    SELECT 
      mi.id,
      mi.item_id,
      mi.quantity_issued,
      mi.notes,
      mi.issued_at,
      mi.transaction_type,
      mi.event_id,
      ii.name as item_name,
      c.name as category_name,
      ii.unit,
      ii.storage_location
    FROM material_issuances mi
    LEFT JOIN inventory_items ii ON mi.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    WHERE mi.item_id = $1
    ORDER BY mi.issued_at DESC
  `, [itemId]);
  return result.rows;
};

export const getMaterialIssuanceHistoryByEventId = async (eventId) => {
  const result = await pool.query(`
    SELECT 
      mi.id,
      mi.item_id,
      mi.quantity_issued,
      mi.notes,
      mi.issued_at,
      mi.transaction_type,
      mi.event_id,
      ii.name as item_name,
      c.name as category_name,
      ii.unit,
      ii.storage_location,
      ii.item_image
    FROM material_issuances mi
    LEFT JOIN inventory_items ii ON mi.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    WHERE mi.event_id = $1
    ORDER BY mi.issued_at DESC
  `, [eventId]);
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
    'INSERT INTO furniture (id, item_id, material, dimensions) VALUES (DEFAULT, $1, $2, $3) RETURNING *',
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
    'INSERT INTO fabric (id, item_id, fabric_type, pattern, width, length, color) VALUES (DEFAULT, $1, $2, $3, $4, $5, $6) RETURNING *',
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
    'INSERT INTO frame_structures (id, item_id, frame_type, material, dimensions) VALUES (DEFAULT, $1, $2, $3, $4) RETURNING *',
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
    'INSERT INTO carpets (id, item_id, carpet_type, material, size) VALUES (DEFAULT, $1, $2, $3, $4) RETURNING *',
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
    'INSERT INTO thermocol_materials (id, item_id, thermocol_type, dimensions, density) VALUES (DEFAULT, $1, $2, $3, $4) RETURNING *',
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
    'INSERT INTO stationery (id, item_id, specifications) VALUES (DEFAULT, $1, $2) RETURNING *',
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
    'INSERT INTO murti_sets (id, item_id, set_number, material, dimensions) VALUES (DEFAULT, $1, $2, $3, $4) RETURNING *',
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
          case 'frame structures':
            await createFrameStructure({ item_id: item.id, ...categoryDetails });
            break;
          case 'carpets':
            await createCarpet({ item_id: item.id, ...categoryDetails });
            break;
          case 'thermocol materials':
            await createThermocolMaterial({ item_id: item.id, ...categoryDetails });
            break;
          case 'stationery':
            await createStationery({ item_id: item.id, ...categoryDetails });
            break;
          case 'murti sets':
            await createMurtiSet({ item_id: item.id, ...categoryDetails });
            break;
          default:
            console.log('No matching category found for:', category.name.toLowerCase());
            break;
        }
      }
    }
    
    // Initialize stock with provided quantity or 0
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Category-specific API functions
// Furniture
export const getAllFurnitureItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      f.material,
      f.dimensions,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN furniture f ON ii.id = f.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE c.name = 'Furniture'
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getFurnitureItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      f.material,
      f.dimensions,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN furniture f ON ii.id = f.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE ii.id = $1 AND c.name = 'Furniture'
  `, [id]);
  return result.rows[0];
};

// Fabric
export const getAllFabricItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      f.fabric_type,
      f.pattern,
      f.width,
      f.length,
      f.color,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN fabric f ON ii.id = f.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE c.name = 'Fabric'
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getFabricItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      f.fabric_type,
      f.pattern,
      f.width,
      f.length,
      f.color,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN fabric f ON ii.id = f.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE ii.id = $1 AND c.name = 'Fabric'
  `, [id]);
  return result.rows[0];
};

// Frame Structures
export const getAllFrameStructureItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      fs.frame_type,
      fs.material,
      fs.dimensions,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN frame_structures fs ON ii.id = fs.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE c.name = 'Frame Structures'
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getFrameStructureItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      fs.frame_type,
      fs.material,
      fs.dimensions,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN frame_structures fs ON ii.id = fs.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE ii.id = $1 AND c.name = 'Frame Structures'
  `, [id]);
  return result.rows[0];
};

// Carpets
export const getAllCarpetItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      car.carpet_type,
      car.material,
      car.size,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN carpets car ON ii.id = car.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE c.name = 'Carpets'
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getCarpetItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      car.carpet_type,
      car.material,
      car.size,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN carpets car ON ii.id = car.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE ii.id = $1 AND c.name = 'Carpets'
  `, [id]);
  return result.rows[0];
};

// Thermocol Materials
export const getAllThermocolMaterialItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      tm.thermocol_type,
      tm.dimensions,
      tm.density,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN thermocol_materials tm ON ii.id = tm.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE c.name = 'Thermocol Materials'
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getThermocolMaterialItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      tm.thermocol_type,
      tm.dimensions,
      tm.density,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN thermocol_materials tm ON ii.id = tm.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE ii.id = $1 AND c.name = 'Thermocol Materials'
  `, [id]);
  return result.rows[0];
};

// Stationery
export const getAllStationeryItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      s.specifications,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN stationery s ON ii.id = s.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE c.name = 'Stationery'
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getStationeryItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      s.specifications,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN stationery s ON ii.id = s.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE ii.id = $1 AND c.name = 'Stationery'
  `, [id]);
  return result.rows[0];
};

// Murti Sets
export const getAllMurtiSetItems = async () => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      ms.set_number,
      ms.material,
      ms.dimensions,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN murti_sets ms ON ii.id = ms.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE c.name = 'Murti Sets'
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getMurtiSetItemById = async (id) => {
  const result = await pool.query(`
    SELECT 
      ii.*,
      c.name as category_name,
      ms.set_number,
      ms.material,
      ms.dimensions,
      COALESCE(stock.quantity_available, 0) as available_quantity
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN murti_sets ms ON ii.id = ms.item_id
    LEFT JOIN inventory_stock stock ON ii.id = stock.item_id
    WHERE ii.id = $1 AND c.name = 'Murti Sets'
  `, [id]);
  return result.rows[0];
};

// Category-specific create functions
// Furniture
export const createFurnitureItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // Create furniture-specific details
    const { material, dimensions } = itemData;
    await createFurniture({ item_id: item.id, material, dimensions });
    
    // Initialize stock
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Fabric
export const createFabricItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // Create fabric-specific details
    const { fabric_type, pattern, width, length, color } = itemData;
    await createFabric({ item_id: item.id, fabric_type, pattern, width, length, color });
    
    // Initialize stock
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Frame Structures
export const createFrameStructureItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // Create frame structure-specific details
    const { frame_type, material, dimensions } = itemData;
    await createFrameStructure({ item_id: item.id, frame_type, material, dimensions });
    
    // Initialize stock
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Carpets
export const createCarpetItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // Create carpet-specific details
    const { carpet_type, material, size } = itemData;
    await createCarpet({ item_id: item.id, carpet_type, material, size });
    
    // Initialize stock
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Thermocol Materials
export const createThermocolMaterialItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // Create thermocol material-specific details
    const { thermocol_type, dimensions, density } = itemData;
    await createThermocolMaterial({ item_id: item.id, thermocol_type, dimensions, density });
    
    // Initialize stock
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Stationery
export const createStationeryItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // Create stationery-specific details
    const { specifications } = itemData;
    await createStationery({ item_id: item.id, specifications });
    
    // Initialize stock
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Murti Sets
export const createMurtiSetItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const item = await createInventoryItem(itemData);
    
    // Create murti set-specific details
    const { set_number, material, dimensions } = itemData;
    await createMurtiSet({ item_id: item.id, set_number, material, dimensions });
    
    // Initialize stock
    const initialQuantity = itemData.quantity_available || 0;
    await createStock({ item_id: item.id, quantity_available: initialQuantity });
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Category-specific update functions
// Furniture
export const updateFurnitureItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the old image path before updating
    const { id, name, unit, storage_location, notes, item_image, material, dimensions, quantity_available } = itemData;
    const oldItemResult = await client.query(
      'SELECT item_image FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (oldItemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const oldImagePath = oldItemResult.rows[0].item_image;
    
    // Update the inventory item (without image first)
    const itemResult = await client.query(
      'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5 WHERE id = $6 RETURNING *',
      [name, 2, unit, storage_location, notes, id]
    );
    
    // Update furniture-specific details
    const furnitureResult = await client.query(
      'UPDATE furniture SET material = $1, dimensions = $2 WHERE item_id = $3 RETURNING *',
      [material, dimensions, id]
    );
    
    // Update stock quantity if provided
    if (quantity_available !== undefined && quantity_available !== null) {
      await client.query(
        'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
        [quantity_available, id]
      );
    }

    await client.query('COMMIT');
    return { updatedItem: itemResult.rows[0], oldImagePath };
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Fabric
export const updateFabricItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the old image path before updating
    const { id, name, unit, storage_location, notes, item_image, fabric_type, pattern, width, length, color, quantity_available } = itemData;
    const oldItemResult = await client.query(
      'SELECT item_image FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (oldItemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const oldImagePath = oldItemResult.rows[0].item_image;
    
    // Update the inventory item (without image first)
    const itemResult = await client.query(
      'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5 WHERE id = $6 RETURNING *',
      [name, 3, unit, storage_location, notes, id]
    );
    
    // Update fabric-specific details
    const fabricResult = await client.query(
      'UPDATE fabric SET fabric_type = $1, pattern = $2, width = $3, length = $4, color = $5 WHERE item_id = $6 RETURNING *',
      [fabric_type, pattern, width, length, color, id]
    );
    
    // Update stock quantity if provided
    if (quantity_available !== undefined && quantity_available !== null) {
      await client.query(
        'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
        [quantity_available, id]
      );
    }
    
    await client.query('COMMIT');
    return { updatedItem: itemResult.rows[0], oldImagePath };
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Frame Structures
export const updateFrameStructureItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the old image path before updating
    const { id, name, unit, storage_location, notes, item_image, frame_type, material, dimensions, quantity_available } = itemData;
    const oldItemResult = await client.query(
      'SELECT item_image FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (oldItemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const oldImagePath = oldItemResult.rows[0].item_image;
    
    // Update the inventory item (without image first)
    const itemResult = await client.query(
      'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5 WHERE id = $6 RETURNING *',
      [name, 4, unit, storage_location, notes, id]
    );
    
    // Update frame structure-specific details
    const frameResult = await client.query(
      'UPDATE frame_structures SET frame_type = $1, material = $2, dimensions = $3 WHERE item_id = $4 RETURNING *',
      [frame_type, material, dimensions, id]
    );
    
    // Update stock quantity if provided
    if (quantity_available !== undefined && quantity_available !== null) {
      await client.query(
        'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
        [quantity_available, id]
      );
    }

    await client.query('COMMIT');
    return { updatedItem: itemResult.rows[0], oldImagePath };
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Carpets
export const updateCarpetItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the old image path before updating
    const { id, name, unit, storage_location, notes, item_image, carpet_type, material, size, quantity_available } = itemData;
    const oldItemResult = await client.query(
      'SELECT item_image FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (oldItemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const oldImagePath = oldItemResult.rows[0].item_image;
    
    // Update the inventory item (without image first)
    const itemResult = await client.query(
      'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5 WHERE id = $6 RETURNING *',
      [name, 5, unit, storage_location, notes, id]
    );
    
    // Update carpet-specific details
    const carpetResult = await client.query(
      'UPDATE carpets SET carpet_type = $1, material = $2, size = $3 WHERE item_id = $4 RETURNING *',
      [carpet_type, material, size, id]
    );
    
    // Update stock quantity if provided
    if (quantity_available !== undefined && quantity_available !== null) {
      await client.query(
        'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
        [quantity_available, id]
      );
    }

    await client.query('COMMIT');
    return { updatedItem: itemResult.rows[0], oldImagePath };
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Thermocol Materials
export const updateThermocolMaterialItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the old image path before updating
    const { id, name, unit, storage_location, notes, item_image, thermocol_type, density, dimensions, quantity_available } = itemData;
    const oldItemResult = await client.query(
      'SELECT item_image FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (oldItemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const oldImagePath = oldItemResult.rows[0].item_image;
    
    // Update the inventory item (without image first)
    const itemResult = await client.query(
      'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5 WHERE id = $6 RETURNING *',
      [name, 6, unit, storage_location, notes, id]
    );
    
    // Update thermocol material-specific details
    const thermocolResult = await client.query(
      'UPDATE thermocol_materials SET thermocol_type = $1, density = $2, dimensions = $3 WHERE item_id = $4 RETURNING *',
      [thermocol_type, density, dimensions, id]
    );
    
    // Update stock quantity if provided
    if (quantity_available !== undefined && quantity_available !== null) {
      await client.query(
        'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
        [quantity_available, id]
      );
    }

    await client.query('COMMIT');
    return { updatedItem: itemResult.rows[0], oldImagePath };
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Stationery
export const updateStationeryItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the old image path before updating
    const { id, name, unit, storage_location, notes, item_image, specifications, quantity_available } = itemData;
    const oldItemResult = await client.query(
      'SELECT item_image FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (oldItemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const oldImagePath = oldItemResult.rows[0].item_image;
    
    // Update the inventory item (without image first)
    const itemResult = await client.query(
      'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5 WHERE id = $6 RETURNING *',
      [name, 1, unit, storage_location, notes, id]
    );
    
    // Update stationery-specific details
    const stationeryResult = await client.query(
      'UPDATE stationery SET specifications = $1 WHERE item_id = $2 RETURNING *',
      [specifications, id]
    );
    
    // Update stock quantity if provided
    if (quantity_available !== undefined && quantity_available !== null) {
      await client.query(
        'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
        [quantity_available, id]
      );
    }
    
    await client.query('COMMIT');
    return { updatedItem: itemResult.rows[0], oldImagePath };
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Murti Sets
export const updateMurtiSetItem = async (itemData) => {
  const client = await pool.connect();
  
  try {
    await client.query('BEGIN');
    
    // First get the old image path before updating
    const { id, name, unit, storage_location, notes, item_image, set_number, material, dimensions, quantity_available } = itemData;
    const oldItemResult = await client.query(
      'SELECT item_image FROM inventory_items WHERE id = $1',
      [id]
    );
    
    if (oldItemResult.rows.length === 0) {
      throw new Error('Inventory item not found');
    }
    
    const oldImagePath = oldItemResult.rows[0].item_image;
    
    // Update the inventory item (without image first)
    const itemResult = await client.query(
      'UPDATE inventory_items SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5 WHERE id = $6 RETURNING *',
      [name, 7, unit, storage_location, notes, id]
    );
    
    // Update murti set-specific details
    const murtiResult = await client.query(
      'UPDATE murti_sets SET set_number = $1, material = $2, dimensions = $3 WHERE item_id = $4 RETURNING *',
      [set_number, material, dimensions, id]
    );
    
    // Update stock quantity if provided
    if (quantity_available !== undefined && quantity_available !== null) {
      await client.query(
        'UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2',
        [quantity_available, id]
      );
    }
    
    await client.query('COMMIT');
    return { updatedItem: itemResult.rows[0], oldImagePath };
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};
