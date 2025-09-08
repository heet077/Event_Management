import * as Gallery from '../models/gallery.model.js';

export const uploadDesign = async ({ event_id, image_url, notes }) => {
  return await Gallery.uploadDesignImage({ event_id, image_url, notes });
};

export const uploadFinal = async ({ event_id, image_url, description }) => {
  return await Gallery.uploadFinalImage({ event_id, image_url, description });
};

export const getEventImages = async (req, res, next) => {
  try {
    const { event_id } = req.body;
    
    if (!event_id) {
      return res.status(400).json({
        success: false,
        error: 'Event ID is required in request body'
      });
    }

    const data = await Gallery.getImagesByEvent(event_id);
    
    res.json({
      success: true,
      message: 'Event images retrieved successfully',
      data: {
        event_id: parseInt(event_id),
        design_images: data.design,
        final_images: data.final,
        design_count: data.design.length,
        final_count: data.final.length,
        total_images: data.design.length + data.final.length
      }
    });
  } catch (err) {
    console.error('Error fetching event images:', err);
    res.status(500).json({
      success: false,
      error: 'Error fetching event images'
    });
  }
};
