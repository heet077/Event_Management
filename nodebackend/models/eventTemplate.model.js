import pool from '../config/db.js';

export const getAllTemplates = async () => {
  const result = await pool.query('SELECT * FROM event_templates ORDER BY name');
  return result.rows;
};

export const getTemplateById = async (id) => {
  const result = await pool.query('SELECT * FROM event_templates WHERE id = $1', [id]);
  return result.rows[0];
};

export const createTemplate = async (name) => {
  const result = await pool.query(
    'INSERT INTO event_templates (name) VALUES ($1) RETURNING *',
    [name]
  );
  return result.rows[0];
};

export const updateTemplate = async (id, name) => {
  const result = await pool.query(
    'UPDATE event_templates SET name = $1 WHERE id = $2 RETURNING *',
    [name, id]
  );
  return result.rows[0];
};

export const deleteTemplate = async (id) => {
  await pool.query('DELETE FROM event_templates WHERE id = $1', [id]);
};

export const checkDuplicateTemplate = async (name, excludeId = null) => {
  let query = 'SELECT * FROM event_templates WHERE LOWER(name) = LOWER($1)';
  let params = [name];
  
  if (excludeId) {
    query += ' AND id != $2';
    params.push(excludeId);
  }
  
  const result = await pool.query(query, params);
  return result.rows.length > 0;
};        