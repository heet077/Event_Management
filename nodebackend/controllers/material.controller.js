import * as Material from '../models/material.model.js';
import * as SpecializedInventory from '../models/specializedInventory.model.js';
import * as MaterialInventory from '../models/materialInventory.model.js';
import * as Issuance from '../models/issuance.model.js';

// ======================================
// Categories Management
// ======================================

export const getAllCategories = async (req, res, next) => {
  try {
    const categories = await Material.getAllCategories();
    res.json(categories);
  } catch (err) {
    next(err);
  }
};

export const createCategory = async (req, res, next) => {
  try {
    const { name } = req.body;
    
    if (!name || !name.trim()) {
      return res.status(400).json({ 
        message: 'Category name is required' 
      });
    }
    
    const category = await Material.createCategory({ name: name.trim() });
    res.status(201).json(category);
  } catch (err) {
    next(err);
  }
};

export const updateCategory = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name } = req.body;
    
    if (!name || !name.trim()) {
      return res.status(400).json({ 
        message: 'Category name is required' 
      });
    }
    
    const category = await Material.updateCategory(id, { name: name.trim() });
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }
    
    res.json(category);
  } catch (err) {
    next(err);
  }
};

export const deleteCategory = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    if (isNaN(id)) {
      return res.status(400).json({ message: 'Invalid category ID' });
    }
    
    await Material.deleteCategory(id);
    res.json({ message: 'Category deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// ======================================
// Inventory Items Management
// ======================================

export const getAllMaterials = async (req, res, next) => {
  try {
    const materials = await Material.getAllMaterials();
    res.json(materials);
  } catch (err) {
    next(err);
  }
};

export const getMaterialById = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    if (isNaN(id)) {
      return res.status(400).json({ message: 'Invalid material ID' });
    }
    
    const material = await Material.getMaterialById(id);
    if (!material) {
      return res.status(404).json({ message: 'Material not found' });
    }
    
    res.json(material);
  } catch (err) {
    next(err);
  }
};

export const createMaterial = async (req, res, next) => {
  try {
    const { name, category_id, unit, storage_location, notes } = req.body;
    
    if (!name || !category_id || !unit) {
      return res.status(400).json({ 
        message: 'name, category_id, and unit are required' 
      });
    }
    
    const material = await Material.createMaterial({
      name: name.trim(),
      category_id,
      unit,
      storage_location,
      notes
    });
    
    res.status(201).json(material);
  } catch (err) {
    next(err);
  }
};

export const createMaterialWithSpecializedDetails = async (req, res, next) => {
  try {
    const { materialData, specializedData } = req.body;
    
    if (!materialData || !specializedData) {
      return res.status(400).json({ 
        message: 'materialData and specializedData are required' 
      });
    }
    
    const material = await Material.createMaterialWithSpecializedDetails(
      materialData, 
      specializedData
    );
    
    res.status(201).json(material);
  } catch (err) {
    next(err);
  }
};

export const updateMaterial = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { name, category_id, unit, storage_location, notes } = req.body;
    
    if (isNaN(id)) {
      return res.status(400).json({ message: 'Invalid material ID' });
    }
    
    const material = await Material.updateMaterial(id, {
      name: name?.trim(),
      category_id,
      unit,
      storage_location,
      notes
    });
    
    if (!material) {
      return res.status(404).json({ message: 'Material not found' });
    }
    
    res.json(material);
  } catch (err) {
    next(err);
  }
};

export const deleteMaterial = async (req, res, next) => {
  try {
    const { id } = req.params;
    
    if (isNaN(id)) {
      return res.status(400).json({ message: 'Invalid material ID' });
    }
    
    await Material.deleteMaterial(id);
    res.json({ message: 'Material deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// ======================================
// Specialized Inventory Management
// ======================================

// Furniture
export const getFurnitureDetails = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const furniture = await SpecializedInventory.getFurnitureByItemId(item_id);
    if (!furniture) {
      return res.status(404).json({ message: 'Furniture details not found' });
    }
    
    res.json(furniture);
  } catch (err) {
    next(err);
  }
};

export const createFurniture = async (req, res, next) => {
  try {
    const { item_id, material, dimensions } = req.body;
    
    if (!item_id || !material || !dimensions) {
      return res.status(400).json({ 
        message: 'item_id, material, and dimensions are required' 
      });
    }
    
    const furniture = await SpecializedInventory.createFurniture({
      item_id,
      material,
      dimensions
    });
    
    res.status(201).json(furniture);
  } catch (err) {
    next(err);
  }
};

export const updateFurniture = async (req, res, next) => {
  try {
    const { item_id, material, dimensions } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const furniture = await SpecializedInventory.updateFurniture(item_id, {
      material,
      dimensions
    });
    
    if (!furniture) {
      return res.status(404).json({ message: 'Furniture not found' });
    }
    
    res.json(furniture);
  } catch (err) {
    next(err);
  }
};

export const deleteFurniture = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    await SpecializedInventory.deleteFurniture(item_id);
    res.json({ message: 'Furniture deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// Fabric
export const getFabricDetails = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const fabric = await SpecializedInventory.getFabricByItemId(item_id);
    if (!fabric) {
      return res.status(404).json({ message: 'Fabric details not found' });
    }
    res.json(fabric);
  } catch (err) {
    next(err);
  }
};

export const createFabric = async (req, res, next) => {
  try {
    const { item_id, fabric_type, pattern, width, length, color } = req.body;
    
    const fabric = await SpecializedInventory.createFabric({
      item_id, fabric_type, pattern, width, length, color
    });
    res.status(201).json(fabric);
  } catch (err) {
    next(err);
  }
};

export const updateFabric = async (req, res, next) => {
  try {
    const { item_id, fabric_type, pattern, width, length, color } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const fabric = await SpecializedInventory.updateFabric(item_id, {
      fabric_type, pattern, width, length, color
    });
    if (!fabric) {
      return res.status(404).json({ message: 'Fabric not found' });
    }
    res.json(fabric);
  } catch (err) {
    next(err);
  }
};

export const deleteFabric = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    await SpecializedInventory.deleteFabric(item_id);
    res.json({ message: 'Fabric deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// Frame Structures
export const getFrameStructureDetails = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const frameStructure = await SpecializedInventory.getFrameStructureByItemId(item_id);
    if (!frameStructure) {
      return res.status(404).json({ message: 'Frame structure details not found' });
    }
    res.json(frameStructure);
  } catch (err) {
    next(err);
  }
};

export const createFrameStructure = async (req, res, next) => {
  try {
    const { item_id, frame_type, material, dimensions } = req.body;
    
    const frameStructure = await SpecializedInventory.createFrameStructure({
      item_id, frame_type, material, dimensions
    });
    res.status(201).json(frameStructure);
  } catch (err) {
    next(err);
  }
};

export const updateFrameStructure = async (req, res, next) => {
  try {
    const { item_id, frame_type, material, dimensions } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const frameStructure = await SpecializedInventory.updateFrameStructure(item_id, {
      frame_type, material, dimensions
    });
    if (!frameStructure) {
      return res.status(404).json({ message: 'Frame structure not found' });
    }
    res.json(frameStructure);
  } catch (err) {
    next(err);
  }
};

export const deleteFrameStructure = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    await SpecializedInventory.deleteFrameStructure(item_id);
    res.json({ message: 'Frame structure deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// Carpets
export const getCarpetDetails = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const carpet = await SpecializedInventory.getCarpetByItemId(item_id);
    if (!carpet) {
      return res.status(404).json({ message: 'Carpet details not found' });
    }
    res.json(carpet);
  } catch (err) {
    next(err);
  }
};

export const createCarpet = async (req, res, next) => {
  try {
    const { item_id, carpet_type, material, size } = req.body;
    
    const carpet = await SpecializedInventory.createCarpet({
      item_id, carpet_type, material, size
    });
    res.status(201).json(carpet);
  } catch (err) {
    next(err);
  }
};

export const updateCarpet = async (req, res, next) => {
  try {
    const { item_id, carpet_type, material, size } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const carpet = await SpecializedInventory.updateCarpet(item_id, {
      carpet_type, material, size
    });
    if (!carpet) {
      return res.status(404).json({ message: 'Carpet not found' });
    }
    res.json(carpet);
  } catch (err) {
    next(err);
  }
};

export const deleteCarpet = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    await SpecializedInventory.deleteCarpet(item_id);
    res.json({ message: 'Carpet deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// Thermocol Materials
export const getThermocolMaterialDetails = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const thermocolMaterial = await SpecializedInventory.getThermocolMaterialByItemId(item_id);
    if (!thermocolMaterial) {
      return res.status(404).json({ message: 'Thermocol material details not found' });
    }
    res.json(thermocolMaterial);
  } catch (err) {
    next(err);
  }
};

export const createThermocolMaterial = async (req, res, next) => {
  try {
    const { item_id, thermocol_type, dimensions, density } = req.body;
    
    const thermocolMaterial = await SpecializedInventory.createThermocolMaterial({
      item_id, thermocol_type, dimensions, density
    });
    res.status(201).json(thermocolMaterial);
  } catch (err) {
    next(err);
  }
};

export const updateThermocolMaterial = async (req, res, next) => {
  try {
    const { item_id, thermocol_type, dimensions, density } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const thermocolMaterial = await SpecializedInventory.updateThermocolMaterial(item_id, {
      thermocol_type, dimensions, density
    });
    if (!thermocolMaterial) {
      return res.status(404).json({ message: 'Thermocol material not found' });
    }
    res.json(thermocolMaterial);
  } catch (err) {
    next(err);
  }
};

export const deleteThermocolMaterial = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    await SpecializedInventory.deleteThermocolMaterial(item_id);
    res.json({ message: 'Thermocol material deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// Stationery
export const getStationeryDetails = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const stationery = await SpecializedInventory.getStationeryByItemId(item_id);
    if (!stationery) {
      return res.status(404).json({ message: 'Stationery details not found' });
    }
    res.json(stationery);
  } catch (err) {
    next(err);
  }
};

export const createStationery = async (req, res, next) => {
  try {
    const { item_id, specifications } = req.body;
    
    const stationery = await SpecializedInventory.createStationery({
      item_id, specifications
    });
    res.status(201).json(stationery);
  } catch (err) {
    next(err);
  }
};

export const updateStationery = async (req, res, next) => {
  try {
    const { item_id, specifications } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const stationery = await SpecializedInventory.updateStationery(item_id, {
      specifications
    });
    if (!stationery) {
      return res.status(404).json({ message: 'Stationery not found' });
    }
    res.json(stationery);
  } catch (err) {
    next(err);
  }
};

export const deleteStationery = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    await SpecializedInventory.deleteStationery(item_id);
    res.json({ message: 'Stationery deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// Murti Sets
export const getMurtiSetDetails = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const murtiSet = await SpecializedInventory.getMurtiSetByItemId(item_id);
    if (!murtiSet) {
      return res.status(404).json({ message: 'Murti set details not found' });
    }
    res.json(murtiSet);
  } catch (err) {
    next(err);
  }
};

export const createMurtiSet = async (req, res, next) => {
  try {
    const { item_id, set_number, material, dimensions } = req.body;
    
    const murtiSet = await SpecializedInventory.createMurtiSet({
      item_id, set_number, material, dimensions
    });
    res.status(201).json(murtiSet);
  } catch (err) {
    next(err);
  }
};

export const updateMurtiSet = async (req, res, next) => {
  try {
    const { item_id, set_number, material, dimensions } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    const murtiSet = await SpecializedInventory.updateMurtiSet(item_id, {
      set_number, material, dimensions
    });
    if (!murtiSet) {
      return res.status(404).json({ message: 'Murti set not found' });
    }
    res.json(murtiSet);
  } catch (err) {
    next(err);
  }
};

export const deleteMurtiSet = async (req, res, next) => {
  try {
    const { item_id } = req.body;
    
    if (!item_id || isNaN(item_id)) {
      return res.status(400).json({ message: 'Valid item_id is required' });
    }
    
    await SpecializedInventory.deleteMurtiSet(item_id);
    res.json({ message: 'Murti set deleted successfully' });
  } catch (err) {
    next(err);
  }
};

// ======================================
// Inventory Stock Management
// ======================================

export const getAllInventoryStock = async (req, res, next) => {
  try {
    const inventory = await MaterialInventory.getAllMaterialInventory();
    res.json(inventory);
  } catch (err) {
    next(err);
  }
};

export const updateStockQuantity = async (req, res, next) => {
  try {
    const { item_id } = req.params;
    const { quantity } = req.body;
    
    if (isNaN(item_id)) {
      return res.status(400).json({ message: 'Invalid item ID' });
    }
    
    if (quantity === undefined || quantity < 0) {
      return res.status(400).json({ message: 'Valid quantity is required' });
    }
    
    const stock = await MaterialInventory.updateInventoryQuantity(item_id, quantity);
    if (!stock) {
      return res.status(404).json({ message: 'Inventory item not found' });
    }
    
    res.json(stock);
  } catch (err) {
    next(err);
  }
};

export const adjustStockQuantity = async (req, res, next) => {
  try {
    const { item_id } = req.params;
    const { quantity_change } = req.body;
    
    if (isNaN(item_id)) {
      return res.status(400).json({ message: 'Invalid item ID' });
    }
    
    if (quantity_change === undefined) {
      return res.status(400).json({ message: 'quantity_change is required' });
    }
    
    const stock = await MaterialInventory.adjustInventoryQuantity(item_id, quantity_change);
    if (!stock) {
      return res.status(404).json({ message: 'Inventory item not found' });
    }
    
    res.json(stock);
  } catch (err) {
    next(err);
  }
};

export const getLowStockItems = async (req, res, next) => {
  try {
    const { threshold = 10 } = req.query;
    const lowStockItems = await MaterialInventory.getLowStockItems(parseInt(threshold));
    res.json(lowStockItems);
  } catch (err) {
    next(err);
  }
};

// ======================================
// Material Issuances
// ======================================

export const issueMaterial = async (req, res, next) => {
  try {
    const { event_id, item_id, quantity_issued, notes } = req.body;
    
    if (!event_id || !item_id || !quantity_issued) {
      return res.status(400).json({ 
        message: 'event_id, item_id, and quantity_issued are required' 
      });
    }
    
    if (quantity_issued <= 0) {
      return res.status(400).json({ 
        message: 'quantity_issued must be greater than 0' 
      });
    }
    
    const issuance = await Issuance.issueMaterial({
      event_id,
      item_id,
      quantity_issued,
      notes
    });
    
    res.status(201).json(issuance);
  } catch (err) {
    next(err);
  }
};

export const getIssuancesByEvent = async (req, res, next) => {
  try {
    const { event_id } = req.params;
    
    if (isNaN(event_id)) {
      return res.status(400).json({ message: 'Invalid event ID' });
    }
    
    const issuances = await Issuance.getIssuancesByEvent(event_id);
    res.json(issuances);
  } catch (err) {
    next(err);
  }
};

export const getAllIssuances = async (req, res, next) => {
  try {
    const issuances = await Issuance.getAllIssuances();
    res.json(issuances);
  } catch (err) {
    next(err);
  }
};

// ======================================
// Search and Filtering
// ======================================

export const searchMaterials = async (req, res, next) => {
  try {
    const { q } = req.query;
    
    if (!q || !q.trim()) {
      return res.status(400).json({ message: 'Search query is required' });
    }
    
    const materials = await Material.searchMaterials(q.trim());
    res.json(materials);
  } catch (err) {
    next(err);
  }
};

export const getMaterialsByCategory = async (req, res, next) => {
  try {
    const { category_id } = req.params;
    
    if (isNaN(category_id)) {
      return res.status(400).json({ message: 'Invalid category ID' });
    }
    
    const materials = await Material.getMaterialsByCategory(category_id);
    res.json(materials);
  } catch (err) {
    next(err);
  }
};

export const getSpecializedInventoryByCategory = async (req, res, next) => {
  try {
    const { category_id } = req.params;
    
    if (isNaN(category_id)) {
      return res.status(400).json({ message: 'Invalid category ID' });
    }
    
    const inventory = await Material.getSpecializedInventoryByCategory(category_id);
    res.json(inventory);
  } catch (err) {
    next(err);
  }
};

export const getInventoryWithSpecializedDetails = async (req, res, next) => {
  try {
    const { item_id } = req.params;
    
    if (isNaN(item_id)) {
      return res.status(400).json({ message: 'Invalid item ID' });
    }
    
    const inventory = await Material.getInventoryWithSpecializedDetails(item_id);
    if (!inventory) {
      return res.status(404).json({ message: 'Inventory item not found' });
    }
    
    res.json(inventory);
  } catch (err) {
    next(err);
  }
};

// ======================================
// Image Management
// ======================================

export const addItemImage = async (req, res, next) => {
  try {
    const { item_id, image_url } = req.body;
    
    if (!item_id || !image_url) {
      return res.status(400).json({ 
        message: 'item_id and image_url are required' 
      });
    }
    
    if (isNaN(item_id)) {
      return res.status(400).json({ message: 'Invalid item ID' });
    }
    
    const image = await Material.addItemImage({ item_id, image_url });
    res.status(201).json(image);
  } catch (err) {
    next(err);
  }
};

export const getItemImages = async (req, res, next) => {
  try {
    const { item_id } = req.params;
    
    if (isNaN(item_id)) {
      return res.status(400).json({ message: 'Invalid item ID' });
    }
    
    const images = await Material.getItemImages(item_id);
    res.json(images);
  } catch (err) {
    next(err);
  }
};

export const updateItemImage = async (req, res, next) => {
  try {
    const { image_id } = req.params;
    const { image_url } = req.body;
    
    if (!image_url) {
      return res.status(400).json({ message: 'image_url is required' });
    }
    
    if (isNaN(image_id)) {
      return res.status(400).json({ message: 'Invalid image ID' });
    }
    
    const image = await Material.updateItemImage(image_id, { image_url });
    if (!image) {
      return res.status(404).json({ message: 'Image not found' });
    }
    
    res.json(image);
  } catch (err) {
    next(err);
  }
};

export const deleteItemImage = async (req, res, next) => {
  try {
    const { image_id } = req.params;
    
    if (isNaN(image_id)) {
      return res.status(400).json({ message: 'Invalid image ID' });
    }
    
    const image = await Material.deleteItemImage(image_id);
    if (!image) {
      return res.status(404).json({ message: 'Image not found' });
    }
    
    res.json({ message: 'Image deleted successfully' });
  } catch (err) {
    next(err);
  }
};

export const getInventoryWithImages = async (req, res, next) => {
  try {
    const { item_id } = req.params;
    
    if (isNaN(item_id)) {
      return res.status(400).json({ message: 'Invalid item ID' });
    }
    
    const inventory = await Material.getInventoryWithImages(item_id);
    if (!inventory) {
      return res.status(404).json({ message: 'Inventory item not found' });
    }
    
    res.json(inventory);
  } catch (err) {
    next(err);
  }
};

export const getAllMaterialsWithImages = async (req, res, next) => {
  try {
    const materials = await Material.getAllMaterialsWithImages();
    res.json(materials);
  } catch (err) {
    next(err);
  }
};
