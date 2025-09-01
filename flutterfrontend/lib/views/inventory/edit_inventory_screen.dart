import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../providers/inventory_provider.dart';

class EditInventoryPage extends ConsumerStatefulWidget {
  final String itemId;
  const EditInventoryPage({super.key, required this.itemId});

  @override
  ConsumerState<EditInventoryPage> createState() => _EditInventoryPageState();
}

class _EditInventoryPageState extends ConsumerState<EditInventoryPage> {
  final nameCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final materialCtrl = TextEditingController();
  final quantityCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final item = ref.read(inventoryProvider).firstWhere((i) => i.id == widget.itemId);
    nameCtrl.text = item.name;
    categoryCtrl.text = item.category;
    materialCtrl.text = item.material;
    quantityCtrl.text = item.quantity.toString();
    locationCtrl.text = item.location;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Inventory', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Main card like Add Year form
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  spreadRadius: 0,
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.edit, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Text('Update Inventory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _formField('Name', nameCtrl, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                  _formField('Category', categoryCtrl, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                  _formField('Material', materialCtrl, validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null),
                  _formField('Quantity', quantityCtrl, isNumber: true, validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 0) return 'Enter valid quantity';
                    return null;
                  }),
                  _formField('Location', locationCtrl),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  _save();
                }
              },
              icon: const Icon(Icons.save),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              label: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formField(String label, TextEditingController c, {bool isNumber = false, String? Function(String?)? validator}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextFormField(
        controller: c,
        validator: validator,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _save() {
    final qty = int.tryParse(quantityCtrl.text.trim());
    if (nameCtrl.text.trim().isEmpty || categoryCtrl.text.trim().isEmpty || materialCtrl.text.trim().isEmpty || qty == null || qty < 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill valid values'), backgroundColor: Colors.red));
      return;
    }

    final current = ref.read(inventoryProvider).firstWhere((i) => i.id == widget.itemId);
    final updated = current.copyWith(
      name: nameCtrl.text.trim(),
      category: categoryCtrl.text.trim(),
      material: materialCtrl.text.trim(),
      quantity: qty,
      location: locationCtrl.text.trim(),
      lastUpdated: DateTime.now().toString().split(' ')[0],
      status: qty > 5 ? 'In Stock' : (qty == 0 ? 'Out of Stock' : 'Low Stock'),
    );
    ref.read(inventoryProvider.notifier).updateItem(updated.id, updated);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inventory updated'), backgroundColor: Colors.green));
  }
}


