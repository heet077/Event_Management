import express from 'express';
import * as Tool from '../controllers/tool.controller.js';
import * as ToolInventory from '../controllers/toolInventory.controller.js';

const router = express.Router();

// Tool inventory routes (must come before parameterized routes)
router.post('/inventory/getAll', ToolInventory.getAllToolInventory);
router.post('/inventory/getByTool', ToolInventory.getToolInventoryByToolId);
router.post('/inventory', ToolInventory.createToolInventory);
router.post('/inventory/update', ToolInventory.updateToolInventory);
router.post('/inventory/adjust', ToolInventory.adjustToolQuantity);
router.post('/inventory/deduct', ToolInventory.deductToolStock);

// Tool CRUD routes
router.post('/getAll', Tool.getTools);
router.post('/create', Tool.createTool);
router.post('/update', Tool.updateTool);
router.post('/delete', Tool.deleteTool);

export default router;
