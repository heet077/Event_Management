import * as EventTemplate from '../models/eventTemplate.model.js';

export const getTemplates = async (req, res, next) => {
  try {
    const data = await EventTemplate.getAllTemplates();
    res.json(data);
  } catch (err) {
    next(err);
  }
};

export const getTemplateById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const template = await EventTemplate.getTemplateById(id);
    
    if (!template) {
      return res.status(404).json({ 
        message: 'Event template not found' 
      });
    }
    
    res.json(template);
  } catch (err) {
    next(err);
  }
};

export const createTemplate = async (req, res, next) => {
  try {
    const { name } = req.body;
    
    // Validate required fields
    if (!name || !name.trim()) {
      return res.status(400).json({ 
        message: 'Template name is required' 
      });
    }
    
    // Check for duplicates
    const isDuplicate = await EventTemplate.checkDuplicateTemplate(name.trim());
    if (isDuplicate) {
      return res.status(400).json({ 
        message: 'Template name already exists' 
      });
    }
    
    const template = await EventTemplate.createTemplate(name.trim());
    res.status(201).json(template);
  } catch (err) {
    next(err);
  }
};

export const updateTemplate = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name } = req.body;
    
    // Validate required fields
    if (!name || !name.trim()) {
      return res.status(400).json({ 
        message: 'Template name is required' 
      });
    }
    
    // Check if template exists
    const existingTemplate = await EventTemplate.getTemplateById(id);
    if (!existingTemplate) {
      return res.status(404).json({ 
        message: 'Event template not found' 
      });
    }
    
    // Check for duplicates (excluding current template)
    const isDuplicate = await EventTemplate.checkDuplicateTemplate(name.trim(), id);
    if (isDuplicate) {
      return res.status(400).json({ 
        message: 'Template name already exists' 
      });
    }
    
    const updated = await EventTemplate.updateTemplate(id, name.trim());
    res.json(updated);
  } catch (err) {
    next(err);
  }
};

export const deleteTemplate = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    // Check if template exists
    const existingTemplate = await EventTemplate.getTemplateById(id);
    if (!existingTemplate) {
      return res.status(404).json({ 
        message: 'Event template not found' 
      });
    }
    
    await EventTemplate.deleteTemplate(id);
    res.json({ message: 'Event template deleted successfully' });
  } catch (err) {
    next(err);
  }
};
