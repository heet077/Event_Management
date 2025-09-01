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
router.post('/issuances/getById', InventoryController.getMaterialIssuanceById);
router.post('/issuances/update', InventoryController.updateMaterialIssuance);
router.post('/issuances/delete', InventoryController.deleteMaterialIssuance);

// Transactions (Stock Movements)
router.post('/transactions', InventoryController.recordTransaction);
router.post('/stock/balance', InventoryController.getStockBalance);

export default router;
