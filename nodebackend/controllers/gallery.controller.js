import * as Gallery from '../models/gallery.model.js';

export const uploadDesign = async ({ event_id, image_url, notes }) => {
  return await Gallery.uploadDesignImage({ event_id, image_url, notes });
};

export const uploadFinal = async ({ event_id, image_url, description }) => {
  return await Gallery.uploadFinalImage({ event_id, image_url, description });
};

export const getEventImages = async (req, res, next) => {
  try {
    const data = await Gallery.getImagesByEvent(req.params.event_id);
    res.json(data);
  } catch (err) {
    next(err);
  }
};
