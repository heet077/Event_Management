-- Inventory Management System Database Schema
-- Run these commands in your PostgreSQL database

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory Items table
CREATE TABLE IF NOT EXISTS inventory_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    unit VARCHAR(50),
    storage_location VARCHAR(255),
    notes TEXT,
    item_image TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inventory Stock table
CREATE TABLE IF NOT EXISTS inventory_stock (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    quantity_available DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Material Issuances table
CREATE TABLE IF NOT EXISTS material_issuances (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL REFERENCES inventory_items(id) ON DELETE CASCADE,
    quantity_issued NUMERIC(10, 2) NOT NULL,
    notes TEXT,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('IN', 'OUT'))
);

-- Category-specific detail tables

-- Furniture table
CREATE TABLE IF NOT EXISTS furniture (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    material VARCHAR(100),
    dimensions VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Fabric table
CREATE TABLE IF NOT EXISTS fabric (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    fabric_type VARCHAR(100),
    pattern VARCHAR(100),
    width DECIMAL(10,2),
    length DECIMAL(10,2),
    color VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Frame Structures table
CREATE TABLE IF NOT EXISTS frame_structures (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    frame_type VARCHAR(100),
    material VARCHAR(100),
    dimensions VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Carpets table
CREATE TABLE IF NOT EXISTS carpets (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    carpet_type VARCHAR(100),
    material VARCHAR(100),
    size VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Thermocol Materials table
CREATE TABLE IF NOT EXISTS thermocol_materials (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    thermocol_type VARCHAR(100),
    dimensions VARCHAR(100),
    density VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stationery table
CREATE TABLE IF NOT EXISTS stationery (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    specifications TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Murti Sets table
CREATE TABLE IF NOT EXISTS murti_sets (
    id SERIAL PRIMARY KEY,
    item_id INTEGER REFERENCES inventory_items(id) ON DELETE CASCADE,
    set_number VARCHAR(50),
    material VARCHAR(100),
    dimensions VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_inventory_items_category_id ON inventory_items(category_id);
CREATE INDEX IF NOT EXISTS idx_inventory_stock_item_id ON inventory_stock(item_id);
CREATE INDEX IF NOT EXISTS idx_material_issuances_item_id ON material_issuances(item_id);
CREATE INDEX IF NOT EXISTS idx_material_issuances_transaction_type ON material_issuances(transaction_type);
CREATE INDEX IF NOT EXISTS idx_material_issuances_created_at ON material_issuances(created_at);

-- Insert some sample categories
INSERT INTO categories (name) VALUES 
    ('Furniture'),
    ('Fabric'),
    ('Frame Structures'),
    ('Carpets'),
    ('Thermocol Materials'),
    ('Stationery'),
    ('Murti Sets')
ON CONFLICT (name) DO NOTHING;

-- Create a trigger to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_inventory_stock_updated_at 
    BEFORE UPDATE ON inventory_stock 
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
