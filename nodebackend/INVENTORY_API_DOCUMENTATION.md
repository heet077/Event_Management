# Inventory Management API Documentation

## Overview

The Inventory Management API provides comprehensive CRUD operations for managing inventory items, categories, stock levels, and material issuances. All endpoints use POST method as per the application's architecture.

**Base URL:** `http://localhost:5000/api/inventory`

## Table of Contents

1. [Categories](#categories)
2. [Inventory Items](#inventory-items)
3. [Stock Management](#stock-management)
4. [Material Issuances](#material-issuances)
5. [Transactions](#transactions)
6. [Database Schema](#database-schema)
7. [Examples](#examples)

---

## Categories

### Create Category
**Endpoint:** `POST /api/inventory/categories/create`

**Request Body:**
```json
{
  "name": "Furniture"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Category created successfully",
  "data": {
    "id": 1,
    "name": "Furniture",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Get All Categories
**Endpoint:** `POST /api/inventory/categories/getAll`

**Request Body:** `{}`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Furniture",
      "created_at": "2024-01-15T10:30:00Z"
    },
    {
      "id": 2,
      "name": "Fabric",
      "created_at": "2024-01-15T10:31:00Z"
    }
  ]
}
```

### Get Category by ID
**Endpoint:** `POST /api/inventory/categories/getById`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Furniture",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Update Category
**Endpoint:** `POST /api/inventory/categories/update`

**Request Body:**
```json
{
  "id": 1,
  "name": "Office Furniture"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Category updated successfully",
  "data": {
    "id": 1,
    "name": "Office Furniture",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Delete Category
**Endpoint:** `POST /api/inventory/categories/delete`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Category deleted successfully",
  "data": {
    "id": 1,
    "name": "Office Furniture",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

## Inventory Items

### Create Inventory Item
**Endpoint:** `POST /api/inventory/items/create`

**Content-Type:** `multipart/form-data`

**Form Data:**
- `name` (string, required): Item name
- `category_id` (integer, required): Category ID
- `unit` (string): Unit of measurement
- `storage_location` (string): Storage location
- `notes` (string): Additional notes
- `quantity_available` (number, optional): Initial stock quantity (defaults to 0 if not provided)
- `item_image` (file, optional): Item image file
- `category_details` (string, JSON): Category-specific details as JSON string (must be valid JSON)

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
    "item_image": "/uploads/inventory/chair.jpg",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Get All Inventory Items
**Endpoint:** `POST /api/inventory/items/getAll`

**Request Body:** `{}`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Office Chair",
      "category_id": 1,
      "category_name": "Furniture",
      "unit": "pieces",
      "storage_location": "Warehouse A",
      "notes": "Ergonomic office chair",
      "item_image": "/uploads/inventory/chair.jpg",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### Get Inventory Item by ID
**Endpoint:** `POST /api/inventory/items/getById`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Office Chair",
    "category_id": 1,
    "category_name": "Furniture",
    "unit": "pieces",
    "storage_location": "Warehouse A",
    "notes": "Ergonomic office chair",
    "item_image": "/uploads/inventory/chair.jpg",
    "created_at": "2024-01-15T10:30:00Z",
    "category_details": {
      "id": 1,
      "item_id": 1,
      "material": "Leather",
      "dimensions": "60x60x120cm",
      "created_at": "2024-01-15T10:30:00Z"
    }
  }
}
```

### Update Inventory Item
**Endpoint:** `POST /api/inventory/items/update`

**Content-Type:** `multipart/form-data`

**Form Data:**
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
  -F "name=Ergonomic Office Chair" \
  -F "category_id=1" \
  -F "unit=pieces" \
  -F "storage_location=Warehouse B" \
  -F "notes=Updated ergonomic office chair" \
  -F "item_image=@/path/to/updated_chair.jpg"
```

**Response:**
```json
{
  "success": true,
  "message": "Inventory item updated successfully",
  "data": {
    "id": 1,
    "name": "Ergonomic Office Chair",
    "category_id": 1,
    "unit": "pieces",
    "storage_location": "Warehouse B",
    "notes": "Updated ergonomic office chair",
    "item_image": "/uploads/inventory/chair_updated.jpg",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Delete Inventory Item
**Endpoint:** `POST /api/inventory/items/delete`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Inventory item deleted successfully",
  "data": {
    "id": 1,
    "name": "Ergonomic Office Chair",
    "category_id": 1,
    "unit": "pieces",
    "storage_location": "Warehouse B",
    "notes": "Updated ergonomic office chair",
    "item_image": "/uploads/inventory/chair_updated.jpg",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

## Stock Management

### Create Stock
**Endpoint:** `POST /api/inventory/stock/create`

**Request Body:**
```json
{
  "item_id": 1,
  "quantity_available": 50
}
```

**Response:**
```json
{
  "success": true,
  "message": "Stock created successfully",
  "data": {
    "id": 1,
    "item_id": 1,
    "quantity_available": 50,
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

### Get Stock by Item ID
**Endpoint:** `POST /api/inventory/stock/getByItemId`

**Request Body:**
```json
{
  "item_id": 1
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "item_id": 1,
    "quantity_available": 50,
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

### Update Stock
**Endpoint:** `POST /api/inventory/stock/update`

**Request Body:**
```json
{
  "item_id": 1,
  "quantity_available": 45
}
```

**Response:**
```json
{
  "success": true,
  "message": "Stock updated successfully",
  "data": {
    "id": 1,
    "item_id": 1,
    "quantity_available": 45,
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:35:00Z"
  }
}
```

### Get All Stock
**Endpoint:** `POST /api/inventory/stock/getAll`

**Request Body:** `{}`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "item_id": 1,
      "quantity_available": 45,
      "item_name": "Office Chair",
      "category_name": "Furniture",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:35:00Z"
    }
  ]
}
```

---

## Material Issuances

### Create Material Issuance
**Endpoint:** `POST /api/inventory/issuances/create`

**Request Body:**
```json
{
  "item_id": 1,
  "transaction_type": "OUT",
  "quantity": 5,
  "event_id": 123,
  "notes": "Issued for office setup"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Material issuance created successfully",
  "data": {
    "id": 1,
    "item_id": 1,
    "transaction_type": "OUT",
    "quantity": 5,
    "event_id": 123,
    "notes": "Issued for office setup",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Get All Material Issuances
**Endpoint:** `POST /api/inventory/issuances/getAll`

**Request Body:** `{}`

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "item_id": 1,
      "transaction_type": "OUT",
      "quantity": 5,
      "event_id": 123,
      "notes": "Issued for office setup",
      "item_name": "Office Chair",
      "category_name": "Furniture",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ]
}
```

### Get Material Issuance by ID
**Endpoint:** `POST /api/inventory/issuances/getById`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "item_id": 1,
    "transaction_type": "OUT",
    "quantity": 5,
    "event_id": 123,
    "notes": "Issued for office setup",
    "item_name": "Office Chair",
    "category_name": "Furniture",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Update Material Issuance
**Endpoint:** `POST /api/inventory/issuances/update`

**Request Body:**
```json
{
  "id": 1,
  "item_id": 1,
  "transaction_type": "OUT",
  "quantity": 3,
  "event_id": 123,
  "notes": "Updated: Issued for office setup"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Material issuance updated successfully",
  "data": {
    "id": 1,
    "item_id": 1,
    "transaction_type": "OUT",
    "quantity": 3,
    "event_id": 123,
    "notes": "Updated: Issued for office setup",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### Delete Material Issuance
**Endpoint:** `POST /api/inventory/issuances/delete`

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "success": true,
  "message": "Material issuance deleted successfully",
  "data": {
    "id": 1,
    "item_id": 1,
    "transaction_type": "OUT",
    "quantity": 3,
    "event_id": 123,
    "notes": "Updated: Issued for office setup",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

---

## Transactions

### Record Transaction (Stock Movement)
**Endpoint:** `POST /api/inventory/transactions`

**Request Body:**
```json
{
  "item_id": 1,
  "transaction_type": "OUT",
  "quantity": 5,
  "event_id": 123,
  "notes": "Issued for office setup"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Transaction recorded successfully",
  "data": {
    "transaction": {
      "id": 1,
      "item_id": 1,
      "transaction_type": "OUT",
      "quantity": 5,
      "event_id": 123,
      "notes": "Issued for office setup",
      "created_at": "2024-01-15T10:30:00Z"
    },
    "updated_stock": {
      "id": 1,
      "item_id": 1,
      "quantity_available": 40,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    }
  }
}
```

### Get Stock Balance
**Endpoint:** `POST /api/inventory/stock/balance`

**Request Body:**
```json
{
  "item_id": 1
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "item_id": 1,
    "quantity_available": 40
  }
}
```

---

## Database Schema

### Tables Structure

#### Categories
- `id` (SERIAL PRIMARY KEY)
- `name` (VARCHAR(100) NOT NULL UNIQUE)
- `created_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

#### Inventory Items
- `id` (SERIAL PRIMARY KEY)
- `name` (VARCHAR(255) NOT NULL)
- `category_id` (INTEGER REFERENCES categories(id))
- `unit` (VARCHAR(50))
- `storage_location` (VARCHAR(255))
- `notes` (TEXT)
- `item_image` (TEXT)
- `created_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

#### Inventory Stock
- `id` (SERIAL PRIMARY KEY)
- `item_id` (INTEGER REFERENCES inventory_items(id))
- `quantity_available` (DECIMAL(10,2) DEFAULT 0)
- `created_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

#### Material Issuances
- `id` (SERIAL PRIMARY KEY)
- `item_id` (INTEGER REFERENCES inventory_items(id))
- `transaction_type` (VARCHAR(10) CHECK (IN ('IN', 'OUT')))
- `quantity` (DECIMAL(10,2) NOT NULL)
- `event_id` (INTEGER)
- `notes` (TEXT)
- `created_at` (TIMESTAMP DEFAULT CURRENT_TIMESTAMP)

#### Category-specific Tables
- `furniture` (material, dimensions)
- `fabric` (fabric_type, pattern, width, length, color)
- `frame_structures` (frame_type, material, dimensions)
- `carpets` (carpet_type, material, size)
- `thermocol_materials` (thermocol_type, dimensions, density)
- `stationery` (specifications)
- `murti_sets` (set_number, material, dimensions)

---

## Examples

### Complete Workflow Example

1. **Create a Category:**
```bash
curl -X POST http://localhost:5000/api/inventory/categories/create \
  -H "Content-Type: application/json" \
  -d '{"name": "Furniture"}'
```

2. **Create an Inventory Item with Category Details, Image, and Initial Stock:**
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

3. **Add Stock:**
```bash
curl -X POST http://localhost:5000/api/inventory/stock/create \
  -H "Content-Type: application/json" \
  -d '{"item_id": 1, "quantity_available": 50}'
```

4. **Record a Stock Movement:**
```bash
curl -X POST http://localhost:5000/api/inventory/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "transaction_type": "OUT",
    "quantity": 5,
    "event_id": 123,
    "notes": "Issued for office setup"
  }'
```

5. **Check Stock Balance:**
```bash
curl -X POST http://localhost:5000/api/inventory/stock/balance \
  -H "Content-Type: application/json" \
  -d '{"item_id": 1}'
```

### Error Responses

**Validation Error:**
```json
{
  "error": "Item name and category ID are required"
}
```

**Not Found Error:**
```json
{
  "error": "Inventory item not found"
}
```

**Insufficient Stock Error:**
```json
{
  "error": "Insufficient stock",
  "current_stock": 40,
  "requested_quantity": 50
}
```

---

## Notes

1. **Transaction Types:** Only 'IN' and 'OUT' are allowed for transaction_type
2. **Stock Validation:** OUT transactions will fail if insufficient stock is available
3. **Category Details:** When creating inventory items, category-specific details are automatically saved to the appropriate detail table. The `category_details` field must be sent as a valid JSON string in form data.
4. **Stock Initialization:** New inventory items automatically get a stock record with 0 quantity
5. **Cascading Deletes:** Deleting a category or inventory item will cascade to related records
6. **Timestamps:** All tables include created_at timestamps, and inventory_stock includes updated_at
7. **Indexes:** Database includes indexes for better query performance

---

## Setup Instructions

1. **Run the Database Schema:**
```bash
psql -d your_database_name -f inventory_schema.sql
```

2. **Start the Server:**
```bash
npm start
```

3. **Test the API:**
Use the examples provided above to test the endpoints.

---

## Support

For any issues or questions regarding the Inventory Management API, please refer to the main API documentation or contact the development team.
