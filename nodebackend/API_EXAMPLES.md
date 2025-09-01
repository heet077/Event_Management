# DecorationApp API Examples

This document provides comprehensive examples for all API endpoints in your decoration app.

## Base URL
```
http://localhost:5000
```

---



---

## 👥 User Management APIs

### 1. Get All Users
**Endpoint:** `GET /api/users`

**Description:** Retrieve all users in the system.

**Example:**
```bash
curl -X GET http://localhost:5000/api/users
```

**Response:**
```json
[
  {
    "id": 1,
    "username": "admin",
    "role": "admin",
    "created_at": "2024-01-15T10:30:00Z"
  },
  {
    "id": 2,
    "username": "user1",
    "role": "viewer",
    "created_at": "2024-01-16T14:20:00Z"
  }
]
```

### 2. Delete User
**Endpoint:** `DELETE /api/users/:id`

**Description:** Delete a user by ID.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/users/2
```

**Response:**
```json
{
  "message": "User deleted successfully"
}
```

---

## 🎉 Event Management APIs

### 1. Get All Events
**Endpoint:** `GET /api/events`

**Description:** Retrieve all events.

**Example:**
```bash
curl -X GET http://localhost:5000/api/events
```

**Response:**
```json
[
  {
    "id": 1,
    "template_id": 1,
    "year_id": 2024,
    "date": "2024-02-15",
    "location": "Grand Hotel",
    "description": "Wedding decoration",
    "cover_image": "https://drive.google.com/file/d/...",
    "created_at": "2024-01-15T10:30:00Z"
  },
  {
    "id": 2,
    "template_id": 2,
    "year_id": 2024,
    "date": "2024-03-20",
    "location": "Community Center",
    "description": "Birthday party decoration",
    "cover_image": "https://drive.google.com/file/d/...",
    "created_at": "2024-01-16T14:20:00Z"
  }
]
```

### 2. Get Event by ID
**Endpoint:** `GET /api/events/:id`

**Description:** Retrieve a specific event by ID.

**Example:**
```bash
curl -X GET http://localhost:5000/api/events/1
```

**Response:**
```json
{
  "id": 1,
  "template_id": 1,
  "year_id": 2024,
  "date": "2024-02-15",
  "location": "Grand Hotel",
  "description": "Wedding decoration",
  "cover_image": "https://drive.google.com/file/d/...",
  "created_at": "2024-01-15T10:30:00Z"
}
```

### 3. Create New Event
**Endpoint:** `POST /api/events`

**Description:** Create a new event with optional cover image upload.

**Example with File Upload:**
```bash
curl -X POST http://localhost:5000/api/events \
  -F "cover_image=@/path/to/cover.jpg" \
  -F "template_id=1" \
  -F "year_id=2024" \
  -F "date=2024-04-10" \
  -F "location=Beach Resort" \
  -F "description=Beach wedding decoration"
```

**Example with Image URL:**
```bash
curl -X POST http://localhost:5000/api/events \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": 1,
    "year_id": 2024,
    "date": "2024-04-10",
    "location": "Beach Resort",
    "description": "Beach wedding decoration",
    "cover_image": "https://example.com/cover.jpg"
  }'
```

**Response:**
```json
{
  "id": 3,
  "template_id": 1,
  "year_id": 2024,
  "date": "2024-04-10",
  "location": "Beach Resort",
  "description": "Beach wedding decoration",
  "cover_image": "https://drive.google.com/file/d/cover_image_3.jpg/view",
  "created_at": "2024-01-17T09:15:00Z"
}
```

**Note:** Cover images are stored locally in organized folders: `/uploads/events/event_id/cover_image_event_id.jpg`

### 4. Update Event
**Endpoint:** `PUT /api/events/:id`

**Description:** Update an existing event with optional cover image upload.

**Example with File Upload:**
```bash
curl -X PUT http://localhost:5000/api/events/1 \
  -F "cover_image=@/path/to/new-cover.jpg" \
  -F "template_id=2" \
  -F "year_id=2024" \
  -F "date=2024-02-20" \
  -F "location=Updated Grand Hotel" \
  -F "description=Updated wedding decoration"
```

**Example with Image URL:**
```bash
curl -X PUT http://localhost:5000/api/events/1 \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": 2,
    "year_id": 2024,
    "date": "2024-02-20",
    "location": "Updated Grand Hotel",
    "description": "Updated wedding decoration",
    "cover_image": "https://example.com/new-cover.jpg"
  }'
```

**Response:**
```json
{
  "id": 1,
  "template_id": 2,
  "year_id": 2024,
  "date": "2024-02-20",
  "location": "Updated Grand Hotel",
  "description": "Updated wedding decoration",
  "cover_image": "https://drive.google.com/file/d/cover_image_1.jpg/view",
  "updated_at": "2024-01-17T10:30:00Z"
}
```

**Note:** When updating with a new cover image, it will be stored locally and replace the existing one.

### 5. Delete Event
**Endpoint:** `DELETE /api/events/:id`

**Description:** Delete an event by ID.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/events/2
```

**Response:**
```json
{
  "message": "Event deleted successfully"
}
```

### 6. Get Complete Event Details
**Endpoint:** `GET /api/events/:id/details`

**Description:** Get comprehensive event details including gallery, costs, and issuances.

**Example:**
```bash
curl -X GET http://localhost:5000/api/events/1/details
```

**Response:**
```json
{
  "event": {
    "id": 1,
    "template_id": 1,
    "year_id": 2024,
    "date": "2024-02-15",
    "location": "Grand Hotel",
    "description": "Wedding decoration",
    "cover_image": "https://drive.google.com/file/d/..."
  },
  "gallery": {
    "design": [
      {
        "id": 1,
        "event_id": 1,
        "image_url": "https://drive.google.com/file/d/design1.jpg",
        "notes": "Initial design concept",
        "created_at": "2024-01-15T11:00:00Z"
      }
    ],
    "final": [
      {
        "id": 2,
        "event_id": 1,
        "image_url": "https://drive.google.com/file/d/final1.jpg",
        "description": "Final decoration result",
        "created_at": "2024-01-15T16:00:00Z"
      }
    ]
  },
  "cost": {
    "id": 1,
    "event_id": 1,
    "total_cost": 2500.00,
    "materials_cost": 1500.00,
    "labor_cost": 800.00,
    "other_costs": 200.00,
    "notes": "Within budget"
  },
  "issuances": [
    {
      "id": 1,
      "event_id": 1,
      "material_id": 1,
      "quantity": 10,
      "issued_at": "2024-01-15T12:00:00Z",
      "notes": "Flowers for centerpieces"
    }
  ]
}
```

---

## 📋 Event Template APIs

### 1. Get All Templates
**Endpoint:** `GET /api/event-templates`

**Description:** Retrieve all event templates.

**Example:**
```bash
curl -X GET http://localhost:5000/api/event-templates
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Wedding Template",
    "created_at": "2024-01-01T00:00:00Z"
  },
  {
    "id": 2,
    "name": "Birthday Template",
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### 2. Get Template by ID
**Endpoint:** `GET /api/event-templates/:id`

**Description:** Get a specific template by ID.

**Example:**
```bash
curl -X GET http://localhost:5000/api/event-templates/1
```

**Response:**
```json
{
  "id": 1,
  "name": "Wedding Template",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### 3. Create Template
**Endpoint:** `POST /api/event-templates`

**Description:** Create a new event template.

**Example:**
```bash
curl -X POST http://localhost:5000/api/event-templates \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Corporate Event Template"
  }'
```

**Response:**
```json
{
  "id": 3,
  "name": "Corporate Event Template",
  "created_at": "2024-01-17T11:00:00Z"
}
```

### 4. Update Template
**Endpoint:** `PUT /api/event-templates/:id`

**Description:** Update an existing template.

**Example:**
```bash
curl -X PUT http://localhost:5000/api/event-templates/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Wedding Template"
  }'
```

**Response:**
```json
{
  "id": 1,
  "name": "Updated Wedding Template",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### 5. Delete Template
**Endpoint:** `DELETE /api/event-templates/:id`

**Description:** Delete a template by ID.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/event-templates/2
```

**Response:**
```json
{
  "message": "Template deleted successfully"
}
```

---

## 🧱 Material Management APIs

### 1. Get All Materials
**Endpoint:** `GET /api/materials`

**Description:** Retrieve all materials.

**Example:**
```bash
curl -X GET http://localhost:5000/api/materials
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Roses",
    "category_id": 1,
    "category_name": "Flowers",
    "unit": "pieces",
    "storage_location": "Cold Storage A",
    "notes": "Fresh red roses",
    "quantity_available": 150,
    "created_at": "2024-01-01T00:00:00Z"
  },
  {
    "id": 2,
    "name": "Fabric",
    "category_id": 2,
    "category_name": "Textiles",
    "unit": "meters",
    "storage_location": "Warehouse B",
    "notes": "Silk fabric for draping",
    "quantity_available": 50,
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### 2. Create Material
**Endpoint:** `POST /api/materials`

**Description:** Create a new material.

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Candles",
    "category_id": 3,
    "unit": "pieces",
    "storage_location": "Warehouse A",
    "notes": "Decorative candles"
  }'
```

**Response:**
```json
{
  "id": 3,
  "name": "Candles",
  "category_id": 3,
  "unit": "pieces",
  "storage_location": "Warehouse A",
  "notes": "Decorative candles",
  "created_at": "2024-01-17T12:00:00Z"
}
```

### 3. Update Material
**Endpoint:** `PUT /api/materials/:id`

**Description:** Update an existing material.

**Example:**
```bash
curl -X PUT http://localhost:5000/api/materials/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Premium Roses",
    "category_id": 1,
    "unit": "pieces",
    "storage_location": "Cold Storage A",
    "notes": "Premium quality red roses"
  }'
```

**Response:**
```json
{
  "id": 1,
  "name": "Premium Roses",
  "category_id": 1,
  "unit": "pieces",
  "storage_location": "Cold Storage A",
  "notes": "Premium quality red roses",
  "updated_at": "2024-01-17T12:30:00Z"
}
```

### 4. Delete Material
**Endpoint:** `DELETE /api/materials/:id`

**Description:** Delete a material by ID.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/materials/2
```

**Response:**
```json
{
  "message": "Material deleted successfully"
}
```

---

## 📦 Inventory Management APIs

### 1. Get Inventory
**Endpoint:** `GET /api/materials/inventory`

**Description:** Get current inventory levels for all materials.

**Example:**
```bash
curl -X GET http://localhost:5000/api/materials/inventory
```

**Response:**
```json
[
  {
    "id": 1,
    "item_id": 1,
    "quantity_available": 150,
    "item_name": "Roses",
    "unit": "pieces",
    "category_name": "Flowers"
  },
  {
    "id": 2,
    "item_id": 2,
    "quantity_available": 50,
    "item_name": "Fabric",
    "unit": "meters",
    "category_name": "Textiles"
  }
]
```

### 2. Create Inventory Entry
**Endpoint:** `POST /api/materials/inventory`

**Description:** Create a new inventory entry for a material.

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/inventory \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 3,
    "quantity": 200
  }'
```

**Response:**
```json
{
  "id": 3,
  "item_id": 3,
  "quantity_available": 200,
  "created_at": "2024-01-17T13:00:00Z"
}
```

### 3. Update Inventory Quantity
**Endpoint:** `PUT /api/materials/inventory`

**Description:** Update the quantity of a material in inventory.

**Example:**
```bash
curl -X PUT http://localhost:5000/api/materials/inventory \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "quantity": 150
  }'
```

**Response:**
```json
{
  "id": 1,
  "item_id": 1,
  "quantity_available": 150,
  "updated_at": "2024-01-17T13:30:00Z"
}
```

### 4. Deduct Material Stock
**Endpoint:** `POST /api/materials/inventory/deduct`

**Description:** Deduct material stock for an event.

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/inventory/deduct \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "qty": 10
  }'
```

**Response:**
```json
{
  "id": 1,
  "item_id": 1,
  "quantity_available": 140,
  "updated_at": "2024-01-17T14:00:00Z"
}
```

---

## 🔧 Tool Management APIs

### 1. Get All Tools
**Endpoint:** `GET /api/tools`

**Description:** Retrieve all tools.

**Example:**
```bash
curl -X GET http://localhost:5000/api/tools
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Scissors",
    "image_url": "https://example.com/scissors.jpg",
    "notes": "Sharp scissors for cutting fabric",
    "created_at": "2024-01-01T00:00:00Z"
  },
  {
    "id": 2,
    "name": "Hot Glue Gun",
    "image_url": "https://example.com/glue-gun.jpg",
    "notes": "Hot glue gun for bonding materials",
    "created_at": "2024-01-01T00:00:00Z"
  }
]
```

### 2. Create Tool
**Endpoint:** `POST /api/tools`

**Description:** Create a new tool.

**Example:**
```bash
curl -X POST http://localhost:5000/api/tools \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Wire Cutters",
    "image_url": "https://example.com/wire-cutters.jpg",
    "notes": "Wire cutters for floral arrangements"
  }'
```

**Response:**
```json
{
  "id": 3,
  "name": "Wire Cutters",
  "image_url": "https://example.com/wire-cutters.jpg",
  "notes": "Wire cutters for floral arrangements",
  "created_at": "2024-01-17T14:30:00Z"
}
```

### 3. Update Tool
**Endpoint:** `PUT /api/tools/:id`

**Description:** Update an existing tool.

**Example:**
```bash
curl -X PUT http://localhost:5000/api/tools/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Professional Scissors",
    "image_url": "https://example.com/professional-scissors.jpg",
    "notes": "Professional grade scissors for cutting fabric"
  }'
```

**Response:**
```json
{
  "id": 1,
  "name": "Professional Scissors",
  "image_url": "https://example.com/professional-scissors.jpg",
  "notes": "Professional grade scissors for cutting fabric",
  "updated_at": "2024-01-17T15:00:00Z"
}
```

### 4. Delete Tool
**Endpoint:** `DELETE /api/tools/:id`

**Description:** Delete a tool by ID.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/tools/2
```

**Response:**
```json
{
  "message": "Tool deleted successfully"
}
```

---

## 🖼️ Gallery & Image Management APIs

### 1. Upload Design Image
**Endpoint:** `POST /api/gallery/design`

**Description:** Upload a design image for an event.

**Example with File Upload:**
```bash
curl -X POST http://localhost:5000/api/gallery/design \
  -F "image=@/path/to/design.jpg" \
  -F "event_id=1" \
  -F "notes=Initial design concept for wedding"
```

**Example with Image URL:**
```bash
curl -X POST http://localhost:5000/api/gallery/design \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "image_url": "https://example.com/design.jpg",
    "notes": "Initial design concept for wedding"
  }'
```

**Response:**
```json
{
  "id": 1,
  "event_id": 1,
  "image_url": "https://drive.google.com/file/d/design1.jpg",
  "notes": "Initial design concept for wedding",
  "created_at": "2024-01-17T15:30:00Z"
}
```

### 2. Upload Final Image
**Endpoint:** `POST /api/gallery/final`

**Description:** Upload a final image for an event.

**Example with File Upload:**
```bash
curl -X POST http://localhost:5000/api/gallery/final \
  -F "image=@/path/to/final.jpg" \
  -F "event_id=1" \
  -F "description=Final decoration result"
```

**Example with Image URL:**
```bash
curl -X POST http://localhost:5000/api/gallery/final \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "image_url": "https://example.com/final.jpg",
    "description": "Final decoration result"
  }'
```

**Response:**
```json
{
  "id": 2,
  "event_id": 1,
  "image_url": "https://drive.google.com/file/d/final1.jpg",
  "description": "Final decoration result",
  "created_at": "2024-01-17T16:00:00Z"
}
```

### 3. Get Event Images
**Endpoint:** `GET /api/gallery/:event_id`

**Description:** Get all images for a specific event.

**Example:**
```bash
curl -X GET http://localhost:5000/api/gallery/1
```

**Response:**
```json
{
  "design": [
    {
      "id": 1,
      "event_id": 1,
      "image_url": "https://drive.google.com/file/d/design1.jpg",
      "notes": "Initial design concept",
      "created_at": "2024-01-17T15:30:00Z"
    }
  ],
  "final": [
    {
      "id": 2,
      "event_id": 1,
      "image_url": "https://drive.google.com/file/d/final1.jpg",
      "description": "Final decoration result",
      "created_at": "2024-01-17T16:00:00Z"
    }
  ]
}
```


  "debugInfo": {
    "event_id": 1,
    "originalUrl": "https://picsum.photos/400/300",
    "tempFilePath": "/temp_uploads/abc123.jpg",
    "eventsFolder": "2DEF456GHI789",
    "eventFolder": "3GHI789JKL012",
    "finalFolder": "5MNO345PQR678",
    "uploadedFile": {
      "id": "6PQR678STU901",
      "name": "debug-test-1705500000000.jpg",
      "webViewLink": "https://drive.google.com/file/d/6PQR678STU901/view"
    }
  }
}
```

---

## 💰 Cost Management APIs

### 1. Get Event Cost Summary
**Endpoint:** `GET /api/costs/:event_id`

**Description:** Get cost summary for a specific event.

**Example:**
```bash
curl -X GET http://localhost:5000/api/costs/1
```

**Response:**
```json
{
  "event_id": 1,
  "cost_items": [
    {
      "id": 1,
      "event_id": 1,
      "description": "Materials for wedding decoration",
      "amount": 1500.00,
      "document_url": "https://drive.google.com/file/d/...",
      "document_type": "pdf",
      "uploaded_at": "2024-01-15T12:00:00Z"
    },
    {
      "id": 2,
      "event_id": 1,
      "description": "Labor costs",
      "amount": 800.00,
      "document_url": null,
      "document_type": null,
      "uploaded_at": "2024-01-15T13:00:00Z"
    }
  ],
  "total_cost": 2300.00
}
```

### 2. Add Event Cost Summary
**Endpoint:** `POST /api/costs/:event_id`

**Description:** Add a new cost summary for an event.

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/items \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 2,
    "description": "Birthday party decoration materials",
    "amount": 1000.00,
    "document_url": "https://example.com/birthday-invoice.pdf",
    "document_type": "pdf"
  }'
```

**Response:**
```json
{
  "id": 3,
  "event_id": 2,
  "description": "Birthday party decoration materials",
  "amount": 1000.00,
  "document_url": "https://example.com/birthday-invoice.pdf",
  "document_type": "pdf",
  "uploaded_at": "2024-01-17T16:30:00Z"
}
```

### 3. Update Event Cost Summary
**Endpoint:** `PUT /api/costs/:event_id`

**Description:** Update the cost summary for an event.

**Example:**
```bash
curl -X PUT http://localhost:5000/api/costs/items/1 \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Updated materials for wedding decoration",
    "amount": 1600.00,
    "document_url": "https://example.com/updated-invoice.pdf",
    "document_type": "pdf"
  }'
```

**Response:**
```json
{
  "id": 1,
  "event_id": 1,
  "description": "Updated materials for wedding decoration",
  "amount": 1600.00,
  "document_url": "https://example.com/updated-invoice.pdf",
  "document_type": "pdf",
  "uploaded_at": "2024-01-17T17:00:00Z"
}
```

### 4. Delete Event Cost Summary
**Endpoint:** `DELETE /api/costs/:event_id`

**Description:** Delete the cost summary for an event.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/costs/items/2
```

**Response:**
```json
{
  "message": "Cost item deleted successfully"
}
```

---

## 📋 Material Issuance APIs

### 1. Get All Issuances
**Endpoint:** `GET /api/issuance`

**Description:** Get all material issuances.

**Example:**
```bash
curl -X GET http://localhost:5000/api/issuance
```

**Response:**
```json
[
  {
    "id": 1,
    "event_id": 1,
    "item_id": 1,
    "quantity_issued": 50,
    "issued_at": "2024-01-15T13:00:00Z",
    "notes": "Flowers for centerpieces",
    "material_name": "Roses",
    "unit": "pieces",
    "category_name": "Flowers"
  },
  {
    "id": 2,
    "event_id": 1,
    "item_id": 2,
    "quantity_issued": 20,
    "issued_at": "2024-01-15T14:00:00Z",
    "notes": "Fabric for table covers",
    "material_name": "Fabric",
    "unit": "meters",
    "category_name": "Textiles"
  }
]
```

### 2. Create Material Issuance
**Endpoint:** `POST /api/issuance`

**Description:** Create a new material issuance.

**Example:**
```bash
curl -X POST http://localhost:5000/api/issuance \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 2,
    "item_id": 3,
    "quantity_issued": 100,
    "notes": "Candles for birthday party"
  }'
```

**Response:**
```json
{
  "id": 3,
  "event_id": 2,
  "item_id": 3,
  "quantity_issued": 100,
  "issued_at": "2024-01-17T17:30:00Z",
  "notes": "Candles for birthday party"
}
```

### 3. Get Issuances by Event
**Endpoint:** `GET /api/issuance/event/:event_id`

**Description:** Get all issuances for a specific event.

**Example:**
```bash
curl -X GET http://localhost:5000/api/issuance/event/1
```

**Response:**
```json
[
  {
    "id": 1,
    "event_id": 1,
    "material_id": 1,
    "material_name": "Roses",
    "quantity": 50,
    "issued_at": "2024-01-15T13:00:00Z",
    "notes": "Flowers for centerpieces"
  },
  {
    "id": 2,
    "event_id": 1,
    "material_id": 2,
    "material_name": "Fabric",
    "quantity": 20,
    "issued_at": "2024-01-15T14:00:00Z",
    "notes": "Fabric for table covers"
  }
]
```

---

## 💰 Cost Items Management APIs

### 1. Get Event Cost Items
**Endpoint:** `GET /api/costs/events/:event_id/items`

**Description:** Get all cost items for a specific event.

**Example:**
```bash
curl -X GET http://localhost:5000/api/costs/events/1/items
```

**Response:**
```json
{
  "event_id": 1,
  "cost_items": [
    {
      "id": 1,
      "event_id": 1,
      "description": "Materials for wedding decoration",
      "amount": 1500.00,
      "document_url": "https://drive.google.com/file/d/...",
      "document_type": "pdf",
      "uploaded_at": "2024-01-15T12:00:00Z"
    }
  ],
  "total_cost": 1500.00
}
```

### 2. Create Cost Item
**Endpoint:** `POST /api/costs/items`

**Description:** Create a new cost item for an event.

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/items \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "description": "Materials for wedding decoration",
    "amount": 1500.00,
    "document_url": "https://example.com/invoice.pdf",
    "document_type": "pdf"
  }'
```

**Response:**
```json
{
  "id": 1,
  "event_id": 1,
  "description": "Materials for wedding decoration",
  "amount": 1500.00,
  "document_url": "https://example.com/invoice.pdf",
  "document_type": "pdf",
  "uploaded_at": "2024-01-17T19:00:00Z"
}
```

### 3. Update Cost Item
**Endpoint:** `PUT /api/costs/items/:id`

**Description:** Update an existing cost item.

**Example:**
```bash
curl -X PUT http://localhost:5000/api/costs/items/1 \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Updated materials for wedding decoration",
    "amount": 1800.00,
    "document_url": "https://example.com/updated-invoice.pdf",
    "document_type": "pdf"
  }'
```

**Response:**
```json
{
  "id": 1,
  "event_id": 1,
  "description": "Updated materials for wedding decoration",
  "amount": 1800.00,
  "document_url": "https://example.com/updated-invoice.pdf",
  "document_type": "pdf",
  "uploaded_at": "2024-01-17T19:00:00Z"
}
```

### 4. Delete Cost Item
**Endpoint:** `DELETE /api/costs/items/:id`

**Description:** Delete a cost item.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/costs/items/1
```

**Response:**
```json
{
  "message": "Cost item deleted successfully"
}
```

---

## 📅 Year Management APIs

### 1. Get All Years
**Endpoint:** `GET /api/years`

**Description:** Get all years in the system.

**Example:**
```bash
curl -X GET http://localhost:5000/api/years
```

**Response:**
```json
[
  {
    "id": 1,
    "year_name": "2024",
    "created_at": "2024-01-01T00:00:00Z"
  },
  {
    "id": 2,
    "year_name": "2023",
    "created_at": "2023-01-01T00:00:00Z"
  }
]
```

### 2. Get Year by ID
**Endpoint:** `GET /api/years/:id`

**Description:** Get a specific year by ID.

**Example:**
```bash
curl -X GET http://localhost:5000/api/years/1
```

**Response:**
```json
{
  "id": 1,
  "year_name": "2024",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### 3. Create Year
**Endpoint:** `POST /api/years`

**Description:** Create a new year entry.

**Example:**
```bash
curl -X POST http://localhost:5000/api/years \
  -H "Content-Type: application/json" \
  -d '{
    "year_name": "2025"
  }'
```

**Response:**
```json
{
  "id": 3,
  "year_name": "2025",
  "created_at": "2024-01-17T18:00:00Z"
}
```

### 4. Update Year
**Endpoint:** `PUT /api/years/:id`

**Description:** Update an existing year.

**Example:**
```bash
curl -X PUT http://localhost:5000/api/years/1 \
  -H "Content-Type: application/json" \
  -d '{
    "year_name": "2024-Updated"
  }'
```

**Response:**
```json
{
  "id": 1,
  "year_name": "2024-Updated",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### 5. Delete Year
**Endpoint:** `DELETE /api/years/:id`

**Description:** Delete a year by ID.

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/years/2
```

**Response:**
```json
{
  "message": "Year deleted successfully"
}
```

---



---

## 📝 Notes

1. **Authentication**: Most endpoints require JWT authentication
2. **File Uploads**: Use `multipart/form-data` for file uploads
3. **Image URLs**: For URL-based uploads, the system will use the original URL directly
4. **Error Handling**: All endpoints return appropriate HTTP status codes and error messages
5. **CORS**: The API supports CORS for frontend integration

## 🚀 Getting Started

1. **Setup Database**: Run `npm run setup`
2. **Start Server**: Run `npm start`
3. **Test APIs**: Use the examples above with curl or any API client 