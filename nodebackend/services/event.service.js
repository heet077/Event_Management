import * as Event from '../models/event.model.js';
import * as Issuance from '../models/issuance.model.js';
import { deductMaterialStock } from './inventory.service.js';

export const createEventWithIssuance = async (eventData, materials = []) => {
  const newEvent = await Event.createEvent(eventData);

  for (const item of materials) {
    await Issuance.issueMaterial({
      event_id: newEvent.id,
      item_id: item.item_id,
      quantity_issued: item.quantity_issued,
      notes: item.notes || ''
    });

    await deductMaterialStock(item.item_id, item.quantity_issued);
  }

  return newEvent;
};
