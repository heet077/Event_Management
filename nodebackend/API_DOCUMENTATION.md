# 🎨 DecorationApp API Documentation

## 📋 Table of Contents
- [Overview](#overview)
- [Base URL & Authentication](#base-url--authentication)
- [Response Format](#response-format)
- [👥 Users API](#-users-api)
- [🎉 Events API](#-events-api)
- [📦 Inventory API](#-inventory-api)
- [🔧 Materials API](#-materials-api)
- [🛠 Tools API](#-tools-api)
- [💰 Costs API](#-costs-api)
- [📤 Issuance API](#-issuance-api)
- [📸 Gallery API](#-gallery-api)
- [📅 Event Templates API](#-event-templates-api)
- [📆 Years API](#-years-api)
- [Error Handling](#error-handling)
- [Quick Start Guide](#quick-start-guide)

---

## Overview

The DecorationApp API is a comprehensive REST API for managing decoration events, users, inventory, materials, tools, and costs. This documentation covers all major API categories with accurate endpoint information and data structures.

---

## Base URL & Authentication

*Base URL:* http://localhost:5000

*Authentication:* Currently uses simple username/password authentication. JWT tokens may be implemented in future versions.

---

## Response Format

All API responses follow a consistent format:

### Success Response
json
{
  "success": true,
  "message": "Operation completed successfully",
  "data": {...},
  "count": 10
}


### Error Response
json
{
  "success": false,
  "message": "Error description",
  "details": [
    {
      "field": "field_name",
      "message": "Specific error message"
    }
  ]
}


---

## 👥 Users API

### Create User
*Endpoint:* POST /api/users/create

*Description:* Create a new user (admin function)

*Request Body:*
json
{
  "username": "new_user",
  "password": "password123",
  "role": "viewer"
}


*Response:*
json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "id": 2,
    "username": "new_user",
    "role": "viewer",
    "created_at": "2024-01-15T10:30:00Z"
  }
}


### Get All Users
*Endpoint:* POST /api/users/getAll

*Description:* Retrieve all users in the system

*Request Body:* (Empty)
json
{}


*Response:*
json
{
  "success": true,
  "message": "Users retrieved successfully",
  "data": [
    {
      "id": 1,
      "username": "john_doe",
      "role": "admin",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ],
  "count": 1
}


### Update User
*Endpoint:* POST /api/users/update

*Description:* Update user information

*Request Body:*
json
{
  "id": 2,
  "username": "updated_user",
  "role": "admin"
}


### Delete User
*Endpoint:* POST /api/users/delete

*Description:* Delete a user from the system

*Request Body:*
json
{
  "id": 2
}


---

## 🎉 Events API

### Create Event
*Endpoint:* POST /api/events/create

*Description:* Create a new decoration event with optional cover image

*Content-Type:* multipart/form-data

*Request Body:*
form-data
{
  "template_id": 1,
  "year_id": 1,
  "date": "2024-06-15",
  "location": "Grand Hotel",
  "description": "Beautiful wedding decoration setup",
  "cover_image": [file] // Optional
}


*Response:*
json
{
  "success": true,
  "message": "Event created successfully",
  "data": {
    "id": 1,
    "template_id": 1,
    "year_id": 1,
    "date": "2024-06-15",
    "location": "Grand Hotel",
    "description": "Beautiful wedding decoration setup",
    "cover_image": "/uploads/events/1/cover_image_1.jpg"
  }
}


### Get All Events
*Endpoint:* POST /api/events/getAll

*Description:* Retrieve all events

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Events retrieved successfully",
  "data": [
    {
      "id": 1,
      "template_id": 1,
      "year_id": 1,
      "date": "2024-06-15",
      "location": "Grand Hotel",
      "description": "Beautiful wedding decoration setup",
      "cover_image": "/uploads/events/1/cover_image_1.jpg"
    }
  ],
  "count": 1
}


### Get Event by ID
*Endpoint:* POST /api/events/getById

*Description:* Retrieve a specific event by its ID

*Request Body:*
json
{
  "id": 1
}


### Update Event
*Endpoint:* POST /api/events/update

*Description:* Update an existing event

*Content-Type:* multipart/form-data

*Request Body:*
form-data
{
  "id": 1,
  "template_id": 1,
  "year_id": 1,
  "date": "2024-06-20",
  "location": "Updated Venue",
  "description": "Updated description",
  "cover_image": [file] // Optional
}


### Delete Event
*Endpoint:* POST /api/events/delete

*Description:* Delete an event

*Request Body:*
json
{
  "id": 1
}


### Get Event Details
*Endpoint:* POST /api/events/getDetails

*Description:* Get comprehensive event details including related data

*Request Body:*
json
{
  "id": 1
}


---

## 📦 Inventory API

### Categories Management

#### Create Category
*Endpoint:* POST /api/inventory/categories/create

*Description:* Create a new inventory category

*Request Body:*
json
{
  "name": "Furniture"
}


*Response:*
json
{
  "success": true,
  "message": "Category created successfully",
  "data": {
    "id": 1,
    "name": "Furniture"
  }
}


#### Get All Categories
*Endpoint:* POST /api/inventory/categories/getAll

*Description:* Retrieve all inventory categories

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Furniture"
    },
    {
      "id": 2,
      "name": "Fabrics"
    }
  ]
}


#### Get Category by ID
*Endpoint:* POST /api/inventory/categories/getById

*Request Body:*
json
{
  "id": 1
}


#### Update Category
*Endpoint:* POST /api/inventory/categories/update

*Request Body:*
json
{
  "id": 1,
  "name": "Updated Furniture"
}


#### Delete Category
*Endpoint:* POST /api/inventory/categories/delete

*Request Body:*
json
{
  "id": 1
}


### Inventory Items Management

#### Create Inventory Item
*Endpoint:* POST /api/inventory/items/create

*Description:* Create a new inventory item with optional image

*Content-Type:* multipart/form-data

*Request Body:*
form-data
{
  "name": "Wooden Chair",
  "category_id": 1,
  "unit": "piece",
  "storage_location": "Warehouse A",
  "notes": "Beautiful wooden chair for events",
  "item_image": [file] // Optional
}


*Response:*
json
{
  "success": true,
  "message": "Inventory item created successfully",
  "data": {
    "id": 1,
    "name": "Wooden Chair",
    "category_id": 1,
    "unit": "piece",
    "storage_location": "Warehouse A",
    "notes": "Beautiful wooden chair for events",
    "item_image": "/uploads/inventory/items/1/item_image.jpg"
  }
}


#### Get All Inventory Items
*Endpoint:* POST /api/inventory/items/getAll

*Description:* Retrieve all inventory items with category information

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Inventory items retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Wooden Chair",
      "category_id": 1,
      "category_name": "Furniture",
      "unit": "piece",
      "storage_location": "Warehouse A",
      "notes": "Beautiful wooden chair for events"
    }
  ],
  "count": 1
}


#### Get Inventory Item by ID
*Endpoint:* POST /api/inventory/items/getById

*Request Body:*
json
{
  "id": 1
}


#### Update Inventory Item
*Endpoint:* POST /api/inventory/items/update

*Content-Type:* multipart/form-data

*Request Body:*
form-data
{
  "id": 1,
  "name": "Updated Wooden Chair",
  "category_id": 1,
  "unit": "piece",
  "storage_location": "Warehouse B",
  "notes": "Updated notes",
  "item_image": [file] // Optional
}


#### Delete Inventory Item
*Endpoint:* POST /api/inventory/items/delete

*Request Body:*
json
{
  "id": 1
}


### Stock Management

#### Create Stock
*Endpoint:* POST /api/inventory/stock/create

*Description:* Add stock for an inventory item

*Request Body:*
json
{
  "item_id": 1,
  "quantity_available": 10
}


*Response:*
json
{
  "success": true,
  "message": "Stock created successfully",
  "data": {
    "id": 1,
    "item_id": 1,
    "quantity_available": 10
  }
}


#### Get Stock by Item ID
*Endpoint:* POST /api/inventory/stock/getByItemId

*Description:* Get stock information for a specific item

*Request Body:*
json
{
  "item_id": 1
}


*Response:*
json
{
  "success": true,
  "message": "Stock retrieved successfully",
  "data": {
    "item_id": 1,
    "quantity_available": 8
  }
}


#### Update Stock
*Endpoint:* POST /api/inventory/stock/update

*Description:* Update stock quantity for an item

*Request Body:*
json
{
  "item_id": 1,
  "quantity_available": 15
}


#### Get All Stock
*Endpoint:* POST /api/inventory/stock/getAll

*Description:* Get stock information for all items

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Stock retrieved successfully",
  "data": [
    {
      "item_id": 1,
      "quantity_available": 8,
      "item_name": "Wooden Chair",
      "category_name": "Furniture"
    }
  ],
  "count": 1
}


### Material Issuances

#### Create Material Issuance
*Endpoint:* POST /api/inventory/issuances/create

*Description:* Issue materials for an event (automatically updates stock)

*Request Body:*
json
{
  "item_id": 1,
  "transaction_type": "OUT",
  "quantity": 5,
  "event_id": 1,
  "notes": "For wedding decoration"
}


*Response:*
json
{
  "success": true,
  "message": "Material issuance created successfully",
  "data": {
    "id": 1,
    "item_id": 1,
    "transaction_type": "OUT",
    "quantity_issued": 5,
    "event_id": 1,
    "notes": "For wedding decoration",
    "created_at": "2024-01-15T10:30:00Z"
  }
}


#### Get All Material Issuances
*Endpoint:* POST /api/inventory/issuances/getAll

*Description:* Retrieve all material issuances

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Material issuances retrieved successfully",
  "data": [
    {
      "id": 1,
      "item_id": 1,
      "transaction_type": "OUT",
      "quantity_issued": 5,
      "event_id": 1,
      "notes": "For wedding decoration",
      "item_name": "Wooden Chair",
      "category_name": "Furniture",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ],
  "count": 1
}


#### Get Material Issuance by ID
*Endpoint:* POST /api/inventory/issuances/getById

*Request Body:*
json
{
  "id": 1
}


#### Update Material Issuance
*Endpoint:* POST /api/inventory/issuances/update

*Description:* Update material issuance (automatically adjusts stock)

*Request Body:*
json
{
  "id": 1,
  "item_id": 1,
  "transaction_type": "IN",
  "quantity": 3,
  "event_id": 1,
  "notes": "Returned items"
}


#### Delete Material Issuance
*Endpoint:* POST /api/inventory/issuances/delete

*Description:* Delete material issuance (automatically reverses stock changes)

*Request Body:*
json
{
  "id": 1
}


### Stock Transactions

#### Record Transaction
*Endpoint:* POST /api/inventory/transactions

*Description:* Record stock movement transactions

*Request Body:*
json
{
  "item_id": 1,
  "transaction_type": "IN",
  "quantity": 10,
  "notes": "Stock received from supplier"
}


#### Get Stock Balance
*Endpoint:* POST /api/inventory/stock/balance

*Description:* Get current stock balance for all items

*Request Body:*
json
{}


---

## 🔧 Materials API

### Get All Materials
*Endpoint:* POST /api/materials/getAll

*Description:* Get all materials with stock information

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Materials retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Wooden Chair",
      "category_id": 1,
      "category_name": "Furniture",
      "unit": "piece",
      "storage_location": "Warehouse A",
      "notes": "Beautiful wooden chair",
      "quantity_available": 8
    }
  ],
  "count": 1
}


### Get Material by ID
*Endpoint:* POST /api/materials/getById

*Request Body:*
json
{
  "id": 1
}


### Create Material
*Endpoint:* POST /api/materials/create

*Request Body:*
json
{
  "name": "New Material",
  "category_id": 1,
  "unit": "piece",
  "storage_location": "Warehouse A",
  "notes": "Material description"
}


### Update Material
*Endpoint:* POST /api/materials/update

*Request Body:*
json
{
  "id": 1,
  "name": "Updated Material",
  "category_id": 1,
  "unit": "piece",
  "storage_location": "Warehouse B",
  "notes": "Updated description"
}


### Delete Material
*Endpoint:* POST /api/materials/delete

*Request Body:*
json
{
  "id": 1
}


### Material Categories

#### Get All Categories
*Endpoint:* POST /api/materials/categories/getAll

#### Create Category
*Endpoint:* POST /api/materials/categories

#### Update Category
*Endpoint:* POST /api/materials/categories/update

#### Delete Category
*Endpoint:* POST /api/materials/categories/delete

### Material Inventory

#### Get All Inventory
*Endpoint:* POST /api/materials/inventory/getAll

#### Update Inventory
*Endpoint:* POST /api/materials/inventory/update

#### Adjust Inventory
*Endpoint:* POST /api/materials/inventory/adjust

#### Get Low Stock Items
*Endpoint:* POST /api/materials/inventory/low-stock

### Specialized Material Types

#### Furniture
- *Get by Item:* POST /api/materials/furniture/getByItem
- *Create:* POST /api/materials/furniture
- *Update:* POST /api/materials/furniture/update
- *Delete:* POST /api/materials/furniture/delete

#### Fabric
- *Get by Item:* POST /api/materials/fabric/getByItem
- *Create:* POST /api/materials/fabric
- *Update:* POST /api/materials/fabric/update
- *Delete:* POST /api/materials/fabric/delete

#### Frame Structures
- *Get by Item:* POST /api/materials/frame-structures/getByItem
- *Create:* POST /api/materials/frame-structures
- *Update:* POST /api/materials/frame-structures/update
- *Delete:* POST /api/materials/frame-structures/delete

#### Carpets
- *Get by Item:* POST /api/materials/carpets/getByItem
- *Create:* POST /api/materials/carpets
- *Update:* POST /api/materials/carpets/update
- *Delete:* POST /api/materials/carpets/delete

#### Thermocol Materials
- *Get by Item:* POST /api/materials/thermocol/getByItem
- *Create:* POST /api/materials/thermocol
- *Update:* POST /api/materials/thermocol/update
- *Delete:* POST /api/materials/thermocol/delete

#### Stationery
- *Get by Item:* POST /api/materials/stationery/getByItem
- *Create:* POST /api/materials/stationery
- *Update:* POST /api/materials/stationery/update
- *Delete:* POST /api/materials/stationery/delete

#### Murti Sets
- *Get by Item:* POST /api/materials/murti-sets/getByItem
- *Create:* POST /api/materials/murti-sets
- *Update:* POST /api/materials/murti-sets/update
- *Delete:* POST /api/materials/murti-sets/delete

---

## 🛠 Tools API

### Get All Tools
*Endpoint:* POST /api/tools/getAll

### Create Tool
*Endpoint:* POST /api/tools/create

### Update Tool
*Endpoint:* POST /api/tools/update

### Delete Tool
*Endpoint:* POST /api/tools/delete

### Tool Inventory

#### Get All Tool Inventory
*Endpoint:* POST /api/tools/inventory/getAll

#### Create Tool Inventory
*Endpoint:* POST /api/tools/inventory

#### Update Tool Inventory
*Endpoint:* POST /api/tools/inventory/update

#### Adjust Tool Quantity
*Endpoint:* POST /api/tools/inventory/adjust

---

## 💰 Costs API

### Event Cost Items

#### Get Event Cost Items
*Endpoint:* POST /api/costs/eventCostItems/getByEvent

#### Create Cost Item (URL)
*Endpoint:* POST /api/costs/eventCostItems/create

#### Create Cost Item (File)
*Endpoint:* POST /api/costs/eventCostItems/createWithFile

#### Update Cost Item (URL)
*Endpoint:* POST /api/costs/eventCostItems/update

#### Update Cost Item (File)
*Endpoint:* POST /api/costs/eventCostItems/updateWithFile

#### Delete Cost Item
*Endpoint:* POST /api/costs/eventCostItems/delete

---

## 📤 Issuance API

### Material Issuances

#### Create Material Issuance
*Endpoint:* POST /api/issuance/materials

#### Get All Material Issuances
*Endpoint:* POST /api/issuance/materials/getAll

#### Get Issuances by Event
*Endpoint:* POST /api/issuance/materials/event/getByEvent

### Tool Issuances

#### Create Tool Issuance
*Endpoint:* POST /api/issuance/tools

#### Get All Tool Issuances
*Endpoint:* POST /api/issuance/tools/getAll

#### Get Tool Issuances by Event
*Endpoint:* POST /api/issuance/tools/event/getByEvent

---

## 📸 Gallery API

### Upload Design Image
*Endpoint:* POST /api/gallery/design

*Description:* Upload design image for an event

*Content-Type:* multipart/form-data

*Request Body:*
form-data
{
  "event_id": 1,
  "image_url": "design_image.jpg",
  "notes": "Initial design concept"
}


### Upload Final Image
*Endpoint:* POST /api/gallery/final

*Description:* Upload final image for an event

*Content-Type:* multipart/form-data

### Get Event Images
*Endpoint:* POST /api/gallery/getEventImages

*Request Body:*
json
{
  "event_id": 1
}


---

## 📅 Event Templates API

### Get All Templates
*Endpoint:* POST /api/event-templates/getAll

### Get Template by ID
*Endpoint:* POST /api/event-templates/getById

### Create Template
*Endpoint:* POST /api/event-templates/create

### Update Template
*Endpoint:* POST /api/event-templates/update

### Delete Template
*Endpoint:* POST /api/event-templates/delete

---

## 📆 Years API

### Get All Years
*Endpoint:* POST /api/years/getAll

### Get Year by ID
*Endpoint:* POST /api/years/getById

### Create Year
*Endpoint:* POST /api/years/create

### Update Year
*Endpoint:* POST /api/years/update

### Delete Year
*Endpoint:* POST /api/years/delete

---

## Error Handling

### Common Error Codes

| Status Code | Description |
|-------------|-------------|
| 400 | Bad Request - Invalid input data |
| 401 | Unauthorized - Authentication required |
| 404 | Not Found - Resource not found |
| 409 | Conflict - Resource already exists |
| 500 | Internal Server Error |

### Error Response Example
json
{
  "success": false,
  "message": "Validation error",
  "details": [
    {
      "field": "username",
      "message": "Username must be between 3 and 30 characters"
    },
    {
      "field": "password",
      "message": "Password is required"
    }
  ]
}


---

## Quick Start Guide

### 1. Create a User
bash
curl -X POST http://localhost:5000/api/users/create \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin123",
    "role": "admin"
  }'


### 2. Create an Event
bash
curl -X POST http://localhost:5000/api/events/create \
  -F "template_id=1" \
  -F "year_id=1" \
  -F "date=2024-02-15" \
  -F "location=Community Hall" \
  -F "description=Colorful birthday decoration"


### 3. Add Inventory Category
bash
curl -X POST http://localhost:5000/api/inventory/categories/create \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Furniture"
  }'


### 4. Add Inventory Item
bash
curl -X POST http://localhost:5000/api/inventory/items/create \
  -F "name=Wooden Chair" \
  -F "category_id=1" \
  -F "unit=piece" \
  -F "storage_location=Warehouse A" \
  -F "notes=Beautiful wooden chair for events"


### 5. Add Stock
bash
curl -X POST http://localhost:5000/api/inventory/stock/create \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "quantity_available": 20
  }'


### 6. Issue Materials
bash
curl -X POST http://localhost:5000/api/inventory/issuances/create \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "transaction_type": "OUT",
    "quantity": 5,
    "event_id": 1,
    "notes": "For event decoration"
  }'


---

## 📝 Notes

- All endpoints return JSON responses
- File uploads use multipart/form-data content type
- Dates should be in ISO format (YYYY-MM-DD)
- Image files are stored in the /uploads directory
- Stock levels are automatically updated when materials are issued
- Transaction types: IN (add to stock), OUT (remove from stock)
- The API supports comprehensive inventory management with specialized categories
- Material issuances automatically handle stock calculations
- All database operations use transactions for data consistency

---

## 🔧 Development

For development and testing:
- Server runs on http://localhost:5000
- Use tools like Postman or Insomnia for API testing
- Check server logs for detailed error information
- All file uploads are validated for type and size
- Database transactions ensure data integrity

---

Last updated: January 2024