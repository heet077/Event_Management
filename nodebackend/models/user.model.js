import pool from '../config/db.js';

export const createUser = async ({ username, password_hash, role }) => {
  const result = await pool.query(
    `INSERT INTO users (username, password_hash, role)
     VALUES ($1, $2, $3) RETURNING *`,
    [username, password_hash, role]
  );
  return result.rows[0];
};

export const getUserByUsername = async (username) => {
  const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);
  return result.rows[0];
};



export const checkDuplicateUser = async (username, excludeId = null) => {
  let query = 'SELECT id, username FROM users WHERE username = $1';
  let params = [username];
  
  if (excludeId) {
    query += ' AND id != $2';
    params.push(excludeId);
  }
  
  const result = await pool.query(query, params);
  return result.rows;
};

export const getAllUsers = async () => {
  const result = await pool.query('SELECT id, username, role, created_at FROM users ORDER BY id');
  return result.rows;
};

export const getUserById = async (id) => {
  const result = await pool.query('SELECT * FROM users WHERE id = $1', [id]);
  return result.rows[0];
};

export const updateUser = async (id, { username, password_hash, role }) => {
  const setParts = [];
  const values = [];
  let paramCount = 1;

  if (username !== undefined) {
    setParts.push(`username = $${paramCount++}`);
    values.push(username);
  }
  if (password_hash !== undefined) {
    setParts.push(`password_hash = $${paramCount++}`);
    values.push(password_hash);
  }
  if (role !== undefined) {
    setParts.push(`role = $${paramCount++}`);
    values.push(role);
  }

  if (setParts.length === 0) {
    throw new Error('No fields to update');
  }

  values.push(id);
  const result = await pool.query(
    `UPDATE users SET ${setParts.join(', ')} WHERE id = $${paramCount} RETURNING *`,
    values
  );
  return result.rows[0];
};

export const deleteUserById = async (id) => {
  await pool.query('DELETE FROM users WHERE id=$1', [id]);
};
