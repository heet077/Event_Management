# Inventory Stock Management System

## Overview
The inventory stock management system automatically tracks and updates item quantities based on material issuance transactions. The system ensures accurate stock levels by debiting (deducting) quantities for OUT transactions and crediting (adding) quantities for IN transactions.

## Transaction Types

### OUT Transactions
- **Purpose**: Items are being taken out/issued
- **Stock Effect**: **DEDUCT** from stock (debit)
- **Example**: `quantity: 25` → Stock decreases by 25

### IN Transactions  
- **Purpose**: Items are being returned/added back
- **Stock Effect**: **ADD** to stock (credit)
- **Example**: `quantity: 25` → Stock increases by 25

## API Endpoints

### Create Material Issuance
```http
POST /api/inventory/issuances/create
```

**Request Body:**
```json
{
  "item_id": 3,
  "transaction_type": "OUT",
  "quantity": 25,
  "event_id": 30,
  "notes": "Issued for decoration setup"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Material issuance created successfully. Stock deducted.",
  "data": {
    "issuance": { /* issuance details */ },
    "stock_update": {
      "previous_quantity": 100,
      "new_quantity": 75,
      "change": -25
    }
  }
}
```

### Update Material Issuance
```http
PUT /api/inventory/issuances/update
```

**Request Body:**
```json
{
  "id": 5,
  "item_id": 3,
  "transaction_type": "IN",
  "quantity": 25,
  "event_id": 30,
  "notes": "Updated: Items returned"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Material issuance updated successfully. Stock adjusted accordingly.",
  "data": {
    "issuance": { /* updated issuance details */ },
    "stock_update": {
      "new_quantity": 100
    }
  }
}
```

## Stock Management Logic

### Create Operation
1. **Validate** transaction type and quantity
2. **Check** stock availability for OUT transactions
3. **Create** material issuance record
4. **Update** stock based on transaction type:
   - `OUT`: `newStock = currentStock - quantity`
   - `IN`: `newStock = currentStock + quantity`

### Update Operation
1. **Get** original issuance details
2. **Reverse** original transaction effect on stock
3. **Apply** new transaction effect on stock
4. **Update** material issuance record

### Delete Operation
1. **Get** issuance details
2. **Reverse** transaction effect on stock
3. **Delete** material issuance record

## Error Handling

### Insufficient Stock
```json
{
  "error": "Insufficient stock for issue transaction",
  "current_stock": 10,
  "requested_quantity": 25,
  "message": "Cannot issue more items than currently available in stock"
}
```

### Invalid Quantity
```json
{
  "error": "Quantity must be a valid positive number"
}
```

### Stock Record Not Found
```json
{
  "error": "Stock record not found for this item. Please create stock first."
}
```

## Example Workflow

### Scenario: Office Setup Event
1. **Initial Stock**: 100 pieces
2. **Issue Items** (OUT): 25 pieces → Stock: 75 pieces
3. **Return Items** (IN): 25 pieces → Stock: 100 pieces
4. **Issue More** (OUT): 10 pieces → Stock: 90 pieces
5. **Return All** (IN): 10 pieces → Stock: 100 pieces

### API Calls:
```bash
# 1. Issue items
POST /api/inventory/issuances/create
{
  "item_id": 3,
  "transaction_type": "OUT",
  "quantity": 25,
  "event_id": 30,
  "notes": "Issued for office setup"
}

# 2. Return items
POST /api/inventory/issuances/create
{
  "item_id": 3,
  "transaction_type": "IN",
  "quantity": 25,
  "event_id": 30,
  "notes": "Items returned from office setup"
}
```

## Recent Fixes

### Stock Calculation Bug Fix (Latest)
**Issue**: IN transactions were crediting double the quantity (25*2 = 50 instead of 25)

**Root Cause**: Incorrect reversal logic in `updateMaterialIssuance` function

**Fix Applied**:
- Corrected the stock reversal logic in `updateMaterialIssuance`
- Fixed the order of conditions for OUT/IN reversal
- Ensured proper stock calculations for all transaction types

**Before Fix**:
- OUT transaction: Correctly debited 25
- IN transaction: Incorrectly credited 50 (double)

**After Fix**:
- OUT transaction: Correctly debits 25
- IN transaction: Correctly credits 25

## Testing

Run the test script to verify stock calculations:
```bash
node test_stock_calculation_fix.js
```

This will test:
- ✅ OUT transactions debit correctly
- ✅ IN transactions credit correctly (not double)
- ✅ Update operations work properly
- ✅ Delete operations reverse stock correctly

## Database Schema

### Material Issuances Table
```sql
CREATE TABLE material_issuances (
    id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL,
    item_id INTEGER NOT NULL,
    quantity_issued NUMERIC(10, 2) NOT NULL,
    notes TEXT,
    issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_type VARCHAR(10) CHECK (transaction_type IN ('IN', 'OUT'))
);
```

**Note**: The unique constraint `(event_id, item_id)` has been removed to allow multiple issuances per item per event.

## Best Practices

1. **Always validate** quantities before creating transactions
2. **Check stock availability** for OUT transactions
3. **Use descriptive notes** for tracking purposes
4. **Test stock calculations** after updates
5. **Monitor stock levels** regularly

## Support

For issues or questions about the inventory stock management system, refer to the API documentation or contact the development team.
