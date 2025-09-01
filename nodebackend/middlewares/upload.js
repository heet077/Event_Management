import multer from 'multer';
import fs from 'fs';
import path from 'path';

// Define uploads folder for permanent storage
const UPLOADS_DIR = 'uploads';
const EVENTS_DIR = path.join(UPLOADS_DIR, 'events');
const INVENTORY_DIR = path.join(UPLOADS_DIR, 'inventory');

// Ensure folders exist
if (!fs.existsSync(UPLOADS_DIR)) {
  fs.mkdirSync(UPLOADS_DIR, { recursive: true });
}
if (!fs.existsSync(EVENTS_DIR)) {
  fs.mkdirSync(EVENTS_DIR, { recursive: true });
}
if (!fs.existsSync(INVENTORY_DIR)) {
  fs.mkdirSync(INVENTORY_DIR, { recursive: true });
}

// Configure multer to use uploads folder
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    // Check if this is an event cover image upload
    if (req.baseUrl === '/api' && req.path === '/events/create') {
      // For new events, we'll create a temporary folder and move it later
      cb(null, UPLOADS_DIR);
    } else if (req.baseUrl === '/api' && req.path === '/events/update') {
      // For updates, we need the event ID to create the proper folder
      const eventId = req.body.id;
      if (eventId) {
        const eventDir = path.join(EVENTS_DIR, eventId.toString());
        if (!fs.existsSync(eventDir)) {
          fs.mkdirSync(eventDir, { recursive: true });
        }
        cb(null, eventDir);
      } else {
        cb(null, UPLOADS_DIR);
      }
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/furniture')) {
      // Specialized inventory - Furniture
      const itemId = req.body.item_id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'furniture', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/fabric')) {
      // Specialized inventory - Fabric
      const itemId = req.body.item_id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'fabric', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/frame-structures')) {
      // Specialized inventory - Frame Structures
      const itemId = req.body.item_id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'frame-structures', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/carpets')) {
      // Specialized inventory - Carpets
      const itemId = req.body.item_id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'carpets', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/thermocol')) {
      // Specialized inventory - Thermocol Materials
      const itemId = req.body.item_id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'thermocol', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/stationery')) {
      // Specialized inventory - Stationery
      const itemId = req.body.item_id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'stationery', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/murti-sets')) {
      // Specialized inventory - Murti Sets
      const itemId = req.body.item_id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'murti-sets', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/inventory' && req.path.includes('/items/create')) {
      // Inventory items - Create
      const itemId = req.body.id || 'temp';
      const itemDir = path.join(INVENTORY_DIR, 'items', itemId.toString());
      if (!fs.existsSync(itemDir)) {
        fs.mkdirSync(itemDir, { recursive: true });
      }
      cb(null, itemDir);
    } else if (req.baseUrl === '/api/inventory' && req.path.includes('/items/update')) {
      // Inventory items - Update
      const itemId = req.body.id;
      if (itemId) {
        const itemDir = path.join(INVENTORY_DIR, 'items', itemId.toString());
        if (!fs.existsSync(itemDir)) {
          fs.mkdirSync(itemDir, { recursive: true });
        }
        cb(null, itemDir);
      } else {
        cb(null, UPLOADS_DIR);
      }
    } else {
      // For other uploads, use the main uploads directory
      cb(null, UPLOADS_DIR);
    }
  },
  filename: (req, file, cb) => {
    // Check if this is an event cover image
    if (req.baseUrl === '/api' && (req.path === '/events/create' || req.path === '/events/update')) {
      const eventId = req.body.id || 'temp'; // Use 'temp' for new events
      const ext = path.extname(file.originalname);
      cb(null, `cover_image_${eventId}${ext}`);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/furniture')) {
      // Specialized inventory - Furniture
      const itemId = req.body.item_id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `furniture_image_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/fabric')) {
      // Specialized inventory - Fabric
      const itemId = req.body.item_id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `fabric_image_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/frame-structures')) {
      // Specialized inventory - Frame Structures
      const itemId = req.body.item_id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `frame_structure_image_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/carpets')) {
      // Specialized inventory - Carpets
      const itemId = req.body.item_id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `carpet_image_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/thermocol')) {
      // Specialized inventory - Thermocol Materials
      const itemId = req.body.item_id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `thermocol_image_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/stationery')) {
      // Specialized inventory - Stationery
      const itemId = req.body.item_id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `stationery_image_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/materials' && req.path.includes('/murti-sets')) {
      // Specialized inventory - Murti Sets
      const itemId = req.body.item_id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `murti_set_image_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/inventory' && req.path.includes('/items/create')) {
      // Inventory items - Create
      const itemId = req.body.id || 'temp';
      const ext = path.extname(file.originalname);
      cb(null, `inventory_item_${itemId}${ext}`);
    } else if (req.baseUrl === '/api/inventory' && req.path.includes('/items/update')) {
      // Inventory items - Update
      const itemId = req.body.id;
      const ext = path.extname(file.originalname);
      cb(null, `inventory_item_${itemId}${ext}`);
    } else {
      // For other files, use timestamp naming
      const timestamp = Date.now();
      const ext = path.extname(file.originalname);
      const safeName = file.originalname.replace(/\s+/g, '_');
      cb(null, `${timestamp}_${safeName}`);
    }
  }
});

const upload = multer({ storage });

export default upload;
