# Event Cost Items API Documentation

## Overview
The Event Cost Items API has been updated to support individual cost items with document attachments. Each event can now have multiple cost items, each with its own description, amount, and optional document.

## Database Schema
```sql
CREATE TABLE event_cost_items (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    description TEXT,
    amount NUMERIC(10, 2) NOT NULL,
    document_url TEXT,
    document_type document_type,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES events(id) ON DELETE CASCADE
);

CREATE TYPE document_type AS ENUM ('image', 'pdf');
```

## API Endpoints

### Base URL: `/api/costs`

### 1. Get All Cost Items for an Event
**GET** `/api/costs/eventCostItems/:event_id`

**Response:**
```json
{
  "event_id": 1,
  "cost_items": [
    {
      "id": 1,
      "event_id": 1,
      "description": "Flowers and decorations",
      "amount": "1500.00",
      "document_url": "https://example.com/flower-receipt.pdf",
      "document_type": "pdf",
      "uploaded_at": "2024-01-15T10:30:00Z"
    }
  ],
  "total_cost": "1500.00"
}
```

### 2. Create New Cost Item
**POST** `/api/costs/eventCostItems/create`

**Request Body:**
```json
{
  "event_id": 1,
  "description": "Catering services",
  "amount": 2500.00,
  "document_url": "https://example.com/catering-invoice.jpg",
  "document_type": "image"
}
```

**Response:**
```json
{
  "id": 2,
  "event_id": 1,
  "description": "Catering services",
  "amount": "2500.00",
  "document_url": "https://example.com/catering-invoice.jpg",
  "document_type": "image",
  "uploaded_at": "2024-01-15T11:00:00Z"
}
```

### 3. Update Cost Item
**PUT** `/api/costs/eventCostItems/:id`

**Request Body:**
```json
{
  "description": "Updated catering services",
  "amount": 2700.00,
  "document_url": "https://example.com/updated-catering-invoice.pdf",
  "document_type": "pdf"
}
```

**Response:**
```json
{
  "id": 2,
  "event_id": 1,
  "description": "Updated catering services",
  "amount": "2700.00",
  "document_url": "https://example.com/updated-catering-invoice.pdf",
  "document_type": "pdf",
  "uploaded_at": "2024-01-15T11:00:00Z"
}
```

### 4. Delete Cost Item
**DELETE** `/api/costs/eventCostItems/:id`

**Response:**
```json
{
  "message": "Cost item deleted successfully"
}
```

## Legacy Endpoints (Backward Compatibility)

### 5. Get Event Cost Summary
**GET** `/api/costs/:event_id`

**Response:**
```json
{
  "event_id": 1,
  "total_cost": "4200.00",
  "material_cost": "4200.00",
  "misc_cost": 0
}
```

### 6. Add/Update Event Cost Summary
**POST** `/api/costs/:event_id`

**Request Body:**
```json
{
  "material_cost": 3000.00,
  "misc_cost": 1200.00
}
```

### 7. Update Event Cost Summary
**PUT** `/api/costs/:event_id`

**Request Body:**
```json
{
  "material_cost": 3500.00,
  "misc_cost": 1500.00
}
```

### 8. Delete Event Cost Summary
**DELETE** `/api/costs/:event_id`

**Response:**
```json
{
  "message": "Event cost deleted successfully"
}
```

## Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `event_id` | Integer | Yes | ID of the event this cost item belongs to |
| `description` | Text | Yes | Description of the cost item |
| `amount` | Numeric(10,2) | Yes | Cost amount with 2 decimal places |
| `document_url` | Text | No | URL to the uploaded document |
| `document_type` | Enum | No | Type of document ('image' or 'pdf') |
| `uploaded_at` | Timestamp | Auto | When the cost item was created |

## Validation Rules

1. **event_id**: Must be a valid integer and reference an existing event
2. **description**: Required, cannot be empty
3. **amount**: Required, must be a positive number with max 2 decimal places
4. **document_type**: If provided, must be either 'image' or 'pdf'
5. **document_url**: If provided, should be a valid URL

## Error Responses

### 400 Bad Request
```json
{
  "message": "event_id, description, and amount are required"
}
```

### 404 Not Found
```json
{
  "message": "Cost item not found"
}
```

### 500 Internal Server Error
```json
{
  "message": "Internal server error"
}
```

## Usage Examples

### cURL Examples

**Get all cost items for event 1:**
```bash
curl http://localhost:5000/api/costs/eventCostItems/1
```

**Create new cost item:**
```bash
curl -X POST http://localhost:5000/api/costs/eventCostItems/create \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "description": "Venue rental",
    "amount": 3000.00,
    "document_url": "https://example.com/venue-contract.pdf",
    "document_type": "pdf"
  }'
```

**Update cost item:**
```bash
curl -X PUT http://localhost:5000/api/costs/eventCostItems/1 \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Updated venue rental",
    "amount": 3200.00
  }'
```

**Delete cost item:**
```bash
curl -X DELETE http://localhost:5000/api/costs/eventCostItems/1
```

## Database Setup

Run the `setup-cost-schema.sql` script in your PostgreSQL database to create the required tables and enum types.

## Notes

- The new system supports multiple cost items per event
- Each cost item can have an optional document attachment
- Document types are restricted to 'image' or 'pdf'
- Legacy endpoints maintain backward compatibility
- All amounts are stored with 2 decimal places precision
- Cost items are automatically ordered by upload date (newest first)
- **New simplified API URLs** for better usability
