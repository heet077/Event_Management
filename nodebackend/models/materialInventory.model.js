import pool from '../config/db.js';

export const getAllMaterialInventory = async () => {
  const result = await pool.query(`
    SELECT ist.*, ii.name AS material_name, ii.unit, c.name AS category_name
    FROM inventory_stock ist
    JOIN inventory_items ii ON ist.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    ORDER BY ii.name
  `);
  return result.rows;
};

export const getInventoryByItemId = async (item_id) => {
  const result = await pool.query(`
    SELECT ist.*, ii.name AS material_name, ii.unit, c.name AS category_name
    FROM inventory_stock ist
    JOIN inventory_items ii ON ist.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    WHERE ist.item_id = $1
  `, [item_id]);
  return result.rows[0];
};

export const updateInventoryQuantity = async (item_id, quantity) => {
  const result = await pool.query(
    `UPDATE inventory_stock SET quantity_available = $1 WHERE item_id = $2 RETURNING *`,
    [quantity, item_id]
  );
  return result.rows[0];
};

export const adjustInventoryQuantity = async (item_id, quantity_change) => {
  const result = await pool.query(
    `UPDATE inventory_stock 
     SET quantity_available = quantity_available + $1 
     WHERE item_id = $2 
     RETURNING *`,
    [quantity_change, item_id]
  );
  return result.rows[0];
};

export const createInventory = async (item_id, quantity = 0) => {
  const result = await pool.query(
    `INSERT INTO inventory_stock (item_id, quantity_available)
     VALUES ($1, $2) RETURNING *`,
    [item_id, quantity]
  );
  return result.rows[0];
};

export const getLowStockItems = async (threshold = 10) => {
  const result = await pool.query(`
    SELECT ist.*, ii.name AS material_name, ii.unit, c.name AS category_name
    FROM inventory_stock ist
    JOIN inventory_items ii ON ist.item_id = ii.id
    LEFT JOIN categories c ON ii.category_id = c.id
    WHERE ist.quantity_available <= $1
    ORDER BY ist.quantity_available ASC
  `, [threshold]);
  return result.rows;
};
