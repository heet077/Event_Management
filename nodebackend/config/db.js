import pkg from 'pg';
import dotenv from 'dotenv';

dotenv.config();
const { Pool } = pkg;

// Create a pool using DATABASE_URL or separate env vars
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || null,
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'password',
  database: process.env.DB_NAME || 'avddeco',
});

// Function to test connection with retry logic
const connectWithRetry = async (retries = 5, delay = 3000) => {
  while (retries) {
    try {
      const client = await pool.connect();
      console.log('✅ Database connected successfully');
      client.release();
      return;
    } catch (err) {
      console.error(`❌ DB connection error: ${err.message}`);
      retries -= 1;
      if (retries === 0) {
        console.error('❌ Could not connect to the database after multiple attempts.');
        process.exit(1);
      }
      console.log(`🔄 Retrying in ${delay / 1000} seconds... (${retries} attempts left)`);
      await new Promise(res => setTimeout(res, delay));
    }
  }
};

connectWithRetry();

export default pool;
