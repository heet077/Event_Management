import express from 'express';
import * as Gallery from '../controllers/gallery.controller.js';
import upload from '../middlewares/upload.js';
import fs from 'fs';
import path from 'path';

const router = express.Router();

// Simple test route to verify router is working
router.post('/test', (req, res) => {
  res.json({ message: 'Gallery router is working!' });
});





// Upload routes (must come before parameterized routes)
router.post('/design', upload.array('images', 10), async (req, res, next) => {
  try {
    console.log('🎯 POST /design route called');
    console.log('📋 Request body:', req.body);
    console.log('📁 Files uploaded:', req.files ? req.files.length : 0);
    
    const { event_id, notes, image_url } = req.body;
    let uploadedImages = [];

    if (req.files && req.files.length > 0) {
      console.log(`🖼️ Processing ${req.files.length} design images for event ${event_id}`);
      
      try {
        // Create local folder structure for design images
        const eventDir = path.join('uploads', 'events', event_id.toString());
        const designImagesDir = path.join(eventDir, 'design_images');
        
        // Ensure directories exist
        if (!fs.existsSync(eventDir)) {
          fs.mkdirSync(eventDir, { recursive: true });
        }
        if (!fs.existsSync(designImagesDir)) {
          fs.mkdirSync(designImagesDir, { recursive: true });
        }
        
        console.log(`📁 Created local folder structure: ${designImagesDir}`);
        
        // Process each uploaded file
        for (let i = 0; i < req.files.length; i++) {
          const file = req.files[i];
          const filePath = file.path;
          const ext = path.extname(file.originalname);
          const newFileName = `design_images_${i + 1}${ext}`;
          const newPath = path.join(designImagesDir, newFileName);
          
          // Move the file to the design images folder
          fs.renameSync(filePath, newPath);
          console.log(`✅ File moved from ${filePath} to ${newPath}`);
          
          // Generate the local URL for the image
          const localImageUrl = `/uploads/events/${event_id}/design_images/${newFileName}`;
          uploadedImages.push(localImageUrl);
        }
      } catch (error) {
        console.error('❌ Local storage error:', error);
        // Clean up all uploaded files if local storage failed
        for (const file of req.files) {
          if (fs.existsSync(file.path)) {
            fs.unlinkSync(file.path);
          }
        }
        return res.status(500).json({ 
          message: 'Failed to store images locally', 
          error: error.message 
        });
      }
    } else if (image_url) {
      console.log(`🖼️ Processing image URL for event ${event_id}`);
      // For now, just use the original URL directly
      uploadedImages.push(image_url);
      console.log(`✅ Using original image URL: ${image_url}`);
    } else {
      console.log('❌ No file uploaded and no image_url provided');
    }

    // Handle multiple uploaded images or single image URL
    const imagesToSave = uploadedImages.length > 0 ? uploadedImages : (image_url ? [image_url] : []);
    
    if (imagesToSave.length === 0) {
      return res.status(400).json({ message: 'Image files or image_url is required' });
    }

    console.log(`💾 Saving ${imagesToSave.length} images to database`);
    const savedImages = [];
    
    for (const imageUrl of imagesToSave) {
      const saved = await Gallery.uploadDesign({
        event_id,
        image_url: imageUrl,
        notes
      });
      savedImages.push(saved);
    }

    console.log('✅ Database save successful:', savedImages);
    res.status(201).json({
      success: true,
      message: `Successfully uploaded ${savedImages.length} design images`,
      data: savedImages,
      count: savedImages.length
    });
  } catch (err) {
    console.error('❌ Gallery route error:', err);
    next(err);
  }
});

router.post('/final', upload.array('images', 10), async (req, res, next) => {
  try {
    console.log('🎯 POST /final route called');
    console.log('📋 Request body:', req.body);
    console.log('📁 Files uploaded:', req.files ? req.files.length : 0);
    
    const { event_id, description, image_url } = req.body;
    let uploadedImages = [];

    if (req.files && req.files.length > 0) {
      console.log(`🖼️ Processing ${req.files.length} final images for event ${event_id}`);

      try {
        // Create local folder structure for final images
        const eventDir = path.join('uploads', 'events', event_id.toString());
        const finalImagesDir = path.join(eventDir, 'final_images');
        
        // Ensure directories exist
        if (!fs.existsSync(eventDir)) {
          fs.mkdirSync(eventDir, { recursive: true });
        }
        if (!fs.existsSync(finalImagesDir)) {
          fs.mkdirSync(finalImagesDir, { recursive: true });
        }
        
        console.log(`📁 Created local folder structure: ${finalImagesDir}`);
        
        // Process each uploaded file
        for (let i = 0; i < req.files.length; i++) {
          const file = req.files[i];
          const filePath = file.path;
          const ext = path.extname(file.originalname);
          const newFileName = `final_images_${i + 1}${ext}`;
          const newPath = path.join(finalImagesDir, newFileName);
          
          // Move the file to the final images folder
          fs.renameSync(filePath, newPath);
          console.log(`✅ File moved from ${filePath} to ${newPath}`);
          
          // Generate the local URL for the image
          const localImageUrl = `/uploads/events/${event_id}/final_images/${newFileName}`;
          uploadedImages.push(localImageUrl);
        }
      } catch (error) {
        console.error('❌ Local storage error:', error);
        // Clean up all uploaded files if local storage failed
        for (const file of req.files) {
          if (fs.existsSync(file.path)) {
            fs.unlinkSync(file.path);
          }
        }
        return res.status(500).json({ 
          message: 'Failed to store images locally', 
          error: error.message 
        });
      }
    } else if (image_url) {
      console.log(`🖼️ Processing image URL for event ${event_id}`);
      // For now, just use the original URL directly
      uploadedImages.push(image_url);
      console.log(`✅ Using original image URL: ${image_url}`);
    } else {
      console.log('❌ No file uploaded and no image_url provided');
    }

    // Handle multiple uploaded images or single image URL
    const imagesToSave = uploadedImages.length > 0 ? uploadedImages : (image_url ? [image_url] : []);
    
    if (imagesToSave.length === 0) {
      return res.status(400).json({ message: 'Image files or image_url is required' });
    }

    console.log(`💾 Saving ${imagesToSave.length} images to database`);
    const savedImages = [];
    
    for (const imageUrl of imagesToSave) {
      const saved = await Gallery.uploadFinal({
        event_id,
        image_url: imageUrl,
        description
      });
      savedImages.push(saved);
    }

    console.log('✅ Database save successful:', savedImages);
    res.status(201).json({
      success: true,
      message: `Successfully uploaded ${savedImages.length} final images`,
      data: savedImages,
      count: savedImages.length
    });
  } catch (err) {
    console.error('❌ Gallery route error:', err);
    next(err);
  }
});





// Parameterized route (must come last)
router.post('/getEventImages', Gallery.getEventImages);

export default router;
