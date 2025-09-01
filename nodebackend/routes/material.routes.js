import express from 'express';
import * as Material from '../controllers/material.controller.js';
import upload from '../middlewares/upload.js';

const router = express.Router();

// ======================================
// Categories Management
// ======================================
router.post('/categories/getAll', Material.getAllCategories);
router.post('/categories', Material.createCategory);
router.post('/categories/update', Material.updateCategory);
router.post('/categories/delete', Material.deleteCategory);

// ======================================
// Search and Filtering (must come before parameterized routes)
// ======================================
router.post('/search', Material.searchMaterials);
router.post('/category/getByCategory', Material.getMaterialsByCategory);
router.post('/specialized/category/getByCategory', Material.getSpecializedInventoryByCategory);

// ======================================
// Image Management Routes
// ======================================
router.post('/images', Material.addItemImage);
router.post('/images/getByItem', Material.getItemImages);
router.post('/images/update', Material.updateItemImage);
router.post('/images/delete', Material.deleteItemImage);
router.post('/with-images/getAll', Material.getAllMaterialsWithImages);
router.post('/with-images/getByItem', Material.getInventoryWithImages);

// ======================================
// Specialized Materials (must come before /:id route)
// ======================================
router.post('/specialized', Material.createMaterialWithSpecializedDetails);
router.post('/specialized/getByItem', Material.getInventoryWithSpecializedDetails);

// ======================================
// Specialized Inventory Management
// ======================================

// Furniture
router.post('/furniture/getByItem', Material.getFurnitureDetails);
router.post('/furniture', Material.createFurniture);
router.post('/furniture/update', Material.updateFurniture);
router.post('/furniture/delete', Material.deleteFurniture);

// Fabric
router.post('/fabric/getByItem', Material.getFabricDetails);
router.post('/fabric', Material.createFabric);
router.post('/fabric/update', Material.updateFabric);
router.post('/fabric/delete', Material.deleteFabric);

// Frame Structures
router.post('/frame-structures/getByItem', Material.getFrameStructureDetails);
router.post('/frame-structures', Material.createFrameStructure);
router.post('/frame-structures/update', Material.updateFrameStructure);
router.post('/frame-structures/delete', Material.deleteFrameStructure);

// Carpets
router.post('/carpets/getByItem', Material.getCarpetDetails);
router.post('/carpets', Material.createCarpet);
router.post('/carpets/update', Material.updateCarpet);
router.post('/carpets/delete', Material.deleteCarpet);

// Thermocol Materials
router.post('/thermocol/getByItem', Material.getThermocolMaterialDetails);
router.post('/thermocol', Material.createThermocolMaterial);
router.post('/thermocol/update', Material.updateThermocolMaterial);
router.post('/thermocol/delete', Material.deleteThermocolMaterial);

// Stationery
router.post('/stationery/getByItem', Material.getStationeryDetails);
router.post('/stationery', Material.createStationery);
router.post('/stationery/update', Material.updateStationery);
router.post('/stationery/delete', Material.deleteStationery);

// Murti Sets
router.post('/murti-sets/getByItem', Material.getMurtiSetDetails);
router.post('/murti-sets', Material.createMurtiSet);
router.post('/murti-sets/update', Material.updateMurtiSet);
router.post('/murti-sets/delete', Material.deleteMurtiSet);

// ======================================
// Inventory Stock Management
// ======================================
router.post('/inventory/getAll', Material.getAllInventoryStock);
router.post('/inventory/update', Material.updateStockQuantity);
router.post('/inventory/adjust', Material.adjustStockQuantity);
router.post('/inventory/low-stock', Material.getLowStockItems);

// ======================================
// Material Issuances
// ======================================
router.post('/issuances', Material.issueMaterial);
router.post('/issuances/getAll', Material.getAllIssuances);
router.post('/issuances/event/getByEvent', Material.getIssuancesByEvent);

// ======================================
// Inventory Items Management (must come LAST)
// ======================================
router.post('/getAll', Material.getAllMaterials);
router.post('/getById', Material.getMaterialById);
router.post('/create', Material.createMaterial);
router.post('/update', Material.updateMaterial);
router.post('/delete', Material.deleteMaterial);

export default router;
