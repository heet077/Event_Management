import express from 'express';
import * as InventoryController from '../controllers/inventory.controller.js';
import upload from '../middlewares/upload.js';

const router = express.Router();

// Categories
router.post('/categories/create', InventoryController.createCategory);
router.post('/categories/getAll', InventoryController.getAllCategories);
router.post('/categories/getById', InventoryController.getCategoryById);
router.post('/categories/update', InventoryController.updateCategory);
router.post('/categories/delete', InventoryController.deleteCategory);

// Inventory Items
router.post('/items/create', upload.single('item_image'), InventoryController.createInventoryItem);
router.post('/items/getAll', InventoryController.getAllInventoryItems);
router.post('/items/getList', InventoryController.getInventoryItemList);
router.post('/items/getById', InventoryController.getInventoryItemById);
router.post('/items/update', upload.single('item_image'), InventoryController.updateInventoryItem);
router.post('/items/delete', InventoryController.deleteInventoryItem);

// Stock
router.post('/stock/create', InventoryController.createStock);
router.post('/stock/getByItemId', InventoryController.getStockByItemId);
router.post('/stock/update', InventoryController.updateStock);
router.post('/stock/getAll', InventoryController.getAllStock);

// Material Issuances
router.post('/issuances/create', InventoryController.createMaterialIssuance);
router.post('/issuances/getAll', InventoryController.getAllMaterialIssuances);
router.post('/issuances/getHistoryByItemId', InventoryController.getMaterialIssuanceHistoryByItemId);
router.post('/issuances/getHistoryByEventId', InventoryController.getMaterialIssuanceHistoryByEventId);
router.post('/issuances/getById', InventoryController.getMaterialIssuanceById);
router.post('/issuances/update', InventoryController.updateMaterialIssuance);
router.post('/issuances/delete', InventoryController.deleteMaterialIssuance);

// Transactions (Stock Movements)
router.post('/transactions', InventoryController.recordTransaction);
router.post('/stock/balance', InventoryController.getStockBalance);

// Category-specific routes
// Furniture
router.get('/furniture', InventoryController.getAllFurnitureItems);
router.get('/furniture/:id', InventoryController.getFurnitureItemById);
router.post('/furniture/create', upload.single('item_image'), InventoryController.createFurnitureItem);

// Fabric
router.get('/fabric', InventoryController.getAllFabricItems);
router.get('/fabric/:id', InventoryController.getFabricItemById);
router.post('/fabric/create', upload.single('item_image'), InventoryController.createFabricItem);

// Frame Structures
router.get('/frame-structures', InventoryController.getAllFrameStructureItems);
router.get('/frame-structures/:id', InventoryController.getFrameStructureItemById);
router.post('/frame-structures/create', upload.single('item_image'), InventoryController.createFrameStructureItem);

// Carpets
router.get('/carpets', InventoryController.getAllCarpetItems);
router.get('/carpets/:id', InventoryController.getCarpetItemById);
router.post('/carpets/create', upload.single('item_image'), InventoryController.createCarpetItem);

// Thermocol Materials
router.get('/thermocol-materials', InventoryController.getAllThermocolMaterialItems);
router.get('/thermocol-materials/:id', InventoryController.getThermocolMaterialItemById);
router.post('/thermocol-materials/create', upload.single('item_image'), InventoryController.createThermocolMaterialItem);

// Stationery
router.get('/stationery', InventoryController.getAllStationeryItems);
router.get('/stationery/:id', InventoryController.getStationeryItemById);
router.post('/stationery/create', upload.single('item_image'), InventoryController.createStationeryItem);

// Murti Sets
router.get('/murti-sets', InventoryController.getAllMurtiSetItems);
router.get('/murti-sets/:id', InventoryController.getMurtiSetItemById);
router.post('/murti-sets/create', upload.single('item_image'), InventoryController.createMurtiSetItem);

// Category-specific update routes
// Furniture
router.post('/furniture/update', upload.single('item_image'), InventoryController.updateFurnitureItem);

// Fabric
router.post('/fabric/update', upload.single('item_image'), InventoryController.updateFabricItem);

// Frame Structures
router.post('/frame-structures/update', upload.single('item_image'), InventoryController.updateFrameStructureItem);

// Carpets
router.post('/carpets/update', upload.single('item_image'), InventoryController.updateCarpetItem);

// Thermocol Materials
router.post('/thermocol-materials/update', upload.single('item_image'), InventoryController.updateThermocolMaterialItem);

// Stationery
router.post('/stationery/update', upload.single('item_image'), InventoryController.updateStationeryItem);

// Murti Sets
router.post('/murti-sets/update', upload.single('item_image'), InventoryController.updateMurtiSetItem);

export default router;
