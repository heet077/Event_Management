import express from 'express';
import * as Year from '../controllers/year.controller.js';

const router = express.Router();

router.post('/getAll', Year.getYears);
router.post('/getById', Year.getYearById);
router.post('/create', Year.createYear);
router.post('/update', Year.updateYear);
router.post('/delete', Year.deleteYear);

export default router;
