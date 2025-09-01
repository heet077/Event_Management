import pool from '../config/db.js';

// Material Issuances
export const issueMaterial = async ({ event_id, item_id, quantity_issued, notes }) => {
  const result = await pool.query(
    `INSERT INTO material_issuances (event_id, item_id, quantity_issued, notes)
     VALUES ($1, $2, $3, $4) RETURNING *`,
    [event_id, item_id, quantity_issued, notes]
  );
  return result.rows[0];
};

export const getIssuancesByEvent = async (event_id) => {
  const result = await pool.query(
    `SELECT mi.*, ii.name as material_name, ii.unit, c.name as category_name
     FROM material_issuances mi
     JOIN inventory_items ii ON mi.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     WHERE mi.event_id = $1`,
    [event_id]
  );
  return result.rows;
};

export const getAllIssuances = async () => {
  const result = await pool.query(
    `SELECT mi.*, ii.name as material_name, ii.unit, c.name as category_name,
            e.description as event_description, e.location as event_location, e.date as event_date
     FROM material_issuances mi
     JOIN inventory_items ii ON mi.item_id = ii.id
     LEFT JOIN categories c ON ii.category_id = c.id
     JOIN events e ON mi.event_id = e.id
     ORDER BY mi.issued_at DESC`
  );
  return result.rows;
};

// Tool Issuances  
export const issueTool = async ({ event_id, tool_id, quantity_issued, condition, notes }) => {
  const result = await pool.query(
    `INSERT INTO tool_issuances (event_id, tool_id, quantity_issued, condition, notes)
     VALUES ($1, $2, $3, $4, $5) RETURNING *`,
    [event_id, tool_id, quantity_issued, condition, notes]
  );
  return result.rows[0];
};

export const getToolIssuancesByEvent = async (event_id) => {
  const result = await pool.query(
    `SELECT ti.*, t.name as tool_name
     FROM tool_issuances ti
     JOIN tools t ON ti.tool_id = t.id
     WHERE ti.event_id = $1`,
    [event_id]
  );
  return result.rows;
};

export const getAllToolIssuances = async () => {
  const result = await pool.query(
    `SELECT ti.*, t.name as tool_name,
            e.description as event_description, e.location as event_location, e.date as event_date
     FROM tool_issuances ti
     JOIN tools t ON ti.tool_id = t.id
     JOIN events e ON ti.event_id = e.id
     ORDER BY ti.issued_at DESC`
  );
  return result.rows;
};
