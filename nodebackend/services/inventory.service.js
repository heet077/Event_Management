import * as MaterialInventory from '../models/materialInventory.model.js';
import * as ToolInventory from '../models/toolInventory.model.js';

export const deductMaterialStock = async (item_id, qty) => {
  const inventory = await MaterialInventory.getInventoryByItemId(item_id);
  if (!inventory) throw new Error('Material inventory not found');

  const updatedQty = parseFloat(inventory.quantity_available) - parseFloat(qty);
  if (updatedQty < 0) throw new Error('Insufficient stock');

  return await MaterialInventory.updateInventoryQuantity(item_id, updatedQty);
};

export const deductToolStock = async (tool_id, qty) => {
  const inventory = await ToolInventory.getToolInventoryByToolId(tool_id);
  if (!inventory) throw new Error('Tool inventory not found');

  const updatedQty = parseFloat(inventory.quantity_available) - parseFloat(qty);
  if (updatedQty < 0) throw new Error('Insufficient tool stock');

  return await ToolInventory.adjustToolQuantity(tool_id, -qty);
};
