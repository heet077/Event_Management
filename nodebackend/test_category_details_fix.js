import axios from 'axios';
import FormData from 'form-data';

const BASE_URL = 'http://localhost:5000/api/inventory';

// Test data
let categoryId;
let itemId;

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
    const createResponse = await axios.post(`${BASE_URL}/categories/create`, {
      name: 'Test Furniture for Category Details'
    });
    categoryId = createResponse.data.data.id;
    logTest('Create Category', true, createResponse.data.data);

  } catch (error) {
    logTest('Categories Test', false, null, error);
  }
};

// Test Inventory Item with Category Details
const testInventoryItemWithCategoryDetails = async () => {
  console.log('\n🧪 Testing Inventory Item with Category Details...');

  try {
    // Create form data
    const formData = new FormData();
    formData.append('name', 'Test Office Chair with Category Details');
    formData.append('category_id', categoryId);
    formData.append('unit', 'pieces');
    formData.append('storage_location', 'Test Warehouse');
    formData.append('notes', 'Test ergonomic office chair with category details');
    formData.append('quantity_available', '25');
    formData.append('category_details', JSON.stringify({
      material: 'Test Leather',
      dimensions: '60x60x120cm'
    }));

    // Create inventory item with category details
    const createResponse = await axios.post(`${BASE_URL}/items/create`, formData, {
      headers: {
        ...formData.getHeaders()
      }
    });
    
    itemId = createResponse.data.data.id;
    logTest('Create Inventory Item with Category Details', true, createResponse.data.data);

    // Get the item to verify category details were saved
    const getByIdResponse = await axios.post(`${BASE_URL}/items/getById`, { id: itemId });
    logTest('Get Inventory Item with Category Details', true, getByIdResponse.data.data);

    // Check if category details are present
    if (getByIdResponse.data.data.category_details) {
      console.log('   ✅ Category details found:', getByIdResponse.data.data.category_details);
      if (getByIdResponse.data.data.category_details.material === 'Test Leather' && 
          getByIdResponse.data.data.category_details.dimensions === '60x60x120cm') {
        console.log('   ✅ Category details match expected values');
      } else {
        console.log('   ❌ Category details do not match expected values');
      }
    } else {
      console.log('   ❌ No category details found');
    }

  } catch (error) {
    logTest('Inventory Item with Category Details Test', false, null, error);
  }
};

// Test Error Cases
const testErrorCases = async () => {
  console.log('\n🧪 Testing Error Cases...');

  try {
    // Test invalid JSON in category_details
    try {
      const formData = new FormData();
      formData.append('name', 'Test Item');
      formData.append('category_id', categoryId);
      formData.append('category_details', 'invalid json string');
      
      await axios.post(`${BASE_URL}/items/create`, formData, {
        headers: {
          ...formData.getHeaders()
        }
      });
      logTest('Invalid JSON in category_details', false, null, { message: 'Should have failed' });
    } catch (error) {
      logTest('Invalid JSON in category_details', true, null, error);
    }

  } catch (error) {
    logTest('Error Cases Test', false, null, error);
  }
};

// Cleanup function
const cleanup = async () => {
  console.log('\n🧹 Cleaning up test data...');

  try {
    // Delete inventory item (this will cascade to stock and category details)
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
  console.log('🚀 Starting Category Details Fix Tests...\n');

  try {
    await testCategories();
    await testInventoryItemWithCategoryDetails();
    await testErrorCases();

    console.log('\n🎉 All category details tests completed!');
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
