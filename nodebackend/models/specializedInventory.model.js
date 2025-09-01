import pool from '../config/db.js';

// ======================================
// Furniture Management
// ======================================
export const createFurniture = async ({ item_id, material, dimensions }) => {
  const result = await pool.query(
    `INSERT INTO furniture (item_id, material, dimensions) VALUES ($1, $2, $3) RETURNING *`,
    [item_id, material, dimensions]
  );
  return result.rows[0];
};

export const getFurnitureByItemId = async (item_id) => {
  const result = await pool.query(
    `SELECT f.*, ii.name, ii.category_id, c.name as category_name
     FROM furniture f
     JOIN inventory_items ii ON f.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     WHERE f.item_id = $1`,
    [item_id]
  );
  return result.rows[0];
};

export const updateFurniture = async (item_id, { material, dimensions }) => {
  const result = await pool.query(
    `UPDATE furniture SET material = $1, dimensions = $2 WHERE item_id = $3 RETURNING *`,
    [material, dimensions, item_id]
  );
  return result.rows[0];
};

export const deleteFurniture = async (item_id) => {
  await pool.query('DELETE FROM furniture WHERE item_id = $1', [item_id]);
};

// ======================================
// Fabric Management
// ======================================
export const createFabric = async ({ item_id, fabric_type, pattern, width, length, color }) => {
  const result = await pool.query(
    `INSERT INTO fabric (item_id, fabric_type, pattern, width, length, color) 
     VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
    [item_id, fabric_type, pattern, width, length, color]
  );
  return result.rows[0];
};

export const getFabricByItemId = async (item_id) => {
  const result = await pool.query(
    `SELECT f.*, ii.name, ii.category_id, c.name as category_name
     FROM fabric f
     JOIN inventory_items ii ON f.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     WHERE f.item_id = $1`,
    [item_id]
  );
  return result.rows[0];
};

export const updateFabric = async (item_id, { fabric_type, pattern, width, length, color }) => {
  const result = await pool.query(
    `UPDATE fabric SET fabric_type = $1, pattern = $2, width = $3, length = $4, color = $5 
     WHERE item_id = $6 RETURNING *`,
    [fabric_type, pattern, width, length, color, item_id]
  );
  return result.rows[0];
};

export const deleteFabric = async (item_id) => {
  await pool.query('DELETE FROM fabric WHERE item_id = $1', [item_id]);
};

// ======================================
// Frame Structures Management
// ======================================
export const createFrameStructure = async ({ item_id, frame_type, material, dimensions }) => {
  const result = await pool.query(
    `INSERT INTO frame_structures (item_id, frame_type, material, dimensions) 
     VALUES ($1, $2, $3, $4) RETURNING *`,
    [item_id, frame_type, material, dimensions]
  );
  return result.rows[0];
};

export const getFrameStructureByItemId = async (item_id) => {
  const result = await pool.query(
    `SELECT fs.*, ii.name, ii.category_id, c.name as category_name
     FROM frame_structures fs
     JOIN inventory_items ii ON fs.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     WHERE fs.item_id = $1`,
    [item_id]
  );
  return result.rows[0];
};

export const updateFrameStructure = async (item_id, { frame_type, material, dimensions }) => {
  const result = await pool.query(
    `UPDATE frame_structures SET frame_type = $1, material = $2, dimensions = $3 
     WHERE item_id = $4 RETURNING *`,
    [frame_type, material, dimensions, item_id]
  );
  return result.rows[0];
};

export const deleteFrameStructure = async (item_id) => {
  await pool.query('DELETE FROM frame_structures WHERE item_id = $1', [item_id]);
};

// ======================================
// Carpets Management
// ======================================
export const createCarpet = async ({ item_id, carpet_type, material, size }) => {
  const result = await pool.query(
    `INSERT INTO carpets (item_id, carpet_type, material, size) VALUES ($1, $2, $3, $4) RETURNING *`,
    [item_id, carpet_type, material, size]
  );
  return result.rows[0];
};

export const getCarpetByItemId = async (item_id) => {
  const result = await pool.query(
    `SELECT c.*, ii.name, ii.category_id, cat.name as category_name
     FROM carpets c
     JOIN inventory_items ii ON c.item_id = ii.id
     LEFT JOIN categories cat ON ii.category_id = cat.id
     WHERE c.item_id = $1`,
    [item_id]
  );
  return result.rows[0];
};

export const updateCarpet = async (item_id, { carpet_type, material, size }) => {
  const result = await pool.query(
    `UPDATE carpets SET carpet_type = $1, material = $2, size = $3 WHERE item_id = $4 RETURNING *`,
    [carpet_type, material, size, item_id]
  );
  return result.rows[0];
};

export const deleteCarpet = async (item_id) => {
  await pool.query('DELETE FROM carpets WHERE item_id = $1', [item_id]);
};

// ======================================
// Thermocol Materials Management
// ======================================
export const createThermocolMaterial = async ({ item_id, thermocol_type, dimensions, density }) => {
  const result = await pool.query(
    `INSERT INTO thermocol_materials (item_id, thermocol_type, dimensions, density) 
     VALUES ($1, $2, $3, $4) RETURNING *`,
    [item_id, thermocol_type, dimensions, density]
  );
  return result.rows[0];
};

export const getThermocolMaterialByItemId = async (item_id) => {
  const result = await pool.query(
    `SELECT tm.*, ii.name, ii.category_id, c.name as category_name
     FROM thermocol_materials tm
     JOIN inventory_items ii ON tm.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     WHERE tm.item_id = $1`,
    [item_id]
  );
  return result.rows[0];
};

export const updateThermocolMaterial = async (item_id, { thermocol_type, dimensions, density }) => {
  const result = await pool.query(
    `UPDATE thermocol_materials SET thermocol_type = $1, dimensions = $2, density = $3 
     WHERE item_id = $4 RETURNING *`,
    [thermocol_type, dimensions, density, item_id]
  );
  return result.rows[0];
};

export const deleteThermocolMaterial = async (item_id) => {
  await pool.query('DELETE FROM thermocol_materials WHERE item_id = $1', [item_id]);
};

// ======================================
// Stationery Management
// ======================================
export const createStationery = async ({ item_id, specifications }) => {
  const result = await pool.query(
    `INSERT INTO stationery (item_id, specifications) VALUES ($1, $2) RETURNING *`,
    [item_id, specifications]
  );
  return result.rows[0];
};

export const getStationeryByItemId = async (item_id) => {
  const result = await pool.query(
    `SELECT s.*, ii.name, ii.category_id, c.name as category_name
     FROM stationery s
     JOIN inventory_items ii ON s.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     WHERE s.item_id = $1`,
    [item_id]
  );
  return result.rows[0];
};

export const updateStationery = async (item_id, { specifications }) => {
  const result = await pool.query(
    `UPDATE stationery SET specifications = $1 WHERE item_id = $2 RETURNING *`,
    [specifications, item_id]
  );
  return result.rows[0];
};

export const deleteStationery = async (item_id) => {
  await pool.query('DELETE FROM stationery WHERE item_id = $1', [item_id]);
};

// ======================================
// Murti Sets Management
// ======================================
export const createMurtiSet = async ({ item_id, set_number, material, dimensions }) => {
  const result = await pool.query(
    `INSERT INTO murti_sets (item_id, set_number, material, dimensions) 
     VALUES ($1, $2, $3, $4) RETURNING *`,
    [item_id, set_number, material, dimensions]
  );
  return result.rows[0];
};

export const getMurtiSetByItemId = async (item_id) => {
  const result = await pool.query(
    `SELECT ms.*, ii.name, ii.category_id, c.name as category_name
     FROM murti_sets ms
     JOIN inventory_items ii ON ms.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     WHERE ms.item_id = $1`,
    [item_id]
  );
  return result.rows[0];
};

export const updateMurtiSet = async (item_id, { set_number, material, dimensions }) => {
  const result = await pool.query(
    `UPDATE murti_sets SET set_number = $1, material = $2, dimensions = $3 
     WHERE item_id = $4 RETURNING *`,
    [set_number, material, dimensions, item_id]
  );
  return result.rows[0];
};

export const deleteMurtiSet = async (item_id) => {
  await pool.query('DELETE FROM murti_sets WHERE item_id = $1', [item_id]);
};

// ======================================
// Generic Specialized Inventory Functions
// ======================================
export const getSpecializedInventoryByCategory = async (category_id) => {
  const result = await pool.query(`
    SELECT ii.*, c.name as category_name, ist.quantity_available,
           f.material as furniture_material, f.dimensions as furniture_dimensions,
           fb.fabric_type, fb.pattern, fb.width, fb.length, fb.color,
           fs.frame_type, fs.material as frame_material, fs.dimensions as frame_dimensions,
           cp.carpet_type, cp.material as carpet_material, cp.size as carpet_size,
           tm.thermocol_type, tm.dimensions as thermocol_dimensions, tm.density,
           s.specifications,
           ms.set_number, ms.material as murti_material, ms.dimensions as murti_dimensions
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    LEFT JOIN furniture f ON ii.id = f.item_id
    LEFT JOIN fabric fb ON ii.id = fb.item_id
    LEFT JOIN frame_structures fs ON ii.id = fs.item_id
    LEFT JOIN carpets cp ON ii.id = cp.item_id
    LEFT JOIN thermocol_materials tm ON ii.id = tm.item_id
    LEFT JOIN stationery s ON ii.id = s.item_id
    LEFT JOIN murti_sets ms ON ii.id = ms.item_id
    WHERE ii.category_id = $1
    ORDER BY ii.name
  `, [category_id]);
  return result.rows;
};

export const getInventoryWithSpecializedDetails = async (item_id) => {
  const result = await pool.query(`
    SELECT ii.*, c.name as category_name, ist.quantity_available,
           f.material as furniture_material, f.dimensions as furniture_dimensions,
           fb.fabric_type, fb.pattern, fb.width, fb.length, fb.color,
           fs.frame_type, fs.material as frame_material, fs.dimensions as frame_dimensions,
           cp.carpet_type, cp.material as carpet_material, cp.size as carpet_size,
           tm.thermocol_type, tm.dimensions as thermocol_dimensions, tm.density,
           s.specifications,
           ms.set_number, ms.material as murti_material, ms.dimensions as murti_dimensions
    FROM inventory_items ii
    LEFT JOIN categories c ON ii.category_id = c.id
    LEFT JOIN inventory_stock ist ON ii.id = ist.item_id
    LEFT JOIN furniture f ON ii.id = f.item_id
    LEFT JOIN fabric fb ON ii.id = fb.item_id
    LEFT JOIN frame_structures fs ON ii.id = fs.item_id
    LEFT JOIN carpets cp ON ii.id = cp.item_id
    LEFT JOIN thermocol_materials tm ON ii.id = tm.item_id
    LEFT JOIN stationery s ON ii.id = s.item_id
    LEFT JOIN murti_sets ms ON ii.id = ms.item_id
    WHERE ii.id = $1
  `, [item_id]);
  return result.rows[0];
};
