# Inventory Image Upload Guide

## Overview

The Inventory Management API now supports image uploads for inventory items. Each inventory item can have an associated image that is stored locally on the server in an organized folder structure.

## 🖼️ Image Upload Features

### ✅ Supported Features
- **Image Upload**: Upload images when creating or updating inventory items
- **Organized Storage**: Images are stored in `uploads/inventory/items/{item_id}/` directory
- **Automatic Naming**: Images are automatically named as `inventory_item_{item_id}.{extension}`
- **File Management**: Automatic file movement and cleanup
- **URL Generation**: Automatic generation of image URLs for easy access

### 📁 Storage Structure
```
uploads/
└── inventory/
    └── items/
        ├── 1/
        │   └── inventory_item_1.jpg
        ├── 2/
        │   └── inventory_item_2.png
        └── 3/
            └── inventory_item_3.jpeg
```

## 🔧 API Endpoints with Image Upload

### Create Inventory Item with Image
**Endpoint:** `POST /api/inventory/items/create`

**Content-Type:** `multipart/form-data`

**Form Fields:**
- `name` (string, required): Item name
- `category_id` (integer, required): Category ID
- `unit` (string): Unit of measurement
- `storage_location` (string): Storage location
- `notes` (string): Additional notes
- `quantity_available` (number, optional): Initial stock quantity (defaults to 0 if not provided)
- `item_image` (file, optional): Item image file
- `category_details` (string, JSON): Category-specific details as JSON string

**Example Request:**
```bash
curl -X POST http://localhost:5000/api/inventory/items/create \
  -F "name=Office Chair" \
  -F "category_id=1" \
  -F "unit=pieces" \
  -F "storage_location=Warehouse A" \
  -F "notes=Ergonomic office chair" \
  -F "quantity_available=50" \
  -F "item_image=@/path/to/chair.jpg" \
  -F 'category_details={"material":"Leather","dimensions":"60x60x120cm"}'
```

**Response:**
```json
{
  "success": true,
  "message": "Inventory item created successfully",
  "data": {
    "id": 1,
    "name": "Office Chair",
    "category_id": 1,
    "unit": "pieces",
    "storage_location": "Warehouse A",
    "notes": "Ergonomic office chair",
    "item_image": "/uploads/inventory/items/1/inventory_item_1.jpg",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Update Inventory Item with Image
**Endpoint:** `POST /api/inventory/items/update`

**Content-Type:** `multipart/form-data`

**Form Fields:**
- `id` (integer, required): Item ID
- `name` (string): Item name
- `category_id` (integer): Category ID
- `unit` (string): Unit of measurement
- `storage_location` (string): Storage location
- `notes` (string): Additional notes
- `item_image` (file, optional): New item image file

**Example Request:**
```bash
curl -X POST http://localhost:5000/api/inventory/items/update \
  -F "id=1" \
  -F "name=Updated Office Chair" \
  -F "category_id=1" \
  -F "unit=pieces" \
  -F "storage_location=Warehouse B" \
  -F "notes=Updated ergonomic office chair" \
  -F "item_image=@/path/to/updated_chair.jpg"
```

## 📋 JavaScript/Node.js Examples

### Using Axios
```javascript
import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

// Create inventory item with image
const createItemWithImage = async () => {
  const formData = new FormData();
  formData.append('name', 'Office Chair');
  formData.append('category_id', 1);
  formData.append('unit', 'pieces');
  formData.append('storage_location', 'Warehouse A');
  formData.append('notes', 'Ergonomic office chair');
  formData.append('quantity_available', 50);
  formData.append('item_image', fs.createReadStream('/path/to/chair.jpg'));
  formData.append('category_details', JSON.stringify({
    material: 'Leather',
    dimensions: '60x60x120cm'
  }));

  const response = await axios.post('http://localhost:5000/api/inventory/items/create', formData, {
    headers: {
      ...formData.getHeaders()
    }
  });

  console.log('Item created:', response.data);
};

// Update inventory item with new image
const updateItemWithImage = async (itemId) => {
  const formData = new FormData();
  formData.append('id', itemId);
  formData.append('name', 'Updated Office Chair');
  formData.append('category_id', 1);
  formData.append('unit', 'pieces');
  formData.append('storage_location', 'Warehouse B');
  formData.append('notes', 'Updated ergonomic office chair');
  formData.append('item_image', fs.createReadStream('/path/to/updated_chair.jpg'));

  const response = await axios.post('http://localhost:5000/api/inventory/items/update', formData, {
    headers: {
      ...formData.getHeaders()
    }
  });

  console.log('Item updated:', response.data);
};
```

### Using Fetch (Browser)
```javascript
// Create inventory item with image
const createItemWithImage = async () => {
  const formData = new FormData();
  formData.append('name', 'Office Chair');
  formData.append('category_id', 1);
  formData.append('unit', 'pieces');
  formData.append('storage_location', 'Warehouse A');
  formData.append('notes', 'Ergonomic office chair');
  formData.append('quantity_available', 50);
  
  // Get file from file input
  const fileInput = document.getElementById('itemImage');
  formData.append('item_image', fileInput.files[0]);
  
  formData.append('category_details', JSON.stringify({
    material: 'Leather',
    dimensions: '60x60x120cm'
  }));

  const response = await fetch('http://localhost:5000/api/inventory/items/create', {
    method: 'POST',
    body: formData
  });

  const result = await response.json();
  console.log('Item created:', result);
};
```

## 🖼️ Image Access

### Serving Images
Images are served statically through Express. You can access them directly via URL:

```
http://localhost:5000/uploads/inventory/items/1/inventory_item_1.jpg
```

### Image URL in API Responses
When you retrieve an inventory item, the `item_image` field contains the full URL path:

```json
{
  "id": 1,
  "name": "Office Chair",
  "item_image": "/uploads/inventory/items/1/inventory_item_1.jpg",
  "category_id": 1,
  "unit": "pieces",
  "storage_location": "Warehouse A",
  "notes": "Ergonomic office chair",
  "created_at": "2024-01-15T10:30:00Z"
}
```

## 🔒 File Validation

### Supported File Types
The system accepts common image formats:
- JPEG (.jpg, .jpeg)
- PNG (.png)
- GIF (.gif)
- WebP (.webp)

### File Size Limits
- Maximum file size: 10MB (configurable in multer settings)

### File Naming
- Files are automatically renamed to `inventory_item_{item_id}.{extension}`
- Original file names are not preserved for consistency

## 🧪 Testing

### Run Image Upload Tests
```bash
# Test image upload functionality
node test_inventory_image_upload.js

# Test complete inventory API with image upload
node test_inventory_api.js
```

### Test Image Upload Manually
```bash
# Create item with image and initial stock
curl -X POST http://localhost:5000/api/inventory/items/create \
  -F "name=Test Chair" \
  -F "category_id=1" \
  -F "unit=pieces" \
  -F "quantity_available=25" \
  -F "item_image=@/path/to/test-image.jpg"

# Update item with new image
curl -X POST http://localhost:5000/api/inventory/items/update \
  -F "id=1" \
  -F "name=Updated Test Chair" \
  -F "item_image=@/path/to/new-image.jpg"
```

## 🛠️ Implementation Details

### File Storage Process
1. **Upload**: File is uploaded to temporary location
2. **Validation**: File type and size are validated
3. **Processing**: Item is created/updated in database
4. **Storage**: File is moved to final location in organized folder structure
5. **URL Update**: Database is updated with correct image URL

### Error Handling
- **Invalid File Type**: Returns 400 error for unsupported file types
- **File Too Large**: Returns 400 error for files exceeding size limit
- **Upload Failure**: Returns 500 error for file system issues
- **Database Error**: Returns 500 error for database operation failures

### Cleanup
- Old images are automatically replaced when updating
- No orphaned files are left in the system
- File system operations are atomic where possible

## 📊 Performance Considerations

### File Storage Optimization
- Images are stored in organized folder structure for easy access
- File naming is consistent and predictable
- No duplicate files are created

### Database Optimization
- Image URLs are stored as relative paths
- No BLOB storage in database (only file paths)
- Efficient queries with indexed fields

### Server Configuration
- Static file serving is enabled for `/uploads` directory
- Proper MIME type detection for images
- Caching headers for better performance

## 🔄 Migration from Previous Version

If you're upgrading from a version without image upload:

1. **Database**: No changes required - `item_image` field already exists
2. **API**: Endpoints now accept `multipart/form-data` instead of JSON
3. **Client Code**: Update to use FormData instead of JSON payloads
4. **File Storage**: Create `uploads/inventory/items/` directory structure

### Backward Compatibility
- Existing items without images continue to work
- `item_image` field remains optional
- JSON-only requests still work for non-image operations

## 📞 Support

For issues with image upload functionality:

1. **Check File Permissions**: Ensure server has write access to `uploads/` directory
2. **Verify File Types**: Ensure uploaded files are valid images
3. **Check File Size**: Ensure files are within size limits
4. **Review Logs**: Check server logs for detailed error messages
5. **Test with Sample**: Use the provided test scripts to verify functionality

---

**Status**: ✅ **Image Upload Feature Complete**

The inventory image upload functionality is fully implemented and ready for production use.
