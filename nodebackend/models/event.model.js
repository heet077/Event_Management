import pool from '../config/db.js';
import fs from 'fs';
import path from 'path';

export const getAllEvents = async () => {
  const result = await pool.query('SELECT * FROM events ORDER BY date DESC');
  return result.rows;
};

export const getEventById = async (id) => {
  const result = await pool.query('SELECT * FROM events WHERE id=$1', [id]);
  return result.rows[0];
};

export const createEvent = async (data) => {
  const {
    template_id,
    year_id,
    date,
    location,
    description,
    cover_image
  } = data;

  // Create the event with the provided data
  const result = await pool.query(
    `INSERT INTO events (template_id, year_id, date, location, description, cover_image)
     VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
    [template_id, year_id, date, location, description, cover_image]
  );
  
  return result.rows[0];
};

export const updateEvent = async (id, data) => {
  const {
    template_id,
    year_id,
    date,
    location,
    description,
    cover_image
  } = data;

  // Update the event with the provided data
  const result = await pool.query(
    `UPDATE events SET template_id=$1, year_id=$2, date=$3, location=$4, 
     description=$5, cover_image=$6 WHERE id=$7 RETURNING *`,
    [template_id, year_id, date, location, description, cover_image, id]
  );
  return result.rows[0];
};

export const deleteEvent = async (id) => {
  await pool.query('DELETE FROM events WHERE id = $1', [id]);
};
