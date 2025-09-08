# 🎨 DecorationApp API Endpoints Reference

## 📋 Table of Contents
- [Base URL](#base-url)
- [Authentication Endpoints](#-authentication-endpoints)
- [User Management Endpoints](#-user-management-endpoints)
- [Event Management Endpoints](#-event-management-endpoints)
- [Event Template Endpoints](#-event-template-endpoints)
- [Material & Category Management](#-material--category-management)
- [Tool Management](#-tool-management)
- [Gallery & Image Management](#-gallery--image-management)
- [Cost Management](#-cost-management)
- [Material & Tool Issuance](#-material--tool-issuance)
- [Year Management](#-year-management)
- [Quick Start Examples](#-quick-start-examples)
- [Notes](#-notes)
- [Security Notes](#-security-notes)

## 🌐 Base URL
```
http://localhost:5000
```

## 📊 API Response Format
All API responses follow this standard format:
```json
{
  "success": true/false,
  "message": "Human readable message",
  "data": {...},
  "count": 123
}
```

## 🔐 Error Response Format
```json
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
```

## 📋 Complete Endpoint Reference

| Method | Endpoint | Description | Content-Type |
|--------|----------|-------------|--------------|
| **Authentication** |
| POST | `/auth/google` | Get OAuth authorization URL | `application/json` |
| POST | `/auth/google/callback` | Handle OAuth callback | `application/json` |
| POST | `/auth/status` | Check authentication status | `application/json` |
| **User Management** |
| POST | `/api/users/create` | Create new user | `application/json` |
| POST | `/api/users/getAll` | Get all users | `application/json` |
| POST | `/api/users/login` | User login | `application/json` |
| POST | `/api/users/update` | Update user | `application/json` |
| POST | `/api/users/delete` | Delete user | `application/json` |
| **Event Management** |
| POST | `/api/events/getAll` | Get all events | `application/json` |
| POST | `/api/events/getById` | Get event by ID | `application/json` |
| POST | `/api/events/create` | Create event | `multipart/form-data` |
| POST | `/api/events/update` | Update event | `multipart/form-data` |
| POST | `/api/events/delete` | Delete event | `application/json` |
| POST | `/api/events/getDetails` | Get complete event details | `application/json` |
| **Event Templates** |
| POST | `/api/event-templates/getAll` | Get all templates | `application/json` |
| POST | `/api/event-templates/getById` | Get template by ID | `application/json` |
| POST | `/api/event-templates/create` | Create template | `application/json` |
| POST | `/api/event-templates/update` | Update template | `application/json` |
| POST | `/api/event-templates/delete` | Delete template | `application/json` |
| **Materials & Categories** |
| POST | `/api/materials/categories/getAll` | Get all categories | `application/json` |
| POST | `/api/materials/categories` | Create category | `application/json` |
| POST | `/api/materials/categories/update` | Update category | `application/json` |
| POST | `/api/materials/categories/delete` | Delete category | `application/json` |
| POST | `/api/materials/getAll` | Get all materials | `application/json` |
| POST | `/api/materials/getById` | Get material by ID | `application/json` |
| POST | `/api/materials/create` | Create material | `application/json` |
| POST | `/api/materials/update` | Update material | `application/json` |
| POST | `/api/materials/delete` | Delete material | `application/json` |
| POST | `/api/materials/inventory/getAll` | Get all inventory | `application/json` |
| POST | `/api/materials/inventory/update` | Update inventory | `application/json` |
| POST | `/api/materials/inventory/adjust` | Adjust inventory | `application/json` |
| POST | `/api/materials/inventory/low-stock` | Get low stock items | `application/json` |
| **Specialized Inventory** |
| POST | `/api/materials/furniture/getByItem` | Get furniture details | `application/json` |
| POST | `/api/materials/furniture` | Create furniture | `application/json` |
| POST | `/api/materials/furniture/update` | Update furniture | `application/json` |
| POST | `/api/materials/furniture/delete` | Delete furniture | `application/json` |
| POST | `/api/materials/fabric/getByItem` | Get fabric details | `application/json` |
| POST | `/api/materials/fabric` | Create fabric | `application/json` |
| POST | `/api/materials/fabric/update` | Update fabric | `application/json` |
| POST | `/api/materials/fabric/delete` | Delete fabric | `application/json` |
| POST | `/api/materials/frame-structures/getByItem` | Get frame structure details | `application/json` |
| POST | `/api/materials/frame-structures` | Create frame structure | `application/json` |
| POST | `/api/materials/frame-structures/update` | Update frame structure | `application/json` |
| POST | `/api/materials/frame-structures/delete` | Delete frame structure | `application/json` |
| POST | `/api/materials/carpets/getByItem` | Get carpet details | `application/json` |
| POST | `/api/materials/carpets` | Create carpet | `application/json` |
| POST | `/api/materials/carpets/update` | Update carpet | `application/json` |
| POST | `/api/materials/carpets/delete` | Delete carpet | `application/json` |
| POST | `/api/materials/thermocol/getByItem` | Get thermocol material details | `application/json` |
| POST | `/api/materials/thermocol` | Create thermocol material | `application/json` |
| POST | `/api/materials/thermocol/update` | Update thermocol material | `application/json` |
| POST | `/api/materials/thermocol/delete` | Delete thermocol material | `application/json` |
| POST | `/api/materials/stationery/getByItem` | Get stationery details | `application/json` |
| POST | `/api/materials/stationery` | Create stationery | `application/json` |
| POST | `/api/materials/stationery/update` | Update stationery | `application/json` |
| POST | `/api/materials/stationery/delete` | Delete stationery | `application/json` |
| POST | `/api/materials/murti-sets/getByItem` | Get murti set details | `application/json` |
| POST | `/api/materials/murti-sets` | Create murti set | `application/json` |
| POST | `/api/materials/murti-sets/update` | Update murti set | `application/json` |
| POST | `/api/materials/murti-sets/delete` | Delete murti set | `application/json` |
| **Tools** |
| POST | `/api/tools/getAll` | Get all tools | `application/json` |
| POST | `/api/tools/create` | Create tool | `application/json` |
| POST | `/api/tools/update` | Update tool | `application/json` |
| POST | `/api/tools/delete` | Delete tool | `application/json` |
| POST | `/api/tools/inventory/getAll` | Get all tool inventory | `application/json` |
| POST | `/api/tools/inventory` | Create tool inventory | `application/json` |
| POST | `/api/tools/inventory/update` | Update tool inventory | `application/json` |
| POST | `/api/tools/inventory/adjust` | Adjust tool quantity | `application/json` |
| **Gallery** |
| POST | `/api/gallery/design` | Upload design image | `multipart/form-data` |
| POST | `/api/gallery/final` | Upload final image | `multipart/form-data` |
| POST | `/api/gallery/getEventImages` | Get event images | `application/json` |


| **Costs** |
| POST | `/api/costs/eventCostItems/getByEvent` | Get event cost items | `application/json` |
| POST | `/api/costs/eventCostItems/create` | Create cost item (URL) | `application/json` |
| POST | `/api/costs/eventCostItems/createWithFile` | Create cost item (File) | `multipart/form-data` |
| POST | `/api/costs/eventCostItems/update` | Update cost item (URL) | `application/json` |
| POST | `/api/costs/eventCostItems/updateWithFile` | Update cost item (File) | `multipart/form-data` |
| POST | `/api/costs/eventCostItems/delete` | Delete cost item | `application/json` |
| **Issuance** |
| POST | `/api/issuance/materials` | Create material issuance | `application/json` |
| POST | `/api/issuance/materials/getAll` | Get all material issuances | `application/json` |
| POST | `/api/issuance/materials/event/getByEvent` | Get issuances by event | `application/json` |
| POST | `/api/issuance/tools` | Create tool issuance | `application/json` |
| POST | `/api/issuance/tools/getAll` | Get all tool issuances | `application/json` |
| POST | `/api/issuance/tools/event/getByEvent` | Get tool issuances by event | `application/json` |
| **Years** |
| POST | `/api/years/getAll` | Get all years | `application/json` |
| POST | `/api/years/getById` | Get year by ID | `application/json` |
| POST | `/api/years/create` | Create year | `application/json` |
| POST | `/api/years/update` | Update year | `application/json` |
| POST | `/api/years/delete` | Delete year | `application/json` |

---

## 📝 Common Request/Response Patterns

### 🔍 Get All Records Pattern
```bash
# Request
curl -X POST http://localhost:5000/api/{resource}/getAll \
  -H "Content-Type: application/json"

# Response
{
  "success": true,
  "message": "Records retrieved successfully",
  "data": [...],
  "count": 10
}
```

### 🔍 Get By ID Pattern
```bash
# Request
curl -X POST http://localhost:5000/api/{resource}/getById \
  -H "Content-Type: application/json" \
  -d '{"id": 1}'

# Response
{
  "success": true,
  "message": "Record retrieved successfully",
  "data": {...}
}
```

### ➕ Create Record Pattern
```bash
# Request
curl -X POST http://localhost:5000/api/{resource}/create \
  -H "Content-Type: application/json" \
  -d '{
    "field1": "value1",
    "field2": "value2"
  }'

# Response
{
  "success": true,
  "message": "Record created successfully",
  "data": {...}
}
```

### ✏️ Update Record Pattern
```bash
# Request
curl -X POST http://localhost:5000/api/{resource}/update \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "field1": "new_value1",
    "field2": "new_value2"
  }'

# Response
{
  "success": true,
  "message": "Record updated successfully",
  "data": {...}
}
```

### 🗑️ Delete Record Pattern
```bash
# Request
curl -X POST http://localhost:5000/api/{resource}/delete \
  -H "Content-Type: application/json" \
  -d '{"id": 1}'

# Response
{
  "success": true,
  "message": "Record deleted successfully",
  "data": {"deletedId": 1}
}
```

### 📁 File Upload Pattern
```bash
# Request
curl -X POST http://localhost:5000/api/{resource}/upload \
  -F "file=@/path/to/file.jpg" \
  -F "field1=value1" \
  -F "field2=value2"

# Response
{
  "success": true,
  "message": "File uploaded successfully",
  "data": {
    "file_url": "/uploads/filename.jpg",
    "other_fields": "..."
  }
}
```

## 🔢 HTTP Status Codes

| Code | Description | Usage |
|------|-------------|-------|
| **200** | OK | Successful GET, PUT, DELETE operations |
| **201** | Created | Successful POST operations (new resource created) |
| **400** | Bad Request | Invalid input data, validation errors |
| **401** | Unauthorized | Authentication required or failed |
| **404** | Not Found | Resource not found |
| **409** | Conflict | Duplicate data, constraint violation |
| **500** | Internal Server Error | Server-side errors |

## ⚠️ Common Error Scenarios

### Validation Error (400)
```json
{
  "success": false,
  "message": "Validation error",
  "details": [
    {
      "field": "username",
      "message": "Username must be between 3 and 30 characters"
    },
    {
      "field": "email",
      "message": "Email format is invalid"
    }
  ]
}
```

### Not Found Error (404)
```json
{
  "success": false,
  "message": "Resource not found",
  "details": [
    {
      "field": "id",
      "message": "User with ID 999 does not exist"
    }
  ]
}
```

### Duplicate Error (409)
```json
{
  "success": false,
  "message": "Duplicate resource",
  "details": [
    {
      "field": "username",
      "message": "Username already exists"
    }
  ]
}
```

### Authentication Error (401)
```json
{
  "success": false,
  "message": "Authentication failed",
  "details": [
    {
      "field": "credentials",
      "message": "Invalid username or password"
    }
  ]
}
```

## 📊 Data Models & Field Descriptions

### 👤 User Model
```json
{
  "id": "integer (auto-increment)",
  "username": "string (3-30 chars, alphanumeric)",
  "password": "string (required, hashed)",
  "role": "string (admin, viewer, moderator)",
  "created_at": "datetime (auto-generated)"
}
```

### 🎉 Event Model
```json
{
  "id": "integer (auto-increment)",
  "template_id": "integer (foreign key)",
  "year_id": "integer (foreign key)",
  "date": "date (YYYY-MM-DD)",
  "location": "string",
  "description": "text",
  "cover_image": "string (URL path to local file: /uploads/events/event_id/cover_image_event_id)",
  "created_at": "datetime (auto-generated)"
}
```

### 📋 Event Template Model
```json
{
  "id": "integer (auto-increment)",
  "name": "string (unique)",
  "created_at": "datetime (auto-generated)"
}
```

### 🧱 Material Model
```json
{
  "id": "integer (auto-increment)",
  "name": "string",
  "category_id": "integer (foreign key)",
  "unit": "string (pieces, kg, meters, etc.)",
  "storage_location": "string (optional)",
  "notes": "text (optional)",
  "quantity_available": "integer (auto-calculated)"
}
```

### 🏷️ Category Model
```json
{
  "id": "integer (auto-increment)",
  "name": "string (unique)"
}
```

### 🔧 Tool Model
```json
{
  "id": "integer (auto-increment)",
  "name": "string",
  "notes": "text (optional)"
}
```

### 💰 Cost Item Model
```json
{
  "id": "integer (auto-increment)",
  "event_id": "integer (foreign key)",
  "description": "string",
  "amount": "decimal (10,2)",
  "document_url": "string (optional)",
  "document_type": "string (image, pdf, optional)",
  "uploaded_at": "datetime (auto-generated)"
}
```

### 📦 Issuance Model
```json
{
  "id": "integer (auto-increment)",
  "event_id": "integer (foreign key)",
  "item_id": "integer (foreign key)",
  "quantity_issued": "integer",
  "notes": "text (optional)",
  "issued_at": "datetime (auto-generated)"
}
```

### 📅 Year Model
```json
{
  "id": "integer (auto-increment)",
  "year_name": "string (unique)",
  "created_at": "datetime (auto-generated)"
}
```

## 🔍 Field Validation Rules

| Field | Type | Rules | Example |
|-------|------|-------|---------|
| `username` | string | 3-30 chars, alphanumeric only | `"john_doe"` |
| `password` | string | Required, no format restrictions | `"mypassword123"` |
| `email` | string | Valid email format | `"user@example.com"` |
| `role` | string | One of: admin, viewer, moderator | `"viewer"` |
| `date` | date | YYYY-MM-DD format | `"2024-12-25"` |
| `amount` | decimal | Positive number, 2 decimal places | `1500.00` |
| `quantity` | integer | Positive number | `100` |
| `id` | integer | Positive number | `1` |

---

## 🔐 Authentication Endpoints



---

## 👥 User Management Endpoints

### 1. Create User
```http
POST /api/users/create
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/users/create \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "mypassword",
    "role": "viewer"
  }'
```

**Success Response:**
```json
{
  "success": true,
  "message": "User created successfully",
  "data": {
    "id": 3,
    "username": "john_doe",
    "role": "viewer",
    "created_at": "2024-01-17T14:30:00Z"
  }
}
```

**Validation Error Response (400):**
```json
{
  "success": false,
  "message": "Validation error",
  "details": [
    {
      "field": "username",
      "message": "Username must be between 3 and 30 characters"
    }
  ]
}
```

**Duplicate Error Response (409):**
```json
{
  "success": false,
  "message": "Username already exists",
  "details": [
    {
      "field": "username",
      "message": "Username already exists"
    }
  ]
}
```

**Validation Rules:**
- **Username**: 3-30 characters, alphanumeric only
- **Password**: Required (no format restrictions)
- **Role**: One of: admin, viewer (defaults to "viewer")

### 2. Get All Users
```http
POST /api/users/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/users/getAll \
  -H "Content-Type: application/json"
```

**Success Response:**
```json
{
  "success": true,
  "message": "Users retrieved successfully",
  "data": [
    {
      "id": 1,
      "username": "admin",
      "role": "admin",
      "created_at": "2024-01-15T10:30:00Z"
    },
    {
      "id": 3,
      "username": "john_doe",
      "role": "viewer",
      "created_at": "2024-01-17T14:30:00Z"
    }
  ],
  "count": 2
}
```

### 3. User Login
```http
POST /api/users/login
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john_doe",
    "password": "mypassword"
  }'
```

**Success Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 3,
      "username": "john_doe",
      "role": "viewer",
      "created_at": "2024-01-17T14:30:00Z"
    },
    "loginTime": "2024-01-17T15:30:00.000Z"
  }
}
```

**Missing Fields Error (400):**
```json
{
  "success": false,
  "message": "Validation error",
  "details": [
    {
      "field": "username",
      "message": "Username is required"
    },
    {
      "field": "password",
      "message": "Password is required"
    }
  ]
}
```

**Validation Error (400):**
```json
{
  "success": false,
  "message": "Validation error",
  "details": [
    {
      "field": "username",
      "message": "Username must be between 3 and 30 characters"
    }
  ]
}
```

**Invalid Credentials Error (401):**
```json
{
  "success": false,
  "message": "Invalid credentials",
  "details": [
    {
      "field": "login",
      "message": "Invalid username or password"
    }
  ]
}
```

### 4. Update User
```http
POST /api/users/update
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/users/update \
  -H "Content-Type: application/json" \
  -d '{
    "id": 3,
    "username": "john_smith",
    "role": "admin"
  }'
```

**Success Response:**
```json
{
  "success": true,
  "message": "User updated successfully",
  "data": {
    "id": 3,
    "username": "john_smith",
    "role": "admin",
    "created_at": "2024-01-17T14:30:00Z"
  }
}
```

**Update Password Example:**
```bash
curl -X POST http://localhost:5000/api/users/update \
  -H "Content-Type: application/json" \
  -d '{
    "id": 3,
    "password": "newpassword"
  }'
```

**Validation Error Response (400):**
```json
{
  "success": false,
  "message": "Validation error",
  "details": [
    {
      "field": "update",
      "message": "At least one field must be provided for update"
    }
  ]
}
```

**Duplicate Error Response (409):**
```json
{
  "success": false,
  "message": "Username already exists",
  "details": [
    {
      "field": "username",
      "message": "Username already exists"
    }
  ]
}
```

**User Not Found Error (404):**
```json
{
  "success": false,
  "message": "User not found",
  "details": [
    {
      "field": "id",
      "message": "User with ID 999 does not exist"
    }
  ]
}
```

**Note:** You can update any combination of fields (username, password, role). Only provided fields will be updated. Password has no format restrictions.

### 5. Delete User
```http
POST /api/users/delete
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/users/delete \
  -H "Content-Type: application/json" \
  -d '{
    "id": 2
  }'
```

**Success Response:**
```json
{
  "success": true,
  "message": "User deleted successfully",
  "data": {
    "deletedUserId": 2,
    "deletedUsername": "jane_doe"
  }
}
```

**Invalid ID Error (400):**
```json
{
  "success": false,
  "message": "Invalid user ID",
  "details": [
    {
      "field": "id",
      "message": "User ID must be a positive integer"
    }
  ]
}
```

**User Not Found Error (404):**
```json
{
  "success": false,
  "message": "User not found",
  "details": [
    {
      "field": "id",
      "message": "User with ID 999 does not exist"
    }
  ]
}
```

## 🧪 User API Test Cases Coverage

### ✅ All Test Cases Solved

**Input Validation:**
- ✅ Required field validation (username, password, email for creation; username, password for login)
- ✅ Field format validation (email format, alphanumeric username)
- ✅ Field length validation (username 3-30 chars)
- ✅ Password validation (required only, no format restrictions)
- ✅ Role validation (admin, user, moderator only)
- ✅ ID parameter validation (positive integers only)

**Business Logic:**
- ✅ Duplicate username prevention
- ✅ Duplicate email prevention
- ✅ Password hashing with bcrypt
- ✅ Password verification for login
- ✅ Secure responses (no password hash exposure)
- ✅ User existence checks before operations
- ✅ Login authentication with credential validation

**Error Handling:**
- ✅ Comprehensive error messages with field-specific details
- ✅ Proper HTTP status codes (400, 401, 404, 409, 500)
- ✅ Database error handling (unique constraint violations)
- ✅ Graceful handling of invalid credentials and missing users
- ✅ Authentication error handling (401 for invalid login)

**Edge Cases:**
- ✅ Empty request body handling
- ✅ Malformed JSON handling
- ✅ SQL injection prevention (parameterized queries)
- ✅ Case-sensitive duplicate checking
- ✅ Partial updates (only provided fields updated)
- ✅ Default role assignment

**Security:**
- ✅ Password hashing (never store plain text)
- ✅ Password hash exclusion from responses
- ✅ Input sanitization and validation
- ✅ SQL injection protection

---

## 🎉 Event Management Endpoints

### 1. Get All Events
```http
POST /api/events/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/events/getAll \
  -H "Content-Type: application/json"
```

**Success Response:**
```json
{
  "success": true,
  "message": "Events retrieved successfully",
  "data": [
    {
      "id": 1,
      "template_id": 1,
      "year_id": 2024,
      "date": "2024-02-15",
      "location": "Grand Hotel",
      "description": "Wedding decoration",
             "cover_image": "/uploads/events/1/cover_image_1.jpg",
      "created_at": "2024-01-15T10:30:00Z"
    }
  ],
  "count": 1
}
```

### 2. Get Event by ID
```http
POST /api/events/getById
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/events/getById \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1
  }'
```

**Success Response:**
```json
{
  "success": true,
  "message": "Event retrieved successfully",
  "data": {
    "id": 1,
    "template_id": 1,
    "year_id": 2024,
    "date": "2024-02-15",
    "location": "Grand Hotel",
    "description": "Wedding decoration",
    "cover_image": "https://drive.google.com/file/d/cover_image_1.jpg/view",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

**Missing ID Error (400):**
```json
{
  "success": false,
  "message": "Event ID is required",
  "details": [
    {
      "field": "id",
      "message": "Event ID is required in request body"
    }
  ]
}
```

**Event Not Found Error (404):**
```json
{
  "success": false,
  "message": "Event not found",
  "details": [
    {
      "field": "id",
      "message": "Event with ID 999 does not exist"
    }
  ]
}
```

### 3. Create Event (with File Upload)
```http
POST /api/events/create
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/events/create \
  -F "cover_image=@/path/to/cover.jpg" \
  -F "template_id=1" \
  -F "year_id=2024" \
  -F "date=2024-04-10" \
  -F "location=Beach Resort" \
  -F "description=Beach wedding decoration"
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
  "cover_image": "/uploads/events/3/cover_image_3.jpg",
  "created_at": "2024-01-17T09:15:00Z"
}
```

**Note:** Cover images are now stored locally on the server in organized folders: `/uploads/events/event_id/cover_image_event_id`. This structure makes it easy to manage event-specific files and clean up when events are deleted.

### 4. Create Event (with Image URL)
```http
POST /api/events/create
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/events/create \
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

### 5. Update Event (with File Upload)
```http
POST /api/events/update
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/events/update \
  -F "id=1" \
  -F "cover_image=@/path/to/new-cover.jpg" \
  -F "template_id=2" \
  -F "year_id=2024" \
  -F "date=2024-02-20" \
  -F "location=Updated Grand Hotel" \
  -F "description=Updated wedding decoration"
```

**Note:** When updating with a new cover image, the old local image file will be automatically deleted from the server.

### 6. Update Event (with Image URL)
```http
POST /api/events/update
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/events/update \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "template_id": 2,
    "year_id": 2024,
    "date": "2024-02-20",
    "location": "Updated Grand Hotel",
    "description": "Updated wedding decoration",
    "cover_image": "https://example.com/new-cover.jpg"
  }'
```

### 7. Delete Event
```http
POST /api/events/delete
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/events/delete \
  -H "Content-Type: application/json" \
  -d '{
    "id": 2
  }'
```

**Success Response:**
```json
{
  "success": true,
  "message": "Event deleted successfully",
  "data": {
    "deletedEventId": 2
  }
}
```

**Missing ID Error (400):**
```json
{
  "success": false,
  "message": "Event ID is required",
  "details": [
    {
      "field": "id",
      "message": "Event ID is required in request body"
    }
  ]
}
```

### 8. Get Complete Event Details
```http
POST /api/events/getDetails
Content-Type: application/json
```

**Description:** Get comprehensive event details including gallery, costs, and issuances. Can be queried by event ID or by template_id and year_id.

**Option 1 - By Event ID:**
```bash
curl -X POST http://localhost:5000/api/events/getDetails \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1
  }'
```

**Option 2 - By Template ID and Year ID:**
```bash
curl -X POST http://localhost:5000/api/events/getDetails \
  -H "Content-Type: application/json" \
  -d '{
    "template_id": 1,
    "year_id": 2024
  }'
```

**Response:**
```json
{
  "success": true,
  "message": "Event details retrieved successfully",
  "data": {
    "event": {
      "id": 1,
      "template_id": 1,
      "year_id": 2024,
      "date": "2024-02-15",
      "location": "Grand Hotel",
      "description": "Wedding decoration",
      "cover_image": "https://drive.google.com/file/d/cover_image_1.jpg/view"
    },
    "gallery": {
      "design": [...],
      "final": [...]
    },
    "cost": {
      "id": 1,
      "event_id": 1,
      "total_cost": 2500.00,
      "materials_cost": 1500.00,
      "labor_cost": 800.00,
      "other_costs": 200.00
    },
    "issuances": [...]
  }
}
```

**Error Responses:**

**Missing Parameters (400):**
```json
{
  "success": false,
  "message": "Event identifier is required",
  "details": [
    {
      "field": "id or template_id, year_id",
      "message": "Either event ID or template_id and year_id are required in request body"
    }
  ]
}
```

**Event Not Found (404):**
```json
{
  "success": false,
  "message": "Event not found",
  "details": [
    {
      "field": "template_id, year_id",
      "message": "Event with template_id 1 and year_id 2024 does not exist"
    }
  ]
}
```

---

## 📋 Event Template Endpoints

### 1. Get All Templates
```http
POST /api/event-templates/getAll
Content-Type: application/json
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Wedding Template",
    "created_at": "2024-01-01T00:00:00.000Z"
  },
  {
    "id": 2,
    "name": "Corporate Event Template",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
]
```

### 2. Get Template by ID
```http
POST /api/event-templates/getById
Content-Type: application/json
```

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "id": 1,
  "name": "Wedding Template",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

**Error Response (404):**
```json
{
  "message": "Event template not found"
}
```

### 3. Create Template
```http
POST /api/event-templates/create
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Birthday Party Template"
}
```

**Validation Rules:**
- `name`: Required, must be unique (case-insensitive)

**Success Response (201):**
```json
{
  "id": 3,
  "name": "Birthday Party Template",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

**Error Response (400):**
```json
{
  "message": "Template name is required"
}
```

**Error Response (400) - Duplicate:**
```json
{
  "message": "Template name already exists"
}
```

### 4. Update Template
```http
POST /api/event-templates/update
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Updated Wedding Template"
}
```

**Success Response:**
```json
{
  "id": 1,
  "name": "Updated Wedding Template",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

**Error Response (404):**
```json
{
  "message": "Event template not found"
}
```

### 5. Delete Template
```http
POST /api/event-templates/delete
Content-Type: application/json
```

**Request Body:**
```json
{
  "id": 1
}
```

**Success Response:**
```json
{
  "message": "Event template deleted successfully"
}
```

**Error Response (404):**
```json
{
  "message": "Event template not found"
}
```

---

## 🧱 Material & Category Management Endpoints

### 1. Get All Categories
```http
POST /api/materials/categories/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/categories/getAll \
  -H "Content-Type: application/json"
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Furniture"
  },
  {
    "id": 2,
    "name": "Fabric"
  },
  {
    "id": 3,
    "name": "Lighting"
  }
]
```

### 2. Create Category
```http
POST /api/materials/categories
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Stationery"
  }'
```

### 3. Get All Materials (Inventory Items)
```http
POST /api/materials/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/getAll \
  -H "Content-Type: application/json"
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Candles",
    "category_id": 3,
    "category_name": "Lighting",
    "unit": "pieces",
    "storage_location": "Warehouse A",
    "notes": "Decorative candles",
    "quantity_available": 150
  }
]
```

### 4. Get Material by ID
```http
POST /api/materials/getById
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/getById \
  -H "Content-Type: application/json" \
  -d '{"id": 1}'
```

### 5. Create Material (Inventory Item)
```http
POST /api/materials/create
Content-Type: application/json
```

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

**Required Fields:**
- `name`: Material name
- `category_id`: ID from categories table
- `unit`: Unit of measurement (pieces, kg, meters, etc.)

**Optional Fields:**
- `storage_location`: Where the material is stored
- `notes`: Additional information

### 6. Update Material
```http
POST /api/materials/update
Content-Type: application/json
```

**Example:**
```bash
curl -X PUT http://localhost:5000/api/materials/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Premium Candles",
    "category_id": 3,
    "unit": "pieces",
    "storage_location": "Warehouse B",
    "notes": "Premium quality decorative candles"
  }'
```

### 7. Delete Material
```http
POST /api/materials/delete
Content-Type: application/json
```

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/materials/2
```

---

## 📦 Inventory Management Endpoints

### 1. Get All Inventory Stock
```http
POST /api/materials/inventory/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/inventory/getAll \
  -H "Content-Type: application/json"
```

**Response:**
```json
[
  {
    "id": 1,
    "item_id": 1,
    "quantity_available": 150,
    "item_name": "Candles",
    "unit": "pieces",
    "category_name": "Lighting"
  }
]
```

### 2. Get Inventory by Item ID
```http
POST /api/materials/inventory/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/inventory/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 1}'
```

### 3. Update Stock Quantity
```http
POST /api/materials/inventory/update
Content-Type: application/json
```

**Example:**
```bash
curl -X PUT http://localhost:5000/api/materials/inventory \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "quantity": 150
  }'
```

### 4. Adjust Stock Quantity (Add/Subtract)
```http
POST /api/materials/inventory/adjust
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/inventory/adjust \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "quantity_change": 50
  }'
```

### 5. Get Low Stock Items
```http
POST /api/materials/inventory/low-stock
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/inventory/low-stock \
  -H "Content-Type: application/json" \
  -d '{"threshold": 10}'
```

### 6. Deduct Material Stock
```http
POST /api/materials/inventory/deduct
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/inventory/deduct \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "qty": 10
  }'
```

---

## 🪑 Specialized Inventory Management Endpoints

### 1. Furniture Management

#### Get Furniture Details
```http
POST /api/materials/furniture/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/furniture/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 1}'
```

**Response:**
```json
{
  "item_id": 1,
  "material": "Wood",
  "dimensions": "120x60x75cm",
  "name": "Dining Chair",
  "category_name": "Furniture"
}
```

#### Create Furniture
```http
POST /api/materials/furniture
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/furniture \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "material": "Wood",
    "dimensions": "120x60x75cm"
  }'
```

**Request Body:**
- `item_id` (required): The inventory item ID
- `material` (required): Material type
- `dimensions` (required): Dimensions of the furniture

**Response:**
```json
{
  "item_id": 1,
  "material": "Wood",
  "dimensions": "120x60x75cm"
}
```

#### Update Furniture
```http
POST /api/materials/furniture/update
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/furniture/update \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "material": "Premium Wood",
    "dimensions": "125x65x80cm"
  }'
```

**Request Body:**
- `item_id` (required): The inventory item ID
- `material` (optional): Material type
- `dimensions` (optional): Dimensions of the furniture

**Response:**
```json
{
  "item_id": 1,
  "material": "Premium Wood",
  "dimensions": "125x65x80cm"
}
```

#### Delete Furniture
```http
POST /api/materials/furniture/delete
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/furniture/delete \
  -H "Content-Type: application/json" \
  -d '{"item_id": 1}'
```

### 2. Fabric Management

#### Get Fabric Details
```http
POST /api/materials/fabric/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/fabric/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 2}'
```

**Response:**
```json
{
  "item_id": 2,
  "fabric_type": "Silk",
  "pattern": "Floral",
  "width": 150,
  "length": 200,
  "color": "Red",
  "name": "Silk Fabric",
  "category_name": "Fabric"
}
```

#### Create Fabric
```http
POST /api/materials/fabric
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/fabric \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 2,
    "fabric_type": "Silk",
    "pattern": "Floral",
    "width": 150,
    "length": 200,
    "color": "Red"
  }'
```

**Request Body:**
- `item_id` (required): The inventory item ID
- `fabric_type` (required): Type of fabric
- `pattern` (required): Pattern design
- `width` (required): Width in cm
- `length` (required): Length in cm
- `color` (required): Color of the fabric

**Response:**
```json
{
  "item_id": 2,
  "fabric_type": "Silk",
  "pattern": "Floral",
  "width": 150,
  "length": 200,
  "color": "Red"
}
```

### 3. Frame Structures Management

#### Get Frame Structure Details
```http
POST /api/materials/frame-structures/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/frame-structures/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 3}'
```

**Response:**
```json
{
  "item_id": 3,
  "frame_type": "Metal",
  "material": "Steel",
  "dimensions": "100x50x30cm",
  
  "name": "Metal Frame",
  "category_name": "Frame Structures"
}
```

#### Create Frame Structure
```http
POST /api/materials/frame-structures
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/frame-structures \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 3,
    "frame_type": "Metal",
    "material": "Steel",
    "dimensions": "100x50x30cm"
  }'
```

**Request Body:**
- `item_id` (required): The inventory item ID
- `frame_type` (required): Type of frame
- `material` (required): Material used
- `dimensions` (required): Dimensions of the frame

**Response:**
```json
{
  "item_id": 3,
  "frame_type": "Metal",
  "material": "Steel",
  "dimensions": "100x50x30cm"
}
```
```

### 4. Carpets Management

#### Get Carpet Details
```http
POST /api/materials/carpets/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/carpets/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 4}'
```

**Response:**
```json
{
  "item_id": 4,
  "carpet_type": "Persian",
  "material": "Wool",
  "size": "3x4m",
  
  "name": "Persian Carpet",
  "category_name": "Carpets"
}
```

#### Create Carpet
```http
POST /api/materials/carpets
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/carpets \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 4,
    "carpet_type": "Persian",
    "material": "Wool",
    "size": "2x3m"
  }'
```

**Request Body:**
- `item_id` (required): The inventory item ID
- `carpet_type` (required): Type of carpet
- `material` (required): Material used
- `size` (required): Size of the carpet

**Response:**
```json
{
  "item_id": 4,
  "carpet_type": "Persian",
  "material": "Wool",
  "size": "2x3m"
}
```
```

### 5. Thermocol Materials Management

#### Get Thermocol Material Details
```http
POST /api/materials/thermocol/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/thermocol/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 5}'
```

**Response:**
```json
{
  "item_id": 5,
  "thermocol_type": "High Density",
  "dimensions": "50x50x5cm",
  "density": "25kg/m³",
  
  "name": "High Density Thermocol",
  "category_name": "Thermocol Materials"
}
```

#### Create Thermocol Material
```http
POST /api/materials/thermocol
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/thermocol \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 5,
    "thermocol_type": "High Density",
    "dimensions": "40x40x4cm",
    "density": "20kg/m³"
  }'
```

**Request Body:**
- `item_id` (required): The inventory item ID
- `thermocol_type` (required): Type of thermocol
- `dimensions` (required): Dimensions of the material
- `density` (required): Density of the material

**Response:**
```json
{
  "item_id": 5,
  "thermocol_type": "High Density",
  "dimensions": "40x40x4cm",
  "density": "20kg/m³"
}
```
```

### 6. Stationery Management

#### Get Stationery Details
```http
POST /api/materials/stationery/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/stationery/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 6}'
```

**Response:**
```json
{
  "item_id": 6,
  "specifications": "A4 size, 80gsm, white",
  
  "name": "A4 Paper",
  "category_name": "Stationery"
}
```

#### Create Stationery
```http
POST /api/materials/stationery
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/stationery \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 6,
    "specifications": "A4 size, 80gsm, white"
  }'
```

**Request Body:**
- `item_id` (required): The inventory item ID
- `specifications` (required): Specifications of the stationery

**Response:**
```json
{
  "item_id": 6,
  "specifications": "A4 size, 80gsm, white"
}
```
```

### 7. Murti Sets Management

#### Get Murti Set Details
```http
POST /api/materials/murti-sets/getByItem
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/murti-sets/getByItem \
  -H "Content-Type: application/json" \
  -d '{"item_id": 7}'
```

**Response:**
```json
{
  "item_id": 7,
  "set_number": "MS001",
  "material": "Clay",
  "dimensions": "30x20x15cm",
  "name": "Ganesh Murti Set",
  "category_name": "Murti Sets"
}
```

#### Create Murti Set
```http
POST /api/materials/murti-sets
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/materials/murti-sets \
  -F "item_id=7" \
  -F "set_number=MS001" \
  -F "material=Clay" \
  -F "dimensions=30x20x15cm" \
  -F "image=@/path/to/murti_set_image.jpg"
```

**Form Data:**
- `item_id` (required): The inventory item ID
- `set_number` (required): Set number/identifier
- `material` (required): Material used
- `dimensions` (required): Dimensions of the set
- `image` (optional): Image file (JPG, PNG, etc.)

**Response:**
```json
{
  "item_id": 7,
  "set_number": "MS001",
  "material": "Clay",
  "dimensions": "30x20x15cm",
  }
```



---

## 🔧 Tool Management Endpoints

### 1. Get All Tools
```http
POST /api/tools/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/tools/getAll \
  -H "Content-Type: application/json"
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Wire Cutters",
    "notes": "Professional wire cutters for floral arrangements"
  }
]
```

### 2. Create Tool
```http
POST /api/tools/create
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/tools \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Wire Cutters",
    "notes": "Professional wire cutters for floral arrangements"
  }'
```

### 3. Update Tool
```http
POST /api/tools/update
Content-Type: application/json
```

**Example:**
```bash
curl -X PUT http://localhost:5000/api/tools/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Professional Wire Cutters",
    "notes": "Professional grade wire cutters for cutting fabric"
  }'
```

### 4. Delete Tool
```http
POST /api/tools/delete
Content-Type: application/json
```

**Example:**
```bash
curl -X DELETE http://localhost:5000/api/tools/2
```

---

## 🛠️ Tool Inventory Management Endpoints

### 1. Get All Tool Inventory
```http
POST /api/tools/inventory/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/tools/inventory/getAll \
  -H "Content-Type: application/json"
```

**Response:**
```json
[
  {
    "id": 1,
    "tool_id": 1,
    "quantity_available": 5,
    "condition": "Good",
    "tool_name": "Wire Cutters",
    "notes": "Professional wire cutters"
  }
]
```

### 2. Create Tool Inventory Entry
```http
POST /api/tools/inventory
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/tools/inventory \
  -H "Content-Type: application/json" \
  -d '{
    "tool_id": 1,
    "quantity_available": 5,
    "condition": "Good"
  }'
```

### 3. Update Tool Inventory
```http
POST /api/tools/inventory/update
Content-Type: application/json
```

**Example:**
```bash
curl -X PUT http://localhost:5000/api/tools/inventory \
  -H "Content-Type: application/json" \
  -d '{
    "tool_id": 1,
    "quantity_available": 3,
    "condition": "Good"
  }'
```

### 4. Adjust Tool Quantity
```http
POST /api/tools/inventory/adjust
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/tools/inventory/adjust \
  -H "Content-Type: application/json" \
  -d '{
    "tool_id": 1,
    "quantity_change": -2
  }'
```

---

## 🖼️ Gallery & Image Management Endpoints

### 1. Upload Design Images (Multiple Files)
```http
POST /api/gallery/design
Content-Type: application/json
```

**Example (Single Image):**
```bash
curl -X POST http://localhost:5000/api/gallery/design \
  -F "images=@/path/to/design.jpg" \
  -F "event_id=1" \
  -F "notes=Initial design concept for wedding"
```

**Example (Multiple Images):**
```bash
curl -X POST http://localhost:5000/api/gallery/design \
  -F "images=@/path/to/design1.jpg" \
  -F "images=@/path/to/design2.jpg" \
  -F "images=@/path/to/design3.jpg" \
  -F "event_id=1" \
  -F "notes=Multiple design concepts for wedding"
```

**Response:**
```json
{
  "success": true,
  "message": "Successfully uploaded 3 design images",
  "data": [
    {
      "id": 1,
      "event_id": 1,
      "notes": "Multiple design concepts for wedding",
      "created_at": "2024-01-17T10:30:00Z"
    },
    {
      "id": 2,
      "event_id": 1,
      "notes": "Multiple design concepts for wedding",
      "created_at": "2024-01-17T10:30:01Z"
    },
    {
      "id": 3,
      "event_id": 1,
      "notes": "Multiple design concepts for wedding",
      "created_at": "2024-01-17T10:30:02Z"
    }
  ],
  "count": 3
}
```

**Note:** You can upload up to 10 images at once. Each image will be stored locally in organized folders: `/uploads/events/event_id/design_images/design_images_N.jpg` and saved to the database with the same notes.

### 2. Upload Design Image (URL)
```http
POST /api/gallery/design
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/gallery/design \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "notes": "Initial design concept for wedding"
  }'
```

### 3. Upload Final Images (Multiple Files)
```http
POST /api/gallery/final
Content-Type: application/json
```

**Example (Single Image):**
```bash
curl -X POST http://localhost:5000/api/gallery/final \
  -F "images=@/path/to/final.jpg" \
  -F "event_id=1" \
  -F "description=Final decoration result"
```

**Example (Multiple Images):**
```bash
curl -X POST http://localhost:5000/api/gallery/final \
  -F "images=@/path/to/final1.jpg" \
  -F "images=@/path/to/final2.jpg" \
  -F "images=@/path/to/final3.jpg" \
  -F "event_id=1" \
  -F "description=Multiple final decoration results"
```

**Response:**
```json
{
  "success": true,
  "message": "Successfully uploaded 3 final images",
  "data": [
    {
      "id": 1,
      "event_id": 1,
      "description": "Multiple final decoration results",
      "created_at": "2024-01-17T10:30:00Z"
    },
    {
      "id": 2,
      "event_id": 1,
      "description": "Multiple final decoration results",
      "created_at": "2024-01-17T10:30:01Z"
    },
    {
      "id": 3,
      "event_id": 1,
      "description": "Multiple final decoration results",
      "created_at": "2024-01-17T10:30:02Z"
    }
  ],
  "count": 3
}
```

**Note:** You can upload up to 10 images at once. Each image will be stored locally in organized folders: `/uploads/events/event_id/final_images/final_images_N.jpg` and saved to the database with the same description.

### 4. Upload Final Image (URL)
```http
POST /api/gallery/final
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/gallery/final \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "description": "Final decoration result"
  }'
```

### 5. Get Event Images
```http
POST /api/gallery/getEventImages
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/gallery/getEventImages \
  -H "Content-Type: application/json" \
  -d '{"event_id": 1}'
```



---

## 💰 Cost Management Endpoints

### 1. Get Event Cost Items
```http
POST /api/costs/eventCostItems/getByEvent
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/eventCostItems/getByEvent \
  -H "Content-Type: application/json" \
  -d '{"event_id": 1}'
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
      "document_url": "/uploads/events/1/cost/cost_receipt_1.pdf",
      "document_type": "pdf",
      "uploaded_at": "2024-01-17T10:30:00Z"
    }
  ],
  "total_cost": 1500.00
}
```

### 2. Create Cost Item (with URL)
```http
POST /api/costs/eventCostItems/create
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/eventCostItems/create \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "description": "Materials for wedding decoration",
    "amount": 1500.00,
    "document_url": "https://example.com/invoice.pdf",
    "document_type": "pdf"
  }'
```

**Required Fields:**
- `event_id`: Event ID
- `description`: Description of the cost item
- `amount`: Cost amount

**Optional Fields:**
- `document_url`: URL to supporting document
- `document_type`: Type of document (image, pdf)

### 3. Create Cost Item (with File Upload)
```http
POST /api/costs/eventCostItems/createWithFile
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/eventCostItems/createWithFile \
  -F "document=@/path/to/invoice.pdf" \
  -F "event_id=1" \
  -F "description=Materials for wedding decoration" \
  -F "amount=1500.00"
```

**Response:**
```json
{
  "success": true,
  "message": "Cost item created successfully",
  "data": {
    "id": 1,
    "event_id": 1,
    "description": "Materials for wedding decoration",
    "amount": "1500.00",
    "document_url": "/uploads/events/1/cost/cost_document_1.pdf",
    "document_type": "pdf",
    "uploaded_at": "2024-01-17T10:30:00Z"
  }
}
```

**Note:** Uploaded documents are stored locally in organized folders: `/uploads/events/event_id/cost/cost_[type]_[number].[ext]`. Supported file types: images (jpg, jpeg, png, gif, bmp, webp) and PDFs.

### 4. Update Cost Item (with URL)
```http
POST /api/costs/eventCostItems/update
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/eventCostItems/update \
  -H "Content-Type: application/json" \
  -d '{
    "id": 1,
    "description": "Updated materials for wedding decoration",
    "amount": 1800.00,
    "document_url": "https://example.com/updated-invoice.pdf",
    "document_type": "pdf"
  }'
```

### 5. Update Cost Item (with File Upload)
```http
POST /api/costs/eventCostItems/updateWithFile
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/eventCostItems/updateWithFile \
  -F "document=@/path/to/updated-invoice.pdf" \
  -F "id=1" \
  -F "description=Updated materials for wedding decoration" \
  -F "amount=1800.00"
```

**Response:**
```json
{
  "success": true,
  "message": "Cost item updated successfully",
  "data": {
    "id": 1,
    "event_id": 1,
    "description": "Updated materials for wedding decoration",
    "amount": "1800.00",
    "document_url": "/uploads/events/1/cost/cost_document_2.pdf",
    "document_type": "pdf",
    "uploaded_at": "2024-01-17T10:30:00Z"
  }
}
```

**Note:** When updating with a new document, the old local document will be automatically deleted from the server.

### 6. Delete Cost Item
```http
POST /api/costs/eventCostItems/delete
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/eventCostItems/delete \
  -H "Content-Type: application/json" \
  -d '{"id": 1}'
```

**Response:**
```json
{
  "success": true,
  "message": "Cost item deleted successfully"
}
```

**Note:** When deleting a cost item, any associated local document will be automatically deleted from the server.

### 5. Legacy Endpoints (Backward Compatibility)

#### Get Event Cost Summary
```http
POST /api/costs/getEventCostSummary
Content-Type: application/json
```

#### Add Event Cost Summary
```http
POST /api/costs/addEventCostSummary
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/costs/1 \
  -H "Content-Type: application/json" \
  -d '{
    "material_cost": 1500.00,
    "misc_cost": 300.00
  }'
```

#### Update Event Cost Summary
```http
POST /api/costs/updateEventCostSummary
Content-Type: application/json
```

#### Delete Event Cost Summary
```http
POST /api/costs/deleteEventCostSummary
Content-Type: application/json
```

---

## 📋 Material & Tool Issuance Endpoints

### Material Issuances

#### 1. Get All Material Issuances
```http
POST /api/issuance/materials/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/issuance/materials/getAll \
  -H "Content-Type: application/json"
```

#### 2. Create Material Issuance
```http
POST /api/issuance/materials
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/issuance/materials \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 2,
    "item_id": 3,
    "quantity_issued": 100,
    "notes": "Candles for birthday party"
  }'
```

**Required Fields:**
- `event_id`: Event ID
- `item_id`: Inventory item ID (not material_id)
- `quantity_issued`: Quantity to issue

**Optional Fields:**
- `notes`: Additional notes

#### 3. Get Material Issuances by Event
```http
POST /api/issuance/materials/event/getByEvent
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/issuance/materials/event/getByEvent \
  -H "Content-Type: application/json" \
  -d '{"event_id": 1}'
```

**Response:**
```json
[
  {
    "id": 1,
    "event_id": 1,
    "item_id": 3,
    "quantity_issued": 100,
    "notes": "Candles for wedding",
    "issued_at": "2024-01-17T10:30:00Z",
    "material_name": "Candles",
    "unit": "pieces",
    "category_name": "Lighting"
  }
]
```

### Tool Issuances

#### 1. Get All Tool Issuances
```http
POST /api/issuance/tools/getAll
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/issuance/tools/getAll \
  -H "Content-Type: application/json"
```

#### 2. Create Tool Issuance
```http
POST /api/issuance/tools
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/issuance/tools \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 2,
    "tool_id": 1,
    "quantity_issued": 2,
    "condition": "Good",
    "notes": "Wire cutters for birthday party"
  }'
```

**Required Fields:**
- `event_id`: Event ID
- `tool_id`: Tool ID
- `quantity_issued`: Quantity to issue

**Optional Fields:**
- `condition`: Tool condition (Good, Damaged, Missing) - defaults to "Good"
- `notes`: Additional notes

#### 3. Get Tool Issuances by Event
```http
POST /api/issuance/tools/event/getByEvent
Content-Type: application/json
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/issuance/tools/event/getByEvent \
  -H "Content-Type: application/json" \
  -d '{"event_id": 1}'
```

### Legacy Endpoints (Backward Compatibility)

#### Get All Issuances
```http
POST /api/issuance/getAll
Content-Type: application/json
```

#### Create Material Issuance (Legacy)
```http
POST /api/issuance
Content-Type: application/json
```

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

#### Get Issuances by Event (Legacy)
```http
POST /api/issuance/event/getByEvent
Content-Type: application/json
```

---

## 📅 Year Management Endpoints

### 1. Get All Years
```http
POST /api/years/getAll
Content-Type: application/json
```

**Response:**
```json
[
  {
    "id": 1,
    "year_name": "2024",
    "created_at": "2024-01-01T00:00:00.000Z"
  },
  {
    "id": 2,
    "year_name": "2025",
    "created_at": "2024-01-01T00:00:00.000Z"
  }
]
```

### 2. Get Year by ID
```http
POST /api/years/getById
Content-Type: application/json
```

**Request Body:**
```json
{
  "id": 1
}
```

**Response:**
```json
{
  "id": 1,
  "year_name": "2024",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

**Error Response (404):**
```json
{
  "message": "Year not found"
}
```

### 3. Create Year
```http
POST /api/years/create
Content-Type: application/json
```

**Request Body:**
```json
{
  "year_name": "2025"
}
```

**Validation Rules:**
- `year_name`: Required, must be unique

**Success Response (201):**
```json
{
  "id": 3,
  "year_name": "2025",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

**Error Response (400):**
```json
{
  "message": "year_name is required"
}
```

**Error Response (400) - Duplicate:**
```json
{
  "message": "Year name already exists"
}
```

### 4. Update Year
```http
POST /api/years/update
Content-Type: application/json
```

**Request Body:**
```json
{
  "year_name": "2026"
}
```

**Success Response:**
```json
{
  "id": 1,
  "year_name": "2026",
  "created_at": "2024-01-01T00:00:00.000Z"
}
```

**Error Response (404):**
```json
{
  "message": "Year not found"
}
```

### 5. Delete Year
```http
POST /api/years/delete
Content-Type: application/json
```

**Request Body:**
```json
{
  "id": 1
}
```

**Success Response:**
```json
{
  "message": "Year deleted successfully"
}
```

**Error Response (404):**
```json
{
  "message": "Year not found"
}
```

---

## 🧪 Testing & Development Tools

### 📋 Postman Collection
You can import this collection into Postman for easy API testing:

```json
{
  "info": {
    "name": "DecorationApp API",
    "description": "Complete API collection for DecorationApp",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "base_url",
      "value": "http://localhost:5000"
    }
  ],
  "item": [
    {
      "name": "Authentication",
      "item": [
        {
          "name": "Get OAuth URL",
          "request": {
            "method": "POST",
            "header": [],
            "url": "{{base_url}}/auth/google"
          }
        },
        {
          "name": "Check Auth Status",
          "request": {
            "method": "POST",
            "header": [],
            "url": "{{base_url}}/auth/status"
          }
        }
      ]
    },
    {
      "name": "Users",
      "item": [
        {
          "name": "Get All Users",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "url": "{{base_url}}/api/users/getAll"
          }
        },
        {
          "name": "Create User",
          "request": {
            "method": "POST",
            "header": [{"key": "Content-Type", "value": "application/json"}],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"username\": \"test_user\",\n  \"password\": \"password123\",\n  \"role\": \"viewer\"\n}"
            },
            "url": "{{base_url}}/api/users/create"
          }
        }
      ]
    }
  ]
}
```

### 🔧 cURL Examples
```bash
# Test server connectivity
curl -X POST http://localhost:5000/api/users/getAll \
  -H "Content-Type: application/json"

# Test with verbose output
curl -v -X POST http://localhost:5000/api/users/getAll \
  -H "Content-Type: application/json"

# Test file upload
curl -X POST http://localhost:5000/api/events/create \
  -F "cover_image=@/path/to/image.jpg" \
  -F "template_id=1" \
  -F "date=2024-12-25" \
  -F "location=Test Location" \
  -F "description=Test Event"
```

### 🐍 Python Testing Script
```python
import requests
import json

BASE_URL = "http://localhost:5000"

def test_api():
    # Test get all users
    response = requests.post(f"{BASE_URL}/api/users/getAll", 
                           headers={"Content-Type": "application/json"})
    print(f"Users API: {response.status_code}")
    print(json.dumps(response.json(), indent=2))
    
    # Test create user
    user_data = {
        "username": "test_user",
        "password": "password123",
        "role": "viewer"
    }
    response = requests.post(f"{BASE_URL}/api/users/create",
                           headers={"Content-Type": "application/json"},
                           json=user_data)
    print(f"Create User: {response.status_code}")
    print(json.dumps(response.json(), indent=2))

if __name__ == "__main__":
    test_api()
```

### 🟨 JavaScript Testing Script
```javascript
const BASE_URL = 'http://localhost:5000';

async function testAPI() {
    try {
        // Test get all users
        const usersResponse = await fetch(`${BASE_URL}/api/users/getAll`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });
        const usersData = await usersResponse.json();
        console.log('Users API:', usersData);
        
        // Test create user
        const createUserResponse = await fetch(`${BASE_URL}/api/users/create`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                username: 'test_user',
                password: 'password123',
                role: 'viewer'
            })
        });
        const createUserData = await createUserResponse.json();
        console.log('Create User:', createUserData);
        
    } catch (error) {
        console.error('API Test Error:', error);
    }
}

testAPI();
```

## 🚀 Quick Start Examples

### 1. Setup and Test OAuth
```bash
# Setup OAuth
npm run setup

# Test OAuth integration
npm run test-oauth

# Check authentication status
curl -X POST http://localhost:5000/auth/status \
  -H "Content-Type: application/json"
```

### 2. Create Event with Cover Image
```bash
# Create event with file upload (images stored in organized folders)
curl -X POST http://localhost:5000/api/events/create \
  -F "cover_image=@/path/to/cover.jpg" \
  -F "template_id=1" \
  -F "year_id=2024" \
  -F "date=2024-04-10" \
  -F "location=Beach Resort" \
  -F "description=Beach wedding decoration"

# The image will be stored as: /uploads/events/event_id/cover_image_event_id
```

### 3. Upload Gallery Images
```bash
# Upload single design image
curl -X POST http://localhost:5000/api/gallery/design \
  -F "images=@/path/to/design.jpg" \
  -F "event_id=1" \
  -F "notes=Initial design concept"

# Upload multiple design images
curl -X POST http://localhost:5000/api/gallery/design \
  -F "images=@/path/to/design1.jpg" \
  -F "images=@/path/to/design2.jpg" \
  -F "images=@/path/to/design3.jpg" \
  -F "event_id=1" \
  -F "notes=Multiple design concepts"

# Upload single final image
curl -X POST http://localhost:5000/api/gallery/final \
  -F "images=@/path/to/final.jpg" \
  -F "event_id=1" \
  -F "description=Final decoration result"

# Upload multiple final images
curl -X POST http://localhost:5000/api/gallery/final \
  -F "images=@/path/to/final1.jpg" \
  -F "images=@/path/to/final2.jpg" \
  -F "event_id=1" \
  -F "description=Multiple final results"

# Images will be stored as:
# - Design: /uploads/events/1/design_images/design_images_1.jpg, design_images_2.jpg, etc.
# - Final: /uploads/events/1/final_images/final_images_1.jpg, final_images_2.jpg, etc.
```

### 4. Manage Categories and Materials
```bash
# Create category first
curl -X POST http://localhost:5000/api/materials/categories \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Flowers"
  }'

# Create material (inventory item)
curl -X POST http://localhost:5000/api/materials/create \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Roses",
    "category_id": 1,
    "unit": "pieces",
    "storage_location": "Cold Storage A",
    "notes": "Fresh red roses"
  }'

# Check inventory
curl -X POST http://localhost:5000/api/materials/inventory/getAll \
  -H "Content-Type: application/json"
```

### 6. Manage Specialized Inventory
```bash
# Create furniture item
curl -X POST http://localhost:5000/api/materials/furniture \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 1,
    "material": "Wood",
    "dimensions": "120x60x75cm"
  }'

# Create fabric item
curl -X POST http://localhost:5000/api/materials/fabric \
  -H "Content-Type: application/json" \
  -d '{
    "item_id": 2,
    "fabric_type": "Silk",
    "pattern": "Floral",
    "width": 150,
    "length": 200,
    "color": "Red"
  }'

# Get specialized inventory by category
curl -X POST http://localhost:5000/api/materials/specialized/category/getByCategory \
  -H "Content-Type: application/json" \
  -d '{"category_id": 1}'
```

### 7. Track Costs
```bash
# Add cost item with URL
curl -X POST http://localhost:5000/api/costs/eventCostItems/create \
  -H "Content-Type: application/json" \
  -d '{
    "event_id": 1,
    "description": "Materials for wedding decoration",
    "amount": 1500.00,
    "document_url": "https://example.com/invoice.pdf",
    "document_type": "pdf"
  }'

# Add cost item with file upload
curl -X POST http://localhost:5000/api/costs/eventCostItems/createWithFile \
  -F "document=@/path/to/invoice.pdf" \
  -F "event_id=1" \
  -F "description=Materials for wedding decoration" \
  -F "amount=1500.00"

# Get all cost items for an event
curl -X POST http://localhost:5000/api/costs/eventCostItems/getByEvent \
  -H "Content-Type: application/json" \
  -d '{"event_id": 1}'

# Documents will be stored as: /uploads/events/1/cost/cost_document_1.pdf, cost_image_1.jpg, etc.
```

---

## 📝 Notes

1. **Organized Storage**: All event files are stored in organized local folders:
   - **Cover Images**: `/uploads/events/event_id/cover_image_event_id`
   - **Design Images**: `/uploads/events/event_id/design_images/design_images_N.jpg`
   - **Final Images**: `/uploads/events/event_id/final_images/final_images_N.jpg`
   - **Cost Documents**: `/uploads/events/event_id/cost/cost_[type]_[number].[ext]`
2. **File Uploads**: Use `multipart/form-data` for file uploads
3. **Image Access**: Uploaded images are accessible at `http://localhost:5000/uploads/events/event_id/[folder]/[filename]`
4. **Image Cleanup**: Event folders and all contents (including design and final images) are automatically deleted when events are deleted
5. **Error Handling**: All endpoints return appropriate HTTP status codes and error messages
6. **CORS**: The API supports CORS for frontend integration
7. **Static Files**: The `/uploads` path serves static files from the local uploads directory

## 🔒 Security Notes

1. **Never commit** `client_secret.json` to version control
2. **Keep** `config/token.json` secure (contains access tokens)
3. **Use environment variables** for production
4. **Regularly rotate** OAuth credentials

## 🔧 Troubleshooting

### Common Issues & Solutions

| Issue | Error Message | Solution |
|-------|---------------|----------|
| **Connection Refused** | `ECONNREFUSED` | Ensure server is running on port 5000 |
| **CORS Error** | `Access-Control-Allow-Origin` | CORS is enabled, check frontend origin |
| **File Upload Failed** | `MulterError` | Check file size and format |
| **Database Error** | `ER_NO_SUCH_TABLE` | Run database migrations |
| **Authentication Failed** | `401 Unauthorized` | Check OAuth credentials |
| **Validation Error** | `400 Bad Request` | Check request body format |

### Debug Commands
```bash
# Check server status
curl -X POST http://localhost:5000/auth/status \
  -H "Content-Type: application/json"

# Test database connection
curl -X POST http://localhost:5000/api/users/getAll \
  -H "Content-Type: application/json"

# Check file uploads directory
ls -la uploads/

# View server logs
tail -f logs/app.log
```

### Performance Tips
- Use appropriate Content-Type headers
- Compress images before upload
- Implement pagination for large datasets
- Use connection pooling for database
- Cache frequently accessed data

### Best Practices
- Always handle errors gracefully
- Validate input data on both client and server
- Use HTTPS in production
- Implement rate limiting
- Log important operations
- Regular database backups

---

## Gallery APIs

### Get Event Images
**POST** `/api/gallery/event/images`

Retrieves all design images and final images for a specific event.

**Request Body:**
```json
{
  "event_id": 40
}
```

**Parameters:**
- `event_id` (body) - Event ID to retrieve images for

**Response:**
```json
{
  "success": true,
  "message": "Event images retrieved successfully",
  "data": {
    "event_id": 40,
    "design_images": [
      {
        "id": 10,
        "event_id": 40,
        "image_url": "/uploads/events/40/design_images/design_images_1.png",
        "notes": "Initial design concept",
        "created_at": "2025-09-06T15:30:00.000Z"
      }
    ],
    "final_images": [
      {
        "id": 5,
        "event_id": 40,
        "image_url": "/uploads/events/40/final_images/final_images_1.png",
        "description": "Final decoration result",
        "created_at": "2025-09-06T16:00:00.000Z"
      }
    ],
    "design_count": 1,
    "final_count": 1,
    "total_images": 2
  }
}
```

**Example:**
```bash
curl -X POST http://localhost:5000/api/gallery/event/images \
  -H "Content-Type: application/json" \
  -d '{"event_id": 40}'
```

**Use Cases:**
- Display event gallery
- Before/after image comparison
- Event documentation
- Image count statistics 