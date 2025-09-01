import express from 'express';
import cors from 'cors';
// import dotenv from './config/dotenv.js';
import routes from './routes/index.js';
import errorHandler from './middlewares/errorHandler.js';

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// Static file serving
app.use('/uploads', express.static('uploads'));
app.use(express.static('public')); // Serve files from public directory

// API routes
app.use('/api', routes);

// OAuth routes (without /api prefix)
import authRoutes from './routes/auth.routes.js';
app.use('/auth', authRoutes);

// Serve authentication page
app.get('/auth-page', (req, res) => {
  res.sendFile('auth.html', { root: './public' });
});

// Centralized error handler
app.use(errorHandler);

export default app;
