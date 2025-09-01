import * as User from '../models/user.model.js';
import { hashPassword, comparePassword } from '../utils/hash.js';

export const register = async (req, res, next) => {
  try {
    const { username, password, email, role } = req.body;
    
    // Validate required fields
    if (!username || !password || !email) {
      return res.status(400).json({ 
        message: 'Username, password, and email are required' 
      });
    }

    const existing = await User.getUserByUsername(username);
    if (existing) return res.status(409).json({ message: 'Username already exists' });

    const password_hash = await hashPassword(password);
    const newUser = await User.createUser({ username, password_hash, email, role });
    res.status(201).json({ message: 'User registered successfully', user: newUser });
  } catch (err) {
    next(err);
  }
};

export const login = async (req, res, next) => {
  try {
    const { username, password } = req.body;
    
    // Validate required fields
    if (!username || !password) {
      return res.status(400).json({ 
        message: 'Username and password are required' 
      });
    }
    
    const user = await User.getUserByUsername(username);
    if (!user) return res.status(401).json({ message: 'Invalid username or password' });

    const isMatch = await comparePassword(password, user.password_hash);
    if (!isMatch) return res.status(401).json({ message: 'Invalid username or password' });

    res.json({
      message: 'Login successful',
      user: {
        id: user.id,
        username: user.username,
        role: user.role,
        email: user.email
      }
    });
  } catch (err) {
    next(err);
  }
};
