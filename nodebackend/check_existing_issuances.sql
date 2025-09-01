-- Check existing material issuances for event_id = 30 and item_id = 3
SELECT 
    id,
    event_id,
    item_id,
    quantity_issued,
    transaction_type,
    notes,
    issued_at
FROM material_issuances 
WHERE event_id = 30 AND item_id = 3
ORDER BY issued_at DESC;

-- Check all material issuances for event_id = 30
SELECT 
    mi.id,
    mi.event_id,
    mi.item_id,
    ii.name as item_name,
    mi.quantity_issued,
    mi.transaction_type,
    mi.notes,
    mi.issued_at
FROM material_issuances mi
JOIN inventory_items ii ON mi.item_id = ii.id
WHERE mi.event_id = 30
ORDER BY mi.issued_at DESC;
