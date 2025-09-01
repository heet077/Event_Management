import * as User from '../models/user.model.js';
import { hashPassword, comparePassword } from '../utils/hash.js';

export const createUser = async (req, res, next) => {
  try {
    const { username, password, role = 'viewer' } = req.body;
    
    // Validate required fields
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        details: [
          { field: 'username', message: 'Username is required' },
          { field: 'password', message: 'Password is required' }
        ].filter(item => 
          (item.field === 'username' && !username) ||
          (item.field === 'password' && !password)
        )
      });
    }

    // Validate field formats
    const errors = [];
    
    // Username validation
    if (username.length < 3 || username.length > 30) {
      errors.push({ field: 'username', message: 'Username must be between 3 and 30 characters' });
    }
    if (!/^[a-zA-Z0-9]+$/.test(username)) {
      errors.push({ field: 'username', message: 'Username must contain only alphanumeric characters' });
    }

    // Role validation
    const validRoles = ['admin', 'viewer'];
    if (!validRoles.includes(role)) {
      errors.push({ field: 'role', message: 'Role must be one of: admin, viewer' });
    }

    if (errors.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        details: errors
      });
    }

    // Check for duplicate username
    const duplicates = await User.checkDuplicateUser(username);
    if (duplicates.length > 0) {
      return res.status(409).json({
        success: false,
        message: 'Username already exists',
        details: [{ field: 'username', message: 'Username already exists' }]
      });
    }

    // Hash password and create user
    const password_hash = await hashPassword(password);
    const user = await User.createUser({ username, password_hash, role });
    
    // Don't return the password hash in the response
    const { password_hash: _, ...userResponse } = user;
    
    res.status(201).json({
      success: true,
      message: 'User created successfully',
      data: userResponse
    });
  } catch (err) {
    // Handle database errors
    if (err.code === '23505') { // PostgreSQL unique violation
      return res.status(409).json({
        success: false,
        message: 'Username already exists',
        details: [{ field: 'duplicate', message: 'A user with this username already exists' }]
      });
    }
    
    next(err);
  }
};

export const getAllUsers = async (req, res, next) => {
  try {
    const users = await User.getAllUsers();
    
    res.json({
      success: true,
      message: 'Users retrieved successfully',
      data: users,
      count: users.length
    });
  } catch (err) {
    next(err);
  }
};

export const loginUser = async (req, res, next) => {
  try {
    const { username, password } = req.body;
    
    // Validate required fields
    if (!username || !password) {
      const errors = [];
      if (!username) errors.push({ field: 'username', message: 'Username is required' });
      if (!password) errors.push({ field: 'password', message: 'Password is required' });
      
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        details: errors
      });
    }

    // Validate field formats
    const errors = [];
    
    if (username.length < 3 || username.length > 30) {
      errors.push({ field: 'username', message: 'Username must be between 3 and 30 characters' });
    }
    if (!/^[a-zA-Z0-9]+$/.test(username)) {
      errors.push({ field: 'username', message: 'Username must contain only alphanumeric characters' });
    }

    if (errors.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        details: errors
      });
    }

    // Find user by username
    const user = await User.getUserByUsername(username);
    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
        details: [{ field: 'login', message: 'Invalid username or password' }]
      });
    }

    // Verify password
    const isPasswordValid = await comparePassword(password, user.password_hash);
    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials',
        details: [{ field: 'login', message: 'Invalid username or password' }]
      });
    }

    // Don't return the password hash in the response
    const { password_hash: _, ...userResponse } = user;
    
    res.json({
      success: true,
      message: 'Login successful',
      data: {
        user: userResponse,
        loginTime: new Date().toISOString()
      }
    });
  } catch (err) {
    next(err);
  }
};

export const updateUser = async (req, res, next) => {
  try {
    const { id, username, password, role } = req.body;
    
    // Validate ID parameter
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'User ID is required',
        details: [{ field: 'id', message: 'User ID is required in request body' }]
      });
    }
    
    const userId = parseInt(id);
    if (isNaN(userId) || userId <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Invalid user ID',
        details: [{ field: 'id', message: 'User ID must be a positive integer' }]
      });
    }

    // Check if at least one field is provided
    if (!username && !password && !role) {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        details: [{ field: 'update', message: 'At least one field must be provided for update' }]
      });
    }

    // Validate field formats
    const errors = [];
    
    if (username !== undefined) {
      if (username.length < 3 || username.length > 30) {
        errors.push({ field: 'username', message: 'Username must be between 3 and 30 characters' });
      }
      if (!/^[a-zA-Z0-9]+$/.test(username)) {
        errors.push({ field: 'username', message: 'Username must contain only alphanumeric characters' });
      }
    }

    // Password validation - no additional checks needed for updates

    if (role !== undefined) {
      const validRoles = ['admin', 'viewer'];
      if (!validRoles.includes(role)) {
        errors.push({ field: 'role', message: 'Role must be one of: admin, viewer' });
      }
    }

    if (errors.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        details: errors
      });
    }

    // Check if user exists
    const existingUser = await User.getUserById(userId);
    if (!existingUser) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
        details: [{ field: 'id', message: `User with ID ${userId} does not exist` }]
      });
    }

    // Check for duplicate username (excluding current user)
    if (username) {
      const duplicates = await User.checkDuplicateUser(username, userId);
      
      if (duplicates.length > 0) {
        return res.status(409).json({
          success: false,
          message: 'Username already exists',
          details: [{ field: 'username', message: 'Username already exists' }]
        });
      }
    }

    // Prepare update data
    let updateData = { username, role };
    
    // Hash password if provided
    if (password) {
      updateData.password_hash = await hashPassword(password);
    }

    // Remove undefined values
    updateData = Object.fromEntries(Object.entries(updateData).filter(([_, v]) => v !== undefined));

    const user = await User.updateUser(userId, updateData);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
        details: [{ field: 'id', message: `User with ID ${userId} does not exist` }]
      });
    }
    
    // Don't return the password hash in the response
    const { password_hash: _, ...userResponse } = user;
    
    res.json({
      success: true,
      message: 'User updated successfully',
      data: userResponse
    });
  } catch (err) {
    // Handle database errors
    if (err.code === '23505') { // PostgreSQL unique violation
      return res.status(409).json({
        success: false,
        message: 'Username already exists',
        details: [{ field: 'duplicate', message: 'A user with this username already exists' }]
      });
    }
    
    next(err);
  }
};

export const deleteUser = async (req, res, next) => {
  try {
    const { id } = req.body;
    
    // Validate ID parameter
    if (!id) {
      return res.status(400).json({
        success: false,
        message: 'User ID is required',
        details: [{ field: 'id', message: 'User ID is required in request body' }]
      });
    }
    
    const userId = parseInt(id);
    if (isNaN(userId) || userId <= 0) {
      return res.status(400).json({
        success: false,
        message: 'Invalid user ID',
        details: [{ field: 'id', message: 'User ID must be a positive integer' }]
      });
    }

    // Check if user exists before deletion
    const existingUser = await User.getUserById(userId);
    if (!existingUser) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
        details: [{ field: 'id', message: `User with ID ${userId} does not exist` }]
      });
    }

    await User.deleteUserById(userId);
    
    res.json({
      success: true,
      message: 'User deleted successfully',
      data: {
        deletedUserId: userId,
        deletedUsername: existingUser.username
      }
    });
  } catch (err) {
    next(err);
  }
};