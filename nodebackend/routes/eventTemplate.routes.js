import express from 'express';
import * as Template from '../controllers/eventTemplate.controller.js';

const router = express.Router();

router.post('/getAll', Template.getTemplates);
router.post('/getById', Template.getTemplateById);
router.post('/create', Template.createTemplate);
router.post('/update', Template.updateTemplate);
router.post('/delete', Template.deleteTemplate);

export default router;
