import express from 'express';
import * as User from '../controllers/user.controller.js';

const router = express.Router();

// Create new user
router.post('/create', User.createUser);

// Get all users
router.post('/getAll', User.getAllUsers);

// User login
router.post('/login', User.loginUser);

// Update user by ID
router.post('/update', User.updateUser);

// Delete user by ID
router.post('/delete', User.deleteUser);

export default router;
