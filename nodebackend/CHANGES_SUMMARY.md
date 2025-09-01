# Changes Summary: Revert Specialized Inventory Image URLs & Add New Columns

## Overview
This document summarizes the changes made to:
1. Remove the `image_url` field from all specialized inventory tables
2. Add `transaction_type` column to `material_issuances` table
3. Add `item_image` column to `inventory_items` table

## Database Changes

### SQL Commands to Execute
Run the following SQL commands in your PostgreSQL database:

```sql
-- Revert image_url columns from specialized inventory tables
ALTER TABLE furniture DROP COLUMN IF EXISTS image_url;
ALTER TABLE fabric DROP COLUMN IF EXISTS image_url;
ALTER TABLE frame_structures DROP COLUMN IF EXISTS image_url;
ALTER TABLE carpets DROP COLUMN IF EXISTS image_url;
ALTER TABLE thermocol_materials DROP COLUMN IF EXISTS image_url;
ALTER TABLE stationery DROP COLUMN IF EXISTS image_url;
ALTER TABLE murti_sets DROP COLUMN IF EXISTS image_url;

-- Add new columns to material_issuances and inventory_items
ALTER TABLE material_issuances 
ADD COLUMN transaction_type VARCHAR(10) 
    CHECK (transaction_type IN ('IN', 'OUT'));

ALTER TABLE inventory_items 
ADD COLUMN item_image TEXT;
```

## Code Changes Made

### 1. Models (`models/specializedInventory.model.js`)
- **Removed** `image_url` parameter from all `create` and `update` functions
- **Updated** SQL queries to exclude `image_url` column
- **Modified** SELECT queries to remove `image_url` aliases
- **Affected functions:**
  - `createFurniture`, `updateFurniture`
  - `createFabric`, `updateFabric`
  - `createFrameStructure`, `updateFrameStructure`
  - `createCarpet`, `updateCarpet`
  - `createThermocolMaterial`, `updateThermocolMaterial`
  - `createStationery`, `updateStationery`
  - `createMurtiSet`, `updateMurtiSet`
  - `getSpecializedInventoryByCategory`
  - `getInventoryWithSpecializedDetails`

### 2. Controllers (`controllers/material.controller.js`)
- **Removed** file upload handling logic from all specialized inventory functions
- **Removed** `image_url` parameter extraction and processing
- **Simplified** function parameters to only include required fields
- **Affected functions:**
  - `createFurniture`, `updateFurniture`
  - `createFabric`, `updateFabric`
  - `createFrameStructure`, `updateFrameStructure`
  - `createCarpet`, `updateCarpet`
  - `createThermocolMaterial`, `updateThermocolMaterial`
  - `createStationery`, `updateStationery`
  - `createMurtiSet`, `updateMurtiSet`

### 3. Routes (`routes/material.routes.js`)
- **Removed** `upload.single('image')` middleware from all specialized inventory routes
- **Changed** from `multipart/form-data` to `application/json` endpoints
- **Affected routes:**
  - `/api/materials/furniture` (create, update)
  - `/api/materials/fabric` (create, update)
  - `/api/materials/frame-structures` (create, update)
  - `/api/materials/carpets` (create, update)
  - `/api/materials/thermocol` (create, update)
  - `/api/materials/stationery` (create, update)
  - `/api/materials/murti-sets` (create, update)

### 4. API Documentation (`API_ENDPOINTS.md`)
- **Updated** Content-Type from `multipart/form-data` to `application/json`
- **Removed** file upload examples and form data specifications
- **Updated** curl commands to use JSON format instead of form data
- **Removed** `image_url` from all response examples
- **Removed** specialized inventory local storage structure section
- **Updated** quick start examples to use JSON format

### 5. Files Removed
- **Deleted** `test_specialized_inventory_upload.js` (no longer needed)
- **Deleted** `add_image_url_columns.sql` (replaced with new SQL file)

## New Files Created

### 1. `revert_image_url_add_new_columns.sql`
Contains the SQL commands to:
- Remove `image_url` columns from specialized inventory tables
- Add `transaction_type` column to `material_issuances`
- Add `item_image` column to `inventory_items`
- Include verification queries

## API Changes Summary

### Before (with image_url)
```bash
# Create furniture with image upload
curl -X POST http://localhost:5000/api/materials/furniture \
  -F "item_id=1" \
  -F "material=Wood" \
  -F "dimensions=120x60x75cm" \
  -F "image=@/path/to/furniture_image.jpg"
```

### After (without image_url)
```bash
# Create furniture with JSON
curl -X POST http://localhost:5000/api/materials/furniture \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "material": "Wood",
    "dimensions": "120x60x75cm"
  }'
```

## Impact on Existing Data
- **Warning**: Running the SQL commands will permanently remove the `image_url` column and all stored image URLs
- **Recommendation**: Backup your database before executing the SQL commands
- **Note**: Any existing image files in the `uploads/inventory/` directory will remain but won't be referenced by the database

## Next Steps
1. **Execute** the SQL commands in `revert_image_url_add_new_columns.sql`
2. **Test** the updated API endpoints to ensure they work correctly
3. **Update** any frontend code that was using the `image_url` field
4. **Consider** implementing the new `item_image` field in `inventory_items` if needed
5. **Implement** the new `transaction_type` field in material issuance workflows

## Verification
After running the SQL commands, you can verify the changes with:
```sql
-- Check that image_url columns are removed
SELECT table_name, column_name 
FROM information_schema.columns 
WHERE table_name IN ('furniture', 'fabric', 'frame_structures', 'carpets', 'thermocol_materials', 'stationery', 'murti_sets')
  AND column_name = 'image_url';

-- Check that new columns are added
SELECT table_name, column_name, data_type 
FROM information_schema.columns 
WHERE table_name IN ('material_issuances', 'inventory_items')
  AND column_name IN ('transaction_type', 'item_image');
```
