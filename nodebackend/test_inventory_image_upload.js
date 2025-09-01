import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';
import path from 'path';

const BASE_URL = 'http://localhost:5000/api/inventory';

// Test data
let categoryId;
let itemId;

// Create a test image file
const createTestImage = () => {
  const testImagePath = 'test_inventory_image.jpg';
  
  // Create a simple test image (1x1 pixel JPEG)
  const testImageData = Buffer.from([
    0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01,
    0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00, 0xFF, 0xDB, 0x00, 0x43,
    0x00, 0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07, 0x07, 0x09,
    0x09, 0x08, 0x0A, 0x0C, 0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19, 0x12,
    0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D, 0x1A, 0x1C, 0x1C, 0x20,
    0x24, 0x2E, 0x27, 0x20, 0x22, 0x2C, 0x23, 0x1C, 0x1C, 0x28, 0x37, 0x29,
    0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27, 0x39, 0x3D, 0x38, 0x32,
    0x3C, 0x2E, 0x33, 0x34, 0x32, 0xFF, 0xC0, 0x00, 0x11, 0x08, 0x00, 0x01,
    0x00, 0x01, 0x01, 0x01, 0x11, 0x00, 0x02, 0x11, 0x01, 0x03, 0x11, 0x01,
    0xFF, 0xC4, 0x00, 0x14, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0xFF, 0xC4,
    0x00, 0x14, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xDA, 0x00, 0x0C,
    0x03, 0x01, 0x00, 0x02, 0x11, 0x03, 0x11, 0x00, 0x3F, 0x00, 0x8A, 0x00,
    0x07, 0xFF, 0xD9
  ]);
  
  fs.writeFileSync(testImagePath, testImageData);
  return testImagePath;
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
    const createResponse = await axios.post(`${BASE_URL}/categories/create`, {
      name: 'Test Furniture for Image Upload'
    });
    categoryId = createResponse.data.data.id;
    logTest('Create Category', true, createResponse.data.data);

  } catch (error) {
    logTest('Categories Test', false, null, error);
  }
};

// Test Inventory Item with Image Upload
const testInventoryItemWithImage = async () => {
  console.log('\n🧪 Testing Inventory Item with Image Upload...');

  try {
    // Create test image
    const testImagePath = createTestImage();
    
    // Create form data
    const formData = new FormData();
    formData.append('name', 'Test Office Chair with Image');
    formData.append('category_id', categoryId);
    formData.append('unit', 'pieces');
    formData.append('storage_location', 'Test Warehouse');
    formData.append('notes', 'Test ergonomic office chair with image');
    formData.append('quantity_available', '30');
    formData.append('item_image', fs.createReadStream(testImagePath));
    formData.append('category_details', JSON.stringify({
      material: 'Test Leather',
      dimensions: '60x60x120cm'
    }));

    // Create inventory item with image
    const createResponse = await axios.post(`${BASE_URL}/items/create`, formData, {
      headers: {
        ...formData.getHeaders()
      }
    });
    
    itemId = createResponse.data.data.id;
    logTest('Create Inventory Item with Image', true, createResponse.data.data);

    // Clean up test image
    fs.unlinkSync(testImagePath);

  } catch (error) {
    logTest('Inventory Item with Image Test', false, null, error);
  }
};

// Test Update Inventory Item with New Image
const testUpdateInventoryItemWithImage = async () => {
  console.log('\n🧪 Testing Update Inventory Item with New Image...');

  try {
    // Create new test image
    const testImagePath = createTestImage();
    
    // Create form data for update
    const formData = new FormData();
    formData.append('id', itemId);
    formData.append('name', 'Updated Test Office Chair with New Image');
    formData.append('category_id', categoryId);
    formData.append('unit', 'pieces');
    formData.append('storage_location', 'Updated Test Warehouse');
    formData.append('notes', 'Updated test ergonomic office chair with new image');
    formData.append('item_image', fs.createReadStream(testImagePath));

    // Update inventory item with new image
    const updateResponse = await axios.post(`${BASE_URL}/items/update`, formData, {
      headers: {
        ...formData.getHeaders()
      }
    });
    
    logTest('Update Inventory Item with New Image', true, updateResponse.data.data);

    // Clean up test image
    fs.unlinkSync(testImagePath);

  } catch (error) {
    logTest('Update Inventory Item with Image Test', false, null, error);
  }
};

// Test Get Inventory Item to verify image URL
const testGetInventoryItem = async () => {
  console.log('\n🧪 Testing Get Inventory Item to verify image URL...');

  try {
    // Get inventory item by ID
    const getByIdResponse = await axios.post(`${BASE_URL}/items/getById`, { id: itemId });
    logTest('Get Inventory Item with Image URL', true, getByIdResponse.data.data);

    // Check if image URL is present
    if (getByIdResponse.data.data.item_image) {
      console.log('   ✅ Image URL found:', getByIdResponse.data.data.item_image);
    } else {
      console.log('   ❌ No image URL found');
    }

  } catch (error) {
    logTest('Get Inventory Item Test', false, null, error);
  }
};

// Test Error Cases
const testErrorCases = async () => {
  console.log('\n🧪 Testing Error Cases...');

  try {
    // Test creating item without required fields
    try {
      const formData = new FormData();
      formData.append('name', 'Test Item');
      // Missing category_id
      
      await axios.post(`${BASE_URL}/items/create`, formData, {
        headers: {
          ...formData.getHeaders()
        }
      });
      logTest('Create Item without Category ID', false, null, { message: 'Should have failed' });
    } catch (error) {
      logTest('Create Item without Category ID', true, null, error);
    }

    // Test uploading invalid file type
    try {
      const formData = new FormData();
      formData.append('name', 'Test Item');
      formData.append('category_id', categoryId);
      formData.append('item_image', Buffer.from('not an image'), {
        filename: 'test.txt',
        contentType: 'text/plain'
      });
      
      await axios.post(`${BASE_URL}/items/create`, formData, {
        headers: {
          ...formData.getHeaders()
        }
      });
      logTest('Upload Invalid File Type', false, null, { message: 'Should have failed' });
    } catch (error) {
      logTest('Upload Invalid File Type', true, null, error);
    }

  } catch (error) {
    logTest('Error Cases Test', false, null, error);
  }
};

// Cleanup function
const cleanup = async () => {
  console.log('\n🧹 Cleaning up test data...');

  try {
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
  console.log('🚀 Starting Inventory Image Upload Tests...\n');

  try {
    await testCategories();
    await testInventoryItemWithImage();
    await testUpdateInventoryItemWithImage();
    await testGetInventoryItem();
    await testErrorCases();

    console.log('\n🎉 All image upload tests completed!');
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
