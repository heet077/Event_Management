import express from 'express';
import * as Issuance from '../controllers/issuance.controller.js';

const router = express.Router();

// Material issuances
router.post('/materials', Issuance.createIssuance);
router.post('/materials/getAll', Issuance.getAllIssuances);
router.post('/materials/event/getByEvent', Issuance.getIssuancesByEvent);

// Tool issuances
router.post('/tools', Issuance.createToolIssuance);
router.post('/tools/getAll', Issuance.getAllToolIssuances);
router.post('/tools/event/getByEvent', Issuance.getToolIssuancesByEvent);

// Legacy routes for backward compatibility
router.post('/', Issuance.createIssuance);
router.post('/getAll', Issuance.getAllIssuances);
router.post('/event/getByEvent', Issuance.getIssuancesByEvent);

export default router; 