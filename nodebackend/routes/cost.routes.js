import express from 'express';
import * as Cost from '../controllers/cost.controller.js';
import upload from '../middlewares/upload.js';

const router = express.Router();

// Simple, intuitive API URLs for event cost items
router.post('/eventCostItems/getByEvent', Cost.getEventCostItems);
router.post('/eventCostItems/create', Cost.createCostItem);
router.post('/eventCostItems/createWithFile', upload.single('document'), Cost.createCostItemWithFile);
router.post('/eventCostItems/update', Cost.updateCostItem);
router.post('/eventCostItems/updateWithFile', upload.single('document'), Cost.updateCostItemWithFile);
router.post('/eventCostItems/delete', Cost.deleteCostItem);

// Legacy endpoints for backward compatibility
router.post('/getEventCostSummary', Cost.getEventCostSummary);
router.post('/addEventCostSummary', Cost.addEventCostSummary);
router.post('/updateEventCostSummary', Cost.updateEventCostSummary);
router.post('/deleteEventCostSummary', Cost.deleteEventCostSummary);

export default router;
