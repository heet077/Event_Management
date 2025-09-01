import pool from '../config/db.js';

export const uploadDesignImage = async ({ event_id, image_url, notes }) => {
  const result = await pool.query(
    `INSERT INTO design_images (event_id, image_url, notes)
     VALUES ($1, $2, $3) RETURNING *`,
    [event_id, image_url, notes]
  );
  return result.rows[0];
};

export const uploadFinalImage = async ({ event_id, image_url, description }) => {
  const result = await pool.query(
    `INSERT INTO final_decoration_images (event_id, image_url, description)
     VALUES ($1, $2, $3) RETURNING *`,
    [event_id, image_url, description]
  );
  return result.rows[0];
};

export const getImagesByEvent = async (event_id) => {
  const design = await pool.query('SELECT * FROM design_images WHERE event_id=$1', [event_id]);
  const final = await pool.query('SELECT * FROM final_decoration_images WHERE event_id=$1', [event_id]);
  return {
    design: design.rows,
    final: final.rows,
  };
};
