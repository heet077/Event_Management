import * as Year from '../models/year.model.js';

export const getYears = async (req, res, next) => {
  try {
    const years = await Year.getAllYears();
    res.json(years);
  } catch (err) {
    next(err);
  }
};

export const getYearById = async (req, res, next) => {
  try {
    const { id } = req.params;
    const year = await Year.getYearById(id);
    
    if (!year) {
      return res.status(404).json({ 
        message: 'Year not found' 
      });
    }
    
    res.json(year);
  } catch (err) {
    next(err);
  }
};

export const createYear = async (req, res, next) => {
  try {
    const { year_name } = req.body;
    
    // Validate required fields
    if (!year_name) {
      return res.status(400).json({ 
        message: 'year_name is required' 
      });
    }
    
    // Check for duplicates
    const isDuplicate = await Year.checkDuplicateYear(year_name);
    if (isDuplicate) {
      return res.status(400).json({ 
        message: 'Year name already exists' 
      });
    }
    
    const year = await Year.createYear(year_name);
    res.status(201).json(year);
  } catch (err) {
    next(err);
  }
};

export const updateYear = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { year_name } = req.body;
    
    // Validate required fields
    if (!year_name) {
      return res.status(400).json({ 
        message: 'year_name is required' 
      });
    }
    
    // Check if year exists
    const existingYear = await Year.getYearById(id);
    if (!existingYear) {
      return res.status(404).json({ 
        message: 'Year not found' 
      });
    }
    
    // Check for duplicates (excluding current year)
    const isDuplicate = await Year.checkDuplicateYear(year_name, id);
    if (isDuplicate) {
      return res.status(400).json({ 
        message: 'Year name already exists' 
      });
    }
    
    const updated = await Year.updateYear(id, year_name);
    res.json(updated);
  } catch (err) {
    next(err);
  }
};

export const deleteYear = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    // Check if year exists
    const existingYear = await Year.getYearById(id);
    if (!existingYear) {
      return res.status(404).json({ 
        message: 'Year not found' 
      });
    }
    
    await Year.deleteYear(id);
    res.json({ message: 'Year deleted successfully' });
  } catch (err) {
    next(err);
  }
};
