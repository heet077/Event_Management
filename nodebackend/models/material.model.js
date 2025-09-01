import pool from '../config/db.js';
import * as SpecializedInventory from './specializedInventory.model.js';

// Categories management
export const getAllCategories = async () => {
  const result = await pool.query('SELECT * FROM categories ORDER BY name');
  return result.rows;
};

export const createCategory = async ({ name }) => {
  const result = await pool.query(
    `INSERT INTO categories (name) VALUES ($1) RETURNING *`,
    [name]
  );
  return result.rows[0];
};

export const getCategoryById = async (id) => {
  const result = await pool.query('SELECT * FROM categories WHERE id = $1', [id]);
  return result.rows[0];
};

export const updateCategory = async (id, { name }) => {
  const result = await pool.query(
    `UPDATE categories SET name = $1 WHERE id = $2 RETURNING *`,
    [name, id]
  );
  return result.rows[0];
};

export const deleteCategory = async (id) => {
  await pool.query('DELETE FROM categories WHERE id = $1', [id]);
};

// Inventory Items management (replaces materials)
export const getAllMaterials = async () => {
  const result = await pool.query(`
    SELECT ii.*, c.name AS category_name, ist.quantity_available
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getMaterialById = async (id) => {
  const result = await pool.query(`
    SELECT ii.*, c.name AS category_name, ist.quantity_available
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    WHERE ii.id = $1
  `, [id]);
  return result.rows[0];
};

export const createMaterial = async ({ name, category_id, unit, storage_location, notes }) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    
    // Create the inventory item
    const itemResult = await client.query(
      `INSERT INTO inventory_items (name, category_id, unit, storage_location, notes)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [name, category_id, unit, storage_location, notes]
    );
    
    const item = itemResult.rows[0];
    
    // Create corresponding stock entry
    await client.query(
      `INSERT INTO inventory_stock (item_id, quantity_available)
       VALUES ($1, $2)`,
      [item.id, 0]
    );
    
    await client.query('COMMIT');
    return item;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Create material with specialized details
export const createMaterialWithSpecializedDetails = async (materialData, specializedData) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    
    // Create the base inventory item
    const item = await createMaterial(materialData);
    
    // Create specialized inventory based on category
    if (specializedData) {
      const category = await getCategoryById(materialData.category_id);
      
      switch (category.name.toLowerCase()) {
        case 'furniture':
          await SpecializedInventory.createFurniture({
            item_id: item.id,
            ...specializedData
          });
          break;
          
        case 'fabric':
          await SpecializedInventory.createFabric({
            item_id: item.id,
            ...specializedData
          });
          break;
          
        case 'frame structures':
        case 'frame_structures':
          await SpecializedInventory.createFrameStructure({
            item_id: item.id,
            ...specializedData
          });
          break;
          
        case 'carpets':
          await SpecializedInventory.createCarpet({
            item_id: item.id,
            ...specializedData
          });
          break;
          
        case 'thermocol':
        case 'thermocol materials':
          await SpecializedInventory.createThermocolMaterial({
            item_id: item.id,
            ...specializedData
          });
          break;
          
        case 'stationery':
          await SpecializedInventory.createStationery({
            item_id: item.id,
            ...specializedData
          });
          break;
          
        case 'murti sets':
        case 'murti_sets':
          await SpecializedInventory.createMurtiSet({
            item_id: item.id,
            ...specializedData
          });
          break;
      }
    }
    
    await client.query('COMMIT');
    
    // Return the complete item with specialized details
    return await getInventoryWithSpecializedDetails(item.id);
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

export const updateMaterial = async (id, { name, category_id, unit, storage_location, notes }) => {
  const result = await pool.query(
    `UPDATE inventory_items 
     SET name = $1, category_id = $2, unit = $3, storage_location = $4, notes = $5
     WHERE id = $6 RETURNING *`,
    [name, category_id, unit, storage_location, notes, id]
  );
  return result.rows[0];
};

export const deleteMaterial = async (id) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    
    // Delete specialized inventory first (due to foreign key)
    const item = await getMaterialById(id);
    if (item) {
      const category = await getCategoryById(item.category_id);
      
      switch (category.name.toLowerCase()) {
        case 'furniture':
          await SpecializedInventory.deleteFurniture(id);
          break;
        case 'fabric':
          await SpecializedInventory.deleteFabric(id);
          break;
        case 'frame structures':
        case 'frame_structures':
          await SpecializedInventory.deleteFrameStructure(id);
          break;
        case 'carpets':
          await SpecializedInventory.deleteCarpet(id);
          break;
        case 'thermocol':
        case 'thermocol materials':
          await SpecializedInventory.deleteThermocolMaterial(id);
          break;
        case 'stationery':
          await SpecializedInventory.deleteStationery(id);
          break;
        case 'murti sets':
        case 'murti_sets':
          await SpecializedInventory.deleteMurtiSet(id);
          break;
      }
    }
    
    // Delete stock entry first (due to foreign key)
    await client.query('DELETE FROM inventory_stock WHERE item_id = $1', [id]);
    
    // Delete the item
    await client.query('DELETE FROM inventory_items WHERE id = $1', [id]);
    
    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};

// Get inventory with specialized details
export const getInventoryWithSpecializedDetails = async (item_id) => {
  return await SpecializedInventory.getInventoryWithSpecializedDetails(item_id);
};

// Get specialized inventory by category
export const getSpecializedInventoryByCategory = async (category_id) => {
  return await SpecializedInventory.getSpecializedInventoryByCategory(category_id);
};

// Search materials by name or category
export const searchMaterials = async (searchTerm) => {
  const result = await pool.query(`
    SELECT ii.*, c.name AS category_name, ist.quantity_available
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    WHERE ii.name ILIKE $1 OR c.name ILIKE $1
    ORDER BY ii.name
  `, [`%${searchTerm}%`]);
  return result.rows;
};

// Get materials by category
export const getMaterialsByCategory = async (category_id) => {
  const result = await pool.query(`
    SELECT ii.*, c.name AS category_name, ist.quantity_available
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    WHERE ii.category_id = $1
    ORDER BY ii.name
  `, [category_id]);
  return result.rows;
};

// ======================================
// Image Management
// ======================================

export const addItemImage = async ({ item_id, image_url }) => {
  const result = await pool.query(
    `INSERT INTO inventory_item_images (item_id, image_url) VALUES ($1, $2) RETURNING *`,
    [item_id, image_url]
  );
  return result.rows[0];
};

export const getItemImages = async (item_id) => {
  const result = await pool.query(
    `SELECT * FROM inventory_item_images WHERE item_id = $1 ORDER BY uploaded_at DESC`,
    [item_id]
  );
  return result.rows;
};

export const deleteItemImage = async (image_id) => {
  const result = await pool.query(
    `DELETE FROM inventory_item_images WHERE id = $1 RETURNING *`,
    [image_id]
  );
  return result.rows[0];
};

export const updateItemImage = async (image_id, { image_url }) => {
  const result = await pool.query(
    `UPDATE inventory_item_images SET image_url = $1 WHERE id = $2 RETURNING *`,
    [image_url, image_id]
  );
  return result.rows[0];
};

export const getInventoryWithImages = async (item_id) => {
  const result = await pool.query(`
    SELECT ii.*, c.name as category_name, ist.quantity_available,
           array_agg(
             json_build_object(
               'id', img.id,
               'image_url', img.image_url,
               'uploaded_at', img.uploaded_at
             )
           ) FILTER (WHERE img.id IS NOT NULL) as images
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    LEFT JOIN inventory_item_images img ON ii.id = img.item_id
    WHERE ii.id = $1
    GROUP BY ii.id, c.name, ist.quantity_available
  `, [item_id]);
  return result.rows[0];
};

export const getAllMaterialsWithImages = async () => {
  const result = await pool.query(`
    SELECT ii.*, c.name as category_name, ist.quantity_available,
           array_agg(
             json_build_object(
               'id', img.id,
               'image_url', img.image_url,
               'uploaded_at', img.uploaded_at
             )
           ) FILTER (WHERE img.id IS NOT NULL) as images
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    LEFT JOIN inventory_item_images img ON ii.id = img.item_id
    GROUP BY ii.id, c.name, ist.quantity_available
    ORDER BY ii.name
  `);
  return result.rows;
};
