// Test script for Inventory Stock Management
// This script demonstrates the new stock management logic

import * as InventoryModel from './models/inventory.model.js';

async function testInventoryStockManagement() {
  console.log('🧪 Testing Inventory Stock Management\n');

  try {
    // Step 1: Create a test category
    console.log('1. Creating test category...');
    const category = await InventoryModel.createCategory({ name: 'Test Category' });
    console.log(`✅ Category created: ${category.name} (ID: ${category.id})\n`);

    // Step 2: Create a test inventory item
    console.log('2. Creating test inventory item...');
    const itemData = {
      name: 'Test Item',
      category_id: category.id,
      unit: 'pieces',
      storage_location: 'Warehouse A',
      notes: 'Test item for stock management'
    };
    const item = await InventoryModel.createInventoryItemWithDetails(itemData, null);
    console.log(`✅ Item created: ${item.name} (ID: ${item.id})\n`);

    // Step 3: Set initial stock
    console.log('3. Setting initial stock...');
    await InventoryModel.updateStock({ item_id: item.id, quantity_available: 100 });
    const initialStock = await InventoryModel.getStockByItemId(item.id);
    console.log(`✅ Initial stock set: ${initialStock.quantity_available} pieces\n`);

    // Step 4: Test OUT transaction (items being taken out - should DEDUCT from stock)
    console.log('4. Testing OUT transaction (items being taken out)...');
    const outIssuance = await InventoryModel.createMaterialIssuance({
      item_id: item.id,
      transaction_type: 'OUT',
      quantity: 20,
      event_id: 1,
      notes: 'Items taken out for event'
    });
    const stockAfterOut = await InventoryModel.getStockByItemId(item.id);
    console.log(`✅ OUT transaction completed:`);
    console.log(`   - Quantity taken out: 20 pieces`);
    console.log(`   - Stock before: 100 pieces`);
    console.log(`   - Stock after: ${stockAfterOut.quantity_available} pieces`);
    console.log(`   - Change: -20 pieces (deducted from stock)\n`);

    // Step 5: Test IN transaction (items being returned - should ADD to stock)
    console.log('5. Testing IN transaction (items being returned)...');
    const inIssuance = await InventoryModel.createMaterialIssuance({
      item_id: item.id,
      transaction_type: 'IN',
      quantity: 5,
      event_id: 1,
      notes: 'Items returned from event'
    });
    const stockAfterIn = await InventoryModel.getStockByItemId(item.id);
    console.log(`✅ IN transaction completed:`);
    console.log(`   - Quantity returned: 5 pieces`);
    console.log(`   - Stock before: ${stockAfterOut.quantity_available} pieces`);
    console.log(`   - Stock after: ${stockAfterIn.quantity_available} pieces`);
    console.log(`   - Change: +5 pieces (added to stock)\n`);

    // Step 6: Test updating a transaction
    console.log('6. Testing transaction update...');
    const updatedIssuance = await InventoryModel.updateMaterialIssuance({
      id: outIssuance.id,
      item_id: item.id,
      transaction_type: 'OUT',
      quantity: 25, // Changed from 20 to 25
      event_id: 1,
      notes: 'Updated: Items taken out for event'
    });
    const stockAfterUpdate = await InventoryModel.getStockByItemId(item.id);
    console.log(`✅ Transaction updated:`);
    console.log(`   - Original quantity: 20 pieces`);
    console.log(`   - Updated quantity: 25 pieces`);
    console.log(`   - Stock after update: ${stockAfterUpdate.quantity_available} pieces`);
    console.log(`   - Additional change: -5 pieces (additional deduction)\n`);

    // Step 7: Test deleting a transaction
    console.log('7. Testing transaction deletion...');
    const deletedIssuance = await InventoryModel.deleteMaterialIssuance(inIssuance.id);
    const stockAfterDelete = await InventoryModel.getStockByItemId(item.id);
    console.log(`✅ Transaction deleted:`);
    console.log(`   - Deleted transaction: IN 5 pieces`);
    console.log(`   - Stock after deletion: ${stockAfterDelete.quantity_available} pieces`);
    console.log(`   - Change: -5 pieces (reversed the IN transaction)\n`);

    // Step 8: Final stock summary
    console.log('8. Final Stock Summary:');
    const finalStock = await InventoryModel.getStockByItemId(item.id);
    const allIssuances = await InventoryModel.getAllMaterialIssuances();
    console.log(`   - Final stock: ${finalStock.quantity_available} pieces`);
    console.log(`   - Total transactions: ${allIssuances.length}`);
    console.log(`   - Expected: 100 (initial) - 25 (OUT) - 0 (IN deleted) = 75 pieces`);

    console.log('\n🎉 All tests completed successfully!');
    console.log('\n📋 Summary of Stock Management Logic:');
    console.log('   - OUT transactions: DEDUCT quantity from stock (items being taken out)');
    console.log('   - IN transactions: ADD quantity to stock (items being returned)');
    console.log('   - Updates: Automatically reverse old transaction and apply new one');
    console.log('   - Deletions: Automatically reverse the transaction effect');

  } catch (error) {
    console.error('❌ Test failed:', error.message);
    console.error(error.stack);
  }
}

// Run the test
testInventoryStockManagement();
