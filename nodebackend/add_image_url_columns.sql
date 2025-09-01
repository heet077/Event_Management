-- Add image_url column to all specialized inventory tables
-- Run these commands in your PostgreSQL database

ALTER TABLE furniture ADD COLUMN image_url TEXT;
ALTER TABLE fabric ADD COLUMN image_url TEXT;
ALTER TABLE frame_structures ADD COLUMN image_url TEXT;
ALTER TABLE carpets ADD COLUMN image_url TEXT;
ALTER TABLE thermocol_materials ADD COLUMN image_url TEXT;
ALTER TABLE stationery ADD COLUMN image_url TEXT;
ALTER TABLE murti_sets ADD COLUMN image_url TEXT;

-- Verify the columns were added
SELECT 
    table_name, 
    column_name, 
    data_type 
FROM information_schema.columns 
WHERE table_name IN ('furniture', 'fabric', 'frame_structures', 'carpets', 'thermocol_materials', 'stationery', 'murti_sets')
    AND column_name = 'image_url'
ORDER BY table_name;
