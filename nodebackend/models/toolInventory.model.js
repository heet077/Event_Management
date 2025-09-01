import pool from '../config/db.js';

export const getAllToolInventory = async () => {
  const result = await pool.query(`
    SELECT ti.*, t.name AS tool_name, t.image_url, t.notes
    FROM tool_inventory ti
    JOIN tools t ON ti.tool_id = t.id
    ORDER BY t.name
  `);
  return result.rows;
};

export const getToolInventoryByToolId = async (tool_id) => {
  const result = await pool.query(`
    SELECT ti.*, t.name AS tool_name, t.image_url, t.notes
    FROM tool_inventory ti
    JOIN tools t ON ti.tool_id = t.id
    WHERE ti.tool_id = $1
  `, [tool_id]);
  return result.rows[0];
};

export const createToolInventory = async ({ tool_id, quantity_available, condition }) => {
  const result = await pool.query(
    `INSERT INTO tool_inventory (tool_id, quantity_available, condition)
     VALUES ($1, $2, $3) RETURNING *`,
    [tool_id, quantity_available || 0, condition || 'Good']
  );
  return result.rows[0];
};

export const updateToolInventory = async (tool_id, { quantity_available, condition }) => {
  const result = await pool.query(
    `UPDATE tool_inventory SET quantity_available=$1, condition=$2 WHERE tool_id=$3 RETURNING *`,
    [quantity_available, condition, tool_id]
  );
  return result.rows[0];
};

export const adjustToolQuantity = async (tool_id, quantity_change) => {
  const result = await pool.query(
    `UPDATE tool_inventory 
     SET quantity_available = quantity_available + $1 
     WHERE tool_id = $2 
     RETURNING *`,
    [quantity_change, tool_id]
  );
  return result.rows[0];
};
