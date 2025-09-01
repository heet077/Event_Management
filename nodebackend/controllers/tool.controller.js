import * as Tool from '../models/tool.model.js';

export const getTools = async (req, res, next) => {
  try {
    const tools = await Tool.getAllTools();
    res.json(tools);
  } catch (err) {
    next(err);
  }
};

export const createTool = async (req, res, next) => {
  try {
    const tool = await Tool.createTool(req.body);
    res.status(201).json(tool);
  } catch (err) {
    next(err);
  }
};

export const updateTool = async (req, res, next) => {
  try {
    const updated = await Tool.updateTool(req.params.id, req.body);
    res.json(updated);
  } catch (err) {
    next(err);
  }
};

export const deleteTool = async (req, res, next) => {
  try {
    await Tool.deleteTool(req.params.id);
    res.json({ message: 'Deleted successfully' });
  } catch (err) {
    next(err);
  }
};
