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


### Get Event List
*Endpoint:* POST /api/events/getList

*Description:* Retrieve a simple list of event IDs and names (descriptions) for dropdowns or selection purposes

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Event list retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Beautiful wedding decoration setup"
    },
    {
      "id": 2,
      "name": "Corporate event decoration"
    },
    {
      "id": 3,
      "name": "Birthday party setup"
    }
  ],
  "count": 3
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


#### Get Inventory Item List
*Endpoint:* POST /api/inventory/items/getList

*Description:* Retrieve a simple list of inventory item IDs and names for dropdowns or selection purposes

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Inventory item list retrieved successfully",
  "data": [
    {
      "id": 1,
      "name": "Wooden Chair"
    },
    {
      "id": 2,
      "name": "Red Fabric"
    },
    {
      "id": 3,
      "name": "Metal Frame"
    }
  ],
  "count": 3
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


#### Get Material Issuance History by Item ID
*Endpoint:* POST /api/inventory/issuances/getHistoryByItemId

*Description:* Retrieve the complete issuance history for a specific inventory item, including all transactions (issuances and returns) with summary statistics

*Request Body:*
json
{
  "item_id": 1
}


*Response:*
json
{
  "success": true,
  "message": "Material issuance history retrieved successfully",
  "data": {
    "item_info": {
      "id": 1,
      "name": "Wooden Chair",
      "category_name": "Furniture",
      "unit": "piece",
      "storage_location": "Warehouse A"
    },
    "issuance_history": [
      {
        "id": 1,
        "item_id": 1,
        "quantity_issued": 5,
        "notes": "For wedding decoration",
        "issued_at": "2024-01-15T10:30:00Z",
        "transaction_type": "OUT",
        "event_id": 1,
        "item_name": "Wooden Chair",
        "category_name": "Furniture",
        "unit": "piece",
        "storage_location": "Warehouse A"
      },
      {
        "id": 2,
        "item_id": 1,
        "quantity_issued": 2,
        "notes": "Returned after event",
        "issued_at": "2024-01-16T14:20:00Z",
        "transaction_type": "IN",
        "event_id": 1,
        "item_name": "Wooden Chair",
        "category_name": "Furniture",
        "unit": "piece",
        "storage_location": "Warehouse A"
      }
    ],
    "summary": {
      "total_transactions": 2,
      "total_issued": 5,
      "total_returned": 2,
      "net_issued": 3,
      "current_stock": 47
    },
    "count": 2
  }
}


#### Get Material Issuance History by Event ID
*Endpoint:* POST /api/inventory/issuances/getHistoryByEventId

*Description:* Retrieve all material issuance history for a specific event, including all inventory items used, transactions, and comprehensive summary statistics

*Request Body:*
json
{
  "event_id": 1
}


*Response:*
json
{
  "success": true,
  "message": "Event material issuance history retrieved successfully",
  "data": {
    "event_id": 1,
    "issuance_history": [
      {
        "id": 1,
        "item_id": 1,
        "quantity_issued": 5,
        "notes": "For wedding decoration",
        "issued_at": "2024-01-15T10:30:00Z",
        "transaction_type": "OUT",
        "event_id": 1,
        "item_name": "Wooden Chair",
        "category_name": "Furniture",
        "unit": "piece",
        "storage_location": "Warehouse A",
        "item_image": "/uploads/inventory/items/1/chair.jpg"
      },
      {
        "id": 2,
        "item_id": 2,
        "quantity_issued": 10,
        "notes": "Red fabric for decoration",
        "issued_at": "2024-01-15T11:00:00Z",
        "transaction_type": "OUT",
        "event_id": 1,
        "item_name": "Red Fabric",
        "category_name": "Fabric",
        "unit": "meters",
        "storage_location": "Warehouse B",
        "item_image": "/uploads/inventory/items/2/fabric.jpg"
      }
    ],
    "issuances_by_item": [
      {
        "item_info": {
          "id": 1,
          "name": "Wooden Chair",
          "category_name": "Furniture",
          "unit": "piece",
          "storage_location": "Warehouse A",
          "item_image": "/uploads/inventory/items/1/chair.jpg"
        },
        "transactions": [
          {
            "id": 1,
            "quantity_issued": 5,
            "notes": "For wedding decoration",
            "issued_at": "2024-01-15T10:30:00Z",
            "transaction_type": "OUT"
          }
        ]
      },
      {
        "item_info": {
          "id": 2,
          "name": "Red Fabric",
          "category_name": "Fabric",
          "unit": "meters",
          "storage_location": "Warehouse B",
          "item_image": "/uploads/inventory/items/2/fabric.jpg"
        },
        "transactions": [
          {
            "id": 2,
            "quantity_issued": 10,
            "notes": "Red fabric for decoration",
            "issued_at": "2024-01-15T11:00:00Z",
            "transaction_type": "OUT"
          }
        ]
      }
    ],
    "summary": {
      "total_transactions": 2,
      "total_items_used": 2,
      "total_quantity_issued": 15,
      "total_quantity_returned": 0,
      "net_quantity_issued": 15,
      "categories_used": ["Furniture", "Fabric"]
    },
    "count": 2
  }
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

## 🗑️ Delete Inventory Item API

### Delete Inventory Item

**Endpoint:** `POST /api/inventory/items/delete`

**Content-Type:** `application/json`

**Request Body:**
```json
{
  "id": 1
}
```

**Parameters:**
- `id` (integer, required): The ID of the inventory item to delete

**Response:**
```json
{
  "success": true,
  "message": "Inventory item deleted successfully from all related tables",
  "data": {
    "deleted_item": {
      "id": 1,
      "name": "Wooden Chair",
      "category_id": 2,
      "unit": "piece",
      "storage_location": "Warehouse A",
      "notes": "Beautiful wooden chair for events",
      "item_image": "/uploads/inventory/items/1/chair.jpg",
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-16T14:20:00Z"
    },
    "category_name": "Furniture",
    "deleted_from_tables": [
      "inventory_items",
      "inventory_stock",
      "furniture"
    ]
  }
}
```

**Error Responses:**

**Item Not Found (404):**
```json
{
  "success": false,
  "error": "Inventory item not found"
}
```

**Invalid ID (400):**
```json
{
  "success": false,
  "error": "Item ID must be a valid number"
}
```

**Missing ID (400):**
```json
{
  "success": false,
  "error": "Item ID is required"
}
```

**What Gets Deleted:**
This API performs a comprehensive deletion that removes the inventory item from:

1. **inventory_items** - Main inventory items table
2. **inventory_stock** - Stock information for the item
3. **Category-specific table** - Based on the item's category:
   - Stationery → `stationery` table
   - Furniture → `furniture` table
   - Fabric → `fabric` table
   - Frame Structures → `frame_structures` table
   - Carpets → `carpets` table
   - Thermocol Materials → `thermocol_materials` table
   - Murti Sets → `murti_sets` table
4. **Image files** - Associated image files are deleted from the filesystem
5. **Empty directories** - Empty item directories are cleaned up

**Example Usage:**

**cURL:**
```bash
curl -X POST http://localhost:5000/api/inventory/items/delete \
  -H "Content-Type: application/json" \
  -d '{"id": 1}'
```

**JavaScript:**
```javascript
const deleteInventoryItem = async (itemId) => {
  const response = await fetch('http://localhost:5000/api/inventory/items/delete', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({ id: itemId })
  });
  
  const result = await response.json();
  return result;
};

// Usage
deleteInventoryItem(1).then(result => {
  console.log('Item deleted:', result);
});
```

**Python:**
```python
import requests

def delete_inventory_item(item_id):
    url = "http://localhost:5000/api/inventory/items/delete"
    data = {"id": item_id}
    
    response = requests.post(url, json=data)
    return response.json()

# Usage
result = delete_inventory_item(1)
print("Item deleted:", result)
```

**PowerShell:**
```powershell
$body = @{
    id = 1
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:5000/api/inventory/items/delete" -Method POST -Body $body -ContentType "application/json"
Write-Output $response
```

**Important Notes:**
- ⚠️ **This operation is irreversible** - once deleted, the item and all its data cannot be recovered
- The deletion uses database transactions to ensure data integrity
- Image files are automatically deleted from the filesystem
- Empty directories are cleaned up after deletion
- The API returns detailed information about what was deleted

## 📊 Dashboard API

### Get Dashboard Statistics
*Endpoint:* POST /api/dashboard/stats

*Description:* Retrieve comprehensive dashboard statistics including total counts, cost breakdown by year, recent events, and top categories

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Dashboard statistics retrieved successfully",
  "data": {
    "totals": {
      "templates": 2,
      "years": 5,
      "events": 4,
      "materials": 2
    },
    "cost_by_year": [
      {
        "year_id": 1,
        "year": "2024",
        "total_cost": 15000,
        "event_count": 3
      },
      {
        "year_id": 2,
        "year": "2025",
        "total_cost": 25000,
        "event_count": 2
      }
    ],
    "recent_events": [
      {
        "id": 1,
        "name": "Wedding Decoration",
        "date": "2024-06-15",
        "location": "Grand Hotel",
        "year": "2024",
        "template_name": "Wedding",
        "total_cost": 5000
      },
      {
        "id": 2,
        "name": "Corporate Event",
        "date": "2024-05-20",
        "location": "Convention Center",
        "year": "2024",
        "template_name": "Corporate",
        "total_cost": 3000
      }
    ],
    "top_categories": [
      {
        "id": 1,
        "category_name": "Furniture",
        "item_count": 15,
        "total_stock": 120
      },
      {
        "id": 2,
        "category_name": "Fabric",
        "item_count": 12,
        "total_stock": 85
      }
    ]
  }
}


### Get Total Counts Only
*Endpoint:* POST /api/dashboard/counts

*Description:* Retrieve only the total counts for templates, years, events, and materials

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Total counts retrieved successfully",
  "data": {
    "templates": 2,
    "years": 5,
    "events": 4,
    "materials": 2
  }
}


### Get Cost by Year (for Graphs)
*Endpoint:* POST /api/dashboard/cost-by-year

*Description:* Retrieve cost breakdown by year, perfect for creating charts and graphs

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Cost by year retrieved successfully",
  "data": {
    "cost_by_year": [
      {
        "year_id": 1,
        "year": "2024",
        "total_cost": 15000,
        "event_count": 3
      },
      {
        "year_id": 2,
        "year": "2025",
        "total_cost": 25000,
        "event_count": 2
      }
    ],
    "count": 2
  }
}


### Get Recent Events
*Endpoint:* POST /api/dashboard/recent-events

*Description:* Retrieve the 5 most recent events with their details and costs

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Recent events retrieved successfully",
  "data": {
    "recent_events": [
      {
        "id": 1,
        "name": "Wedding Decoration",
        "date": "2024-06-15",
        "location": "Grand Hotel",
        "year": "2024",
        "template_name": "Wedding",
        "total_cost": 5000
      }
    ],
    "count": 1
  }
}


### Get Top Categories
*Endpoint:* POST /api/dashboard/top-categories

*Description:* Retrieve the top 5 categories by item count with stock information

*Request Body:*
json
{}


*Response:*
json
{
  "success": true,
  "message": "Top categories retrieved successfully",
  "data": {
    "top_categories": [
      {
        "id": 1,
        "category_name": "Furniture",
        "item_count": 15,
        "total_stock": 120
      }
    ],
    "count": 1
  }
}


**Usage Examples:**

**cURL (Complete Dashboard Stats):**
```bash
curl -X POST http://localhost:5000/api/dashboard/stats \
  -H "Content-Type: application/json" \
  -d '{}'
```

**JavaScript (Cost by Year for Charts):**
```javascript
const getCostByYear = async () => {
  const response = await fetch('http://localhost:5000/api/dashboard/cost-by-year', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({})
  });
  return response.json();
};

// Usage for chart data
getCostByYear().then(result => {
  const chartData = result.data.cost_by_year.map(year => ({
    year: year.year,
    cost: year.total_cost,
    events: year.event_count
  }));
  console.log('Chart data:', chartData);
});
```

**Python (Dashboard Statistics):**
```python
import requests

def get_dashboard_stats():
    url = "http://localhost:5000/api/dashboard/stats"
    response = requests.post(url, json={})
    return response.json()

# Usage
result = get_dashboard_stats()
print("Total Events:", result['data']['totals']['events'])
print("Total Materials:", result['data']['totals']['materials'])

# Cost data for graphs
cost_data = result['data']['cost_by_year']
for year_data in cost_data:
    print(f"Year {year_data['year']}: ₹{year_data['total_cost']}")
```

## 🔧 Development

For development and testing:
- Server runs on http://localhost:5000
- Use tools like Postman or Insomnia for API testing
- Check server logs for detailed error information
- All file uploads are validated for type and size
- Database transactions ensure data integrity

---

Last updated: January 2024