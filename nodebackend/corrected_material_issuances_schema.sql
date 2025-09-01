-- Corrected material_issuances table definition
-- Based on the database schema image analysis

CREATE TABLE material_issuances (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    quantity_issued NUMERIC(10, 2) NOT NULL,
    notes TEXT,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('IN', 'OUT')),
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES inventory_items(id) ON DELETE CASCADE,
    UNIQUE (event_id, item_id)
);

-- Add indexes for better performance
CREATE INDEX idx_material_issuances_item_id ON material_issuances(item_id);
CREATE INDEX idx_material_issuances_event_id ON material_issuances(event_id);
CREATE INDEX idx_material_issuances_transaction_type ON material_issuances(transaction_type);
CREATE INDEX idx_material_issuances_issued_at ON material_issuances(issued_at);
