import * as User from '../models/user.model.js';

export const registerUser = async ({ username, password_hash, email, role }) => {
  return await User.createUser({ username, password_hash, email, role });
};

export const findByUsername = async (username) => {
  return await User.getUserByUsername(username);
};
