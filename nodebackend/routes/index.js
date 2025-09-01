import { Router } from 'express';

import userRoutes from './user.routes.js';
import eventRoutes from './event.routes.js';
import eventTemplateRoutes from './eventTemplate.routes.js';
import yearRoutes from './year.routes.js';
import materialRoutes from './material.routes.js';
import toolRoutes from './tool.routes.js';
import galleryRoutes from './gallery.routes.js';
import costRoutes from './cost.routes.js';
import issuanceRoutes from './issuance.routes.js';

import inventoryRoutes from './inventory.routes.js';

const router = Router();


router.use('/users', userRoutes);
router.use('/events', eventRoutes);
router.use('/event-templates', eventTemplateRoutes);
router.use('/years', yearRoutes);
router.use('/materials', materialRoutes);
router.use('/tools', toolRoutes);
router.use('/gallery', galleryRoutes);
router.use('/costs', costRoutes);
router.use('/issuance', issuanceRoutes);

router.use('/inventory', inventoryRoutes);

export default router;
