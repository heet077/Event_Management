import pool from '../config/db.js';

export const getAllYears = async () => {
  const result = await pool.query('SELECT * FROM years ORDER BY id DESC');
  return result.rows;
};

export const getYearById = async (id) => {
  const result = await pool.query('SELECT * FROM years WHERE id = $1', [id]);
  return result.rows[0];
};

export const createYear = async (yearName) => {
  const result = await pool.query(
    'INSERT INTO years (year_name) VALUES ($1) RETURNING *',
    [yearName]
  );
  return result.rows[0];
};

export const updateYear = async (id, yearName) => {
  const result = await pool.query(
    'UPDATE years SET year_name = $1 WHERE id = $2 RETURNING *',
    [yearName, id]
  );
  return result.rows[0];
};

export const deleteYear = async (id) => {
  await pool.query('DELETE FROM years WHERE id = $1', [id]);
};

export const checkDuplicateYear = async (yearName, excludeId = null) => {
  let query = 'SELECT * FROM years WHERE year_name = $1';
  let params = [yearName];
  
  if (excludeId) {
    query += ' AND id != $2';
    params.push(excludeId);
  }
  
  const result = await pool.query(query, params);
  return result.rows.length > 0;
};
