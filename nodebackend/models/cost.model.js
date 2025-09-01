import pool from '../config/db.js';

export const getEventCostItems = async (event_id) => {
  const result = await pool.query(
    `SELECT * FROM event_cost_items WHERE event_id = $1 ORDER BY uploaded_at DESC`,
    [event_id]
  );
  return result.rows;
};

export const getEventCostTotal = async (event_id) => {
  const result = await pool.query(
    `SELECT SUM(amount) as total_cost FROM event_cost_items WHERE event_id = $1`,
    [event_id]
  );
  return result.rows[0]?.total_cost || 0;
};

export const createCostItem = async ({ event_id, description, amount, document_url, document_type }) => {
  const result = await pool.query(
    `INSERT INTO event_cost_items (event_id, description, amount, document_url, document_type)
     VALUES ($1, $2, $3, $4, $5) RETURNING *`,
    [event_id, description, amount, document_url, document_type]
  );
  return result.rows[0];
};

export const updateCostItem = async (id, { description, amount, document_url, document_type }) => {
  const result = await pool.query(
    `UPDATE event_cost_items 
     SET description = $1, amount = $2, document_url = $3, document_type = $4
     WHERE id = $5 RETURNING *`,
    [description, amount, document_url, document_type, id]
  );
  return result.rows[0];
};

export const deleteCostItem = async (id) => {
  await pool.query('DELETE FROM event_cost_items WHERE id = $1', [id]);
};

export const getCostItemById = async (id) => {
  const result = await pool.query('SELECT * FROM event_cost_items WHERE id = $1', [id]);
  return result.rows[0];
};

// Legacy functions for backward compatibility
export const getEventCost = async (event_id) => {
  const total = await getEventCostTotal(event_id);
  return {
    event_id,
    total_cost: total,
    material_cost: total, // For backward compatibility
    misc_cost: 0
  };
};

export const createOrUpdateCost = async (event_id, material_cost, misc_cost) => {
  // Create as a single cost item for backward compatibility
  const description = misc_cost > 0 ? `Material Cost: ${material_cost}, Misc Cost: ${misc_cost}` : `Material Cost: ${material_cost}`;
  const total_amount = parseFloat(material_cost) + parseFloat(misc_cost);
  
  return await createCostItem({
    event_id,
    description,
    amount: total_amount,
    document_url: null,
    document_type: null
  });
};
