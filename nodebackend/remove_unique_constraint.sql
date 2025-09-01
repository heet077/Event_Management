-- Remove the unique constraint that prevents multiple material issuances
-- for the same item per event

-- Drop the unique constraint
ALTER TABLE material_issuances DROP CONSTRAINT IF EXISTS material_issuances_event_id_item_id_key;

-- Verify the constraint is removed
-- You can check with: \d material_issuances

-- Now you can create multiple material issuances for the same item in the same event
-- This allows for more realistic inventory management scenarios like:
-- - Multiple issues of the same item during an event
-- - Different transaction types (IN/OUT) for the same item in the same event
-- - Better tracking of item movements
