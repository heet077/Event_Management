import pool from '../config/db.js';

export const getAllTools = async () => {
  const result = await pool.query('SELECT * FROM tools ORDER BY id');
  return result.rows;
};

export const createTool = async ({ name, image_url, notes }) => {
  const result = await pool.query(
    `INSERT INTO tools (name, image_url, notes) VALUES ($1, $2, $3) RETURNING *`,
    [name, image_url, notes]
  );
  return result.rows[0];
};

export const updateTool = async (id, { name, image_url, notes }) => {
  const result = await pool.query(
    `UPDATE tools SET name=$1, image_url=$2, notes=$3 WHERE id=$4 RETURNING *`,
    [name, image_url, notes, id]
  );
  return result.rows[0];
};

export const deleteTool = async (id) => {
  await pool.query('DELETE FROM tools WHERE id=$1', [id]);
};
