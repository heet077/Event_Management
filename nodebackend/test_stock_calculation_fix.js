// Test script to verify stock calculation fix
// This script tests that OUT operations debit correctly and IN operations credit correctly (not double)

import * as InventoryModel from './models/inventory.model.js';

async function testStockCalculations() {
  console.log('🧪 Testing Stock Calculation Fix...\n');
  
  const testItemId = 3; // Use item_id 3 for testing
  const testEventId = 30; // Use event_id 30 for testing
  
  try {
    // Get initial stock
    const initialStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`📊 Initial Stock for Item ${testItemId}: ${initialStock.quantity_available}`);
    
    // Test 1: Create OUT transaction (should debit 25)
    console.log('\n🔴 Test 1: Creating OUT transaction (quantity: 25)');
    const outIssuance = await InventoryModel.createMaterialIssuance({
      item_id: testItemId,
      transaction_type: 'OUT',
      quantity: 25,
      event_id: testEventId,
      notes: 'Test OUT transaction'
    });
    
    const afterOutStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ After OUT: Stock = ${afterOutStock.quantity_available}`);
    console.log(`📈 Expected: ${initialStock.quantity_available} - 25 = ${initialStock.quantity_available - 25}`);
    console.log(`✅ OUT Test: ${afterOutStock.quantity_available === (initialStock.quantity_available - 25) ? 'PASSED' : 'FAILED'}`);
    
    // Test 2: Update to IN transaction (should credit 25, not 50)
    console.log('\n🟢 Test 2: Updating to IN transaction (quantity: 25)');
    const updatedIssuance = await InventoryModel.updateMaterialIssuance({
      id: outIssuance.id,
      item_id: testItemId,
      transaction_type: 'IN',
      quantity: 25,
      event_id: testEventId,
      notes: 'Test IN transaction (updated)'
    });
    
    const afterInStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ After IN Update: Stock = ${afterInStock.quantity_available}`);
    console.log(`📈 Expected: ${initialStock.quantity_available} (should be back to original)`);
    console.log(`✅ IN Test: ${afterInStock.quantity_available === initialStock.quantity_available ? 'PASSED' : 'FAILED'}`);
    
    // Test 3: Create another OUT transaction
    console.log('\n🔴 Test 3: Creating another OUT transaction (quantity: 10)');
    const outIssuance2 = await InventoryModel.createMaterialIssuance({
      item_id: testItemId,
      transaction_type: 'OUT',
      quantity: 10,
      event_id: testEventId,
      notes: 'Test second OUT transaction'
    });
    
    const afterOut2Stock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ After second OUT: Stock = ${afterOut2Stock.quantity_available}`);
    console.log(`📈 Expected: ${initialStock.quantity_available} - 10 = ${initialStock.quantity_available - 10}`);
    console.log(`✅ Second OUT Test: ${afterOut2Stock.quantity_available === (initialStock.quantity_available - 10) ? 'PASSED' : 'FAILED'}`);
    
    // Test 4: Create IN transaction (should credit 10, not 20)
    console.log('\n🟢 Test 4: Creating IN transaction (quantity: 10)');
    const inIssuance = await InventoryModel.createMaterialIssuance({
      item_id: testItemId,
      transaction_type: 'IN',
      quantity: 10,
      event_id: testEventId,
      notes: 'Test IN transaction'
    });
    
    const afterIn2Stock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ After IN: Stock = ${afterIn2Stock.quantity_available}`);
    console.log(`📈 Expected: ${initialStock.quantity_available} (should be back to original)`);
    console.log(`✅ IN Credit Test: ${afterIn2Stock.quantity_available === initialStock.quantity_available ? 'PASSED' : 'FAILED'}`);
    
    // Cleanup: Delete test issuances
    console.log('\n🧹 Cleaning up test data...');
    await InventoryModel.deleteMaterialIssuance(outIssuance.id);
    await InventoryModel.deleteMaterialIssuance(outIssuance2.id);
    await InventoryModel.deleteMaterialIssuance(inIssuance.id);
    
    const finalStock = await InventoryModel.getStockByItemId(testItemId);
    console.log(`✅ Final Stock: ${finalStock.quantity_available}`);
    console.log(`✅ Cleanup Test: ${finalStock.quantity_available === initialStock.quantity_available ? 'PASSED' : 'FAILED'}`);
    
    console.log('\n🎉 Stock Calculation Fix Test Complete!');
    
  } catch (error) {
    console.error('❌ Test failed:', error.message);
  }
}

// Run the test
testStockCalculations();
