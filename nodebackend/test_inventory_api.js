import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

const BASE_URL = 'http://localhost:5000/api/inventory';

// Test data
let categoryId;
let itemId;
let stockId;
let issuanceId;

const testData = {
  category: {
    name: 'Test Furniture'
  },
  item: {
    name: 'Test Office Chair',
    category_id: null, // Will be set after category creation
    unit: 'pieces',
    storage_location: 'Test Warehouse',
    notes: 'Test ergonomic office chair',
    quantity_available: 25,
    item_image: '/uploads/inventory/test_chair.jpg',
    category_details: {
      material: 'Test Leather',
      dimensions: '60x60x120cm'
    }
  },
  stock: {
    item_id: null, // Will be set after item creation
    quantity_available: 50
  },
  issuance: {
    item_id: null, // Will be set after item creation
    transaction_type: 'OUT',
    quantity: 5,
    event_id: 123,
    notes: 'Test issuance for office setup'
  }
};

// Helper function to log test results
const logTest = (testName, success, data = null, error = null) => {
  console.log(`\n${success ? '✅' : '❌'} ${testName}`);
  if (data) {
    console.log('   Data:', JSON.stringify(data, null, 2));
  }
  if (error) {
    console.log('   Error:', error.response?.data || error.message);
  }
};

// Test Categories
const testCategories = async () => {
  console.log('\n🧪 Testing Categories...');

  try {
    // Create category
    const createResponse = await axios.post(`${BASE_URL}/categories/create`, testData.category);
    categoryId = createResponse.data.data.id;
    testData.item.category_id = categoryId;
    logTest('Create Category', true, createResponse.data.data);

    // Get all categories
    const getAllResponse = await axios.post(`${BASE_URL}/categories/getAll`, {});
    logTest('Get All Categories', true, getAllResponse.data.data);

    // Get category by ID
    const getByIdResponse = await axios.post(`${BASE_URL}/categories/getById`, { id: categoryId });
    logTest('Get Category by ID', true, getByIdResponse.data.data);

    // Update category
    const updateData = { id: categoryId, name: 'Updated Test Furniture' };
    const updateResponse = await axios.post(`${BASE_URL}/categories/update`, updateData);
    logTest('Update Category', true, updateResponse.data.data);

  } catch (error) {
    logTest('Categories Test', false, null, error);
  }
};

// Test Inventory Items
const testInventoryItems = async () => {
  console.log('\n🧪 Testing Inventory Items...');

  try {
    // Create inventory item with form data (for image upload support)
    const formData = new FormData();
    formData.append('name', testData.item.name);
    formData.append('category_id', testData.item.category_id);
    formData.append('unit', testData.item.unit);
    formData.append('storage_location', testData.item.storage_location);
    formData.append('notes', testData.item.notes);
    formData.append('quantity_available', testData.item.quantity_available);
    formData.append('category_details', JSON.stringify(testData.item.category_details));

    const createResponse = await axios.post(`${BASE_URL}/items/create`, formData, {
      headers: {
        ...formData.getHeaders()
      }
    });
    itemId = createResponse.data.data.id;
    testData.stock.item_id = itemId;
    testData.issuance.item_id = itemId;
    logTest('Create Inventory Item', true, createResponse.data.data);

    // Get all inventory items
    const getAllResponse = await axios.post(`${BASE_URL}/items/getAll`, {});
    logTest('Get All Inventory Items', true, getAllResponse.data.data);

    // Get inventory item by ID
    const getByIdResponse = await axios.post(`${BASE_URL}/items/getById`, { id: itemId });
    logTest('Get Inventory Item by ID', true, getByIdResponse.data.data);

    // Update inventory item with form data
    const updateFormData = new FormData();
    updateFormData.append('id', itemId);
    updateFormData.append('name', 'Updated Test Office Chair');
    updateFormData.append('category_id', categoryId);
    updateFormData.append('unit', 'pieces');
    updateFormData.append('storage_location', 'Updated Test Warehouse');
    updateFormData.append('notes', 'Updated test ergonomic office chair');

    const updateResponse = await axios.post(`${BASE_URL}/items/update`, updateFormData, {
      headers: {
        ...updateFormData.getHeaders()
      }
    });
    logTest('Update Inventory Item', true, updateResponse.data.data);

  } catch (error) {
    logTest('Inventory Items Test', false, null, error);
  }
};

// Test Stock Management
const testStockManagement = async () => {
  console.log('\n🧪 Testing Stock Management...');

  try {
    // Create stock
    const createResponse = await axios.post(`${BASE_URL}/stock/create`, testData.stock);
    stockId = createResponse.data.data.id;
    logTest('Create Stock', true, createResponse.data.data);

    // Get stock by item ID
    const getByItemIdResponse = await axios.post(`${BASE_URL}/stock/getByItemId`, { item_id: itemId });
    logTest('Get Stock by Item ID', true, getByItemIdResponse.data.data);

    // Update stock
    const updateData = { item_id: itemId, quantity_available: 45 };
    const updateResponse = await axios.post(`${BASE_URL}/stock/update`, updateData);
    logTest('Update Stock', true, updateResponse.data.data);

    // Get all stock
    const getAllResponse = await axios.post(`${BASE_URL}/stock/getAll`, {});
    logTest('Get All Stock', true, getAllResponse.data.data);

  } catch (error) {
    logTest('Stock Management Test', false, null, error);
  }
};

// Test Material Issuances
const testMaterialIssuances = async () => {
  console.log('\n🧪 Testing Material Issuances...');

  try {
    // Create material issuance
    const createResponse = await axios.post(`${BASE_URL}/issuances/create`, testData.issuance);
    issuanceId = createResponse.data.data.id;
    logTest('Create Material Issuance', true, createResponse.data.data);

    // Get all material issuances
    const getAllResponse = await axios.post(`${BASE_URL}/issuances/getAll`, {});
    logTest('Get All Material Issuances', true, getAllResponse.data.data);

    // Get material issuance by ID
    const getByIdResponse = await axios.post(`${BASE_URL}/issuances/getById`, { id: issuanceId });
    logTest('Get Material Issuance by ID', true, getByIdResponse.data.data);

    // Update material issuance
    const updateData = {
      id: issuanceId,
      item_id: itemId,
      transaction_type: 'OUT',
      quantity: 3,
      event_id: 123,
      notes: 'Updated test issuance for office setup'
    };
    const updateResponse = await axios.post(`${BASE_URL}/issuances/update`, updateData);
    logTest('Update Material Issuance', true, updateResponse.data.data);

  } catch (error) {
    logTest('Material Issuances Test', false, null, error);
  }
};

// Test Transactions
const testTransactions = async () => {
  console.log('\n🧪 Testing Transactions...');

  try {
    // Record transaction (stock movement)
    const transactionData = {
      item_id: itemId,
      transaction_type: 'OUT',
      quantity: 2,
      event_id: 456,
      notes: 'Test transaction for office setup'
    };
    const transactionResponse = await axios.post(`${BASE_URL}/transactions`, transactionData);
    logTest('Record Transaction', true, transactionResponse.data.data);

    // Get stock balance
    const balanceResponse = await axios.post(`${BASE_URL}/stock/balance`, { item_id: itemId });
    logTest('Get Stock Balance', true, balanceResponse.data.data);

  } catch (error) {
    logTest('Transactions Test', false, null, error);
  }
};

// Test Error Cases
const testErrorCases = async () => {
  console.log('\n🧪 Testing Error Cases...');

  try {
    // Test creating category without name
    try {
      await axios.post(`${BASE_URL}/categories/create`, {});
      logTest('Create Category without Name', false, null, { message: 'Should have failed' });
    } catch (error) {
      logTest('Create Category without Name', true, null, error);
    }

    // Test creating item without required fields
    try {
      await axios.post(`${BASE_URL}/items/create`, { name: 'Test Item' });
      logTest('Create Item without Category ID', false, null, { message: 'Should have failed' });
    } catch (error) {
      logTest('Create Item without Category ID', true, null, error);
    }

    // Test invalid transaction type
    try {
      await axios.post(`${BASE_URL}/transactions`, {
        item_id: itemId,
        transaction_type: 'INVALID',
        quantity: 1,
        event_id: 789,
        notes: 'Test invalid transaction'
      });
      logTest('Invalid Transaction Type', false, null, { message: 'Should have failed' });
    } catch (error) {
      logTest('Invalid Transaction Type', true, null, error);
    }

    // Test insufficient stock
    try {
      await axios.post(`${BASE_URL}/transactions`, {
        item_id: itemId,
        transaction_type: 'OUT',
        quantity: 1000, // More than available stock
        event_id: 999,
        notes: 'Test insufficient stock'
      });
      logTest('Insufficient Stock Transaction', false, null, { message: 'Should have failed' });
    } catch (error) {
      logTest('Insufficient Stock Transaction', true, null, error);
    }

  } catch (error) {
    logTest('Error Cases Test', false, null, error);
  }
};

// Cleanup function
const cleanup = async () => {
  console.log('\n🧹 Cleaning up test data...');

  try {
    // Delete material issuance
    if (issuanceId) {
      await axios.post(`${BASE_URL}/issuances/delete`, { id: issuanceId });
      console.log('✅ Deleted material issuance');
    }

    // Delete inventory item (this will cascade to stock)
    if (itemId) {
      await axios.post(`${BASE_URL}/items/delete`, { id: itemId });
      console.log('✅ Deleted inventory item');
    }

    // Delete category
    if (categoryId) {
      await axios.post(`${BASE_URL}/categories/delete`, { id: categoryId });
      console.log('✅ Deleted category');
    }

  } catch (error) {
    console.log('❌ Cleanup error:', error.response?.data || error.message);
  }
};

// Main test function
const runTests = async () => {
  console.log('🚀 Starting Inventory API Tests...\n');

  try {
    await testCategories();
    await testInventoryItems();
    await testStockManagement();
    await testMaterialIssuances();
    await testTransactions();
    await testErrorCases();

    console.log('\n🎉 All tests completed!');
  } catch (error) {
    console.log('\n💥 Test suite failed:', error.message);
  } finally {
    await cleanup();
    console.log('\n✨ Test cleanup completed!');
  }
};

// Run tests if this file is executed directly
if (import.meta.url === `file://${process.argv[1]}`) {
  runTests();
}

export { runTests };
