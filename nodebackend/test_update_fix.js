// Quick test to verify the update fix
// This simulates the exact scenario from the user's issue

import * as InventoryModel from './models/inventory.model.js';

async function testUpdateFix() {
  console.log('🧪 Testing Update Fix...\n');
  
  const testItemId = 4; // Use item_id 4 for testing
  const testEventId = 30; // Use event_id 30 for testing
  
  try {
    // Get initial stock
    const initialStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`📊 Initial Stock for Item ${testItemId}: ${initialStock.quantity_available}`);
    
    // Test 1: Create OUT transaction (should debit 50)
    console.log('\n🔴 Test 1: Creating OUT transaction (quantity: 50)');
    const outIssuance = await InventoryModel.createMaterialIssuance({
      item_id: testItemId,
      transaction_type: 'OUT',
      quantity: 50,
      event_id: testEventId,
      notes: 'Test OUT transaction'
    });
    
    const afterOutStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ After OUT: Stock = ${afterOutStock.quantity_available}`);
    console.log(`📈 Expected: ${initialStock.quantity_available} - 50 = ${initialStock.quantity_available - 50}`);
    console.log(`✅ OUT Test: ${afterOutStock.quantity_available === (initialStock.quantity_available - 50) ? 'PASSED' : 'FAILED'}`);
    
    // Test 2: Update to IN transaction (should credit 50, not 100)
    console.log('\n🟢 Test 2: Updating to IN transaction (quantity: 50)');
    const updatedIssuance = await InventoryModel.updateMaterialIssuance({
      id: outIssuance.id,
      item_id: testItemId,
      transaction_type: 'IN',
      quantity: 50,
      event_id: testEventId,
      notes: 'Test IN transaction (updated)'
    });
    
    const afterInStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ After IN Update: Stock = ${afterInStock.quantity_available}`);
    console.log(`📈 Expected: ${initialStock.quantity_available} (should be back to original)`);
    console.log(`✅ IN Test: ${afterInStock.quantity_available === initialStock.quantity_available ? 'PASSED' : 'FAILED'}`);
    
    // Cleanup: Delete test issuance
    console.log('\n🧹 Cleaning up test data...');
    await InventoryModel.deleteMaterialIssuance(outIssuance.id);
    
    const finalStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ Final Stock: ${finalStock.quantity_available}`);
    console.log(`✅ Cleanup Test: ${finalStock.quantity_available === initialStock.quantity_available ? 'PASSED' : 'FAILED'}`);
    
    console.log('\n🎉 Update Fix Test Complete!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
  }
}

// Run the test
testUpdateFix();
