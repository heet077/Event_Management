-- Revert image_url columns from specialized inventory tables
-- Run these commands in your PostgreSQL database

-- Remove image_url column from specialized inventory tables
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

-- Verify the changes
SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name IN ('furniture', 'fabric', 'frame_structures', 'carpets', 'thermocol_materials', 'stationery', 'murti_sets', 'material_issuances', 'inventory_items')
    AND column_name IN ('image_url', 'transaction_type', 'item_image')
ORDER BY table_name, column_name;
