import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_inventory_screen.dart';
import '../../themes/app_theme.dart'; // Import your AppTheme file
import '../../providers/category_provider.dart';
import '../../models/category_model.dart';
import '../../providers/inventory_provider.dart';
import 'package:file_picker/file_picker.dart';

class InventoryFormPage extends ConsumerStatefulWidget {
  const InventoryFormPage({super.key});

  @override
  ConsumerState<InventoryFormPage> createState() => _InventoryFormPageState();
}

class _InventoryFormPageState extends ConsumerState<InventoryFormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(inventoryFormNotifierProvider);
    final categories = ref.watch(categoryProvider);
    final categoryNotifier = ref.watch(categoryProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Inventory Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Selection Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.category_outlined,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Select Category',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 130,
                    child: categoryNotifier.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : categoryNotifier.error != null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      color: Colors.red[300],
                                      size: 32,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Error loading categories',
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    TextButton(
                                      onPressed: () =>
                                          categoryNotifier.refreshCategories(),
                                      child: const Text('Retry',
                                          style: TextStyle(fontSize: 10)),
                                    ),
                                  ],
                                ),
                              )
                            : categories.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No categories available',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: categories.length,
                                    itemBuilder: (context, index) {
                                      final category = categories[index];
                                      final isSelected =
                                          formState.selectedCategory?.id ==
                                              category.id;

                                      return GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(
                                                  inventoryFormNotifierProvider
                                                      .notifier)
                                              .selectCategory(category);
                                        },
                                        child: Container(
                                          width: 110,
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.secondary,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isSelected
                                                  ? AppColors.primary
                                                  : AppColors.chartDivider,
                                              width: isSelected ? 2 : 1.5,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: isSelected
                                                    ? AppColors.primary
                                                        .withOpacity(0.3)
                                                    : Colors.black
                                                        .withOpacity(0.06),
                                                spreadRadius: 0,
                                                blurRadius:
                                                    isSelected ? 20 : 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                _getCategoryIcon(category.name),
                                                style: const TextStyle(
                                                    fontSize: 36),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                category.name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : AppColors.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                  ),
                ],
              ),
            ),

            // Form Section
            if (formState.selectedCategory != null)
              _buildForm(formState.selectedCategory!)
            else
              _buildPlaceholder(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Select a category to start',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Choose from the categories above to fill out the inventory form',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForm(CategoryModel category) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(28),
      constraints: const BoxConstraints(maxHeight: double.infinity),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      _getCategoryIcon(category.name),
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Dynamic form fields based on category
              ..._buildCategoryFields(category),

              const SizedBox(height: 36),

              // Location field (optional)
              _buildTextField(
                label: 'Location (optional)',
                onChanged: (value) {
                  ref
                      .read(inventoryFormNotifierProvider.notifier)
                      .setLocation(value);
                },
              ),

              const SizedBox(height: 24),

              // Image picker
              _buildImagePicker(),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _submitForm(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    shadowColor: AppColors.primary.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.save_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Submit Inventory',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Category field builders (unchanged except colors in TextFields/Dropdowns)
  // Example for one:

  Widget _buildTextField({
    required String label,
    String? value,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.chartDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.chartDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // Inside _InventoryFormPageState

  List<Widget> _buildCategoryFields(CategoryModel category) {
    switch (category.name.toLowerCase()) {
      case 'furniture':
        return [
          _buildTextField(
              label: "Furniture Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Dimensions (e.g., 45cm x 45cm x 90cm)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(dimensions: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Unit (e.g., piece, set)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(unit: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Notes",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(notes: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Storage Location",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(storageLocation: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity Available",
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(quantity: int.tryParse(value));
              }),
        ];

      case 'fabric':
      case 'fabrics':
        return [
          _buildTextField(
              label: "Fabric Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Fabric Type",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(type: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Pattern",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(pattern: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Width",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(width: double.tryParse(value));
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Length",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(length: double.tryParse(value));
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Color",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(color: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Unit (e.g., meter, yard)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(unit: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Storage Location",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(storageLocation: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Notes",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(notes: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity Available",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(stock: double.tryParse(value));
              }),
        ];

      case 'frame structure':
      case 'frame structures':
        return [
          _buildTextField(
              label: "Frame Structure Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Unit (e.g., piece, set)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(unit: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Storage Location",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(storageLocation: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Notes",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(notes: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Frame Type",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(type: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Dimensions (e.g., 3.5m x 2.8m x 0.6m)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(dimensions: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity Available",
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(quantity: int.tryParse(value));
              }),
        ];

      case 'carpet':
      case 'carpets':
        return [
          _buildTextField(
              label: "Carpet Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Unit (e.g., piece, meter)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(unit: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Storage Location",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(storageLocation: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Notes",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(notes: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Carpet Type",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(type: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Size (e.g., 4m x 3m)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(size: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity Available",
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(stock: int.tryParse(value));
              }),
        ];

      case 'thermocol':
      case 'thermocol material':
      case 'thermocol materials':
        return [
          _buildTextField(
              label: "Thermocol Material Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Unit (e.g., set, piece)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(unit: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Storage Location",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(storageLocation: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Notes",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(notes: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Thermocol Type",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(thermocolType: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Dimensions (e.g., 70cm x 50cm x 12cm)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(dimensions: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Density",
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(density: double.tryParse(value));
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity Available",
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(quantity: int.tryParse(value));
              }),
        ];

      case 'stationery':
        return [
          _buildTextField(
              label: "Stationery Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Unit (e.g., piece, set)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(unit: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Storage Location",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(storageLocation: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Notes",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(notes: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Specifications",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(specifications: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity Available",
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(quantity: int.tryParse(value));
              }),
        ];

      case 'murti set':
      case 'murti sets':
        return [
          _buildTextField(
              label: "Murti Set Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Unit (e.g., set, piece)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(unit: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Storage Location",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(storageLocation: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Notes",
              maxLines: 3,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(notes: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Set Number",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(setNumber: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Dimensions (e.g., 8inch x 12inch)",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(dimensions: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity Available",
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(quantity: int.tryParse(value));
              }),
        ];

      default:
        // For any other category, use furniture fields as default
        return [
          _buildTextField(
              label: "Item Name",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity",
              keyboardType: TextInputType.number,
              onChanged: (value) {
                ref
                    .read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(quantity: int.tryParse(value));
              }),
        ];
    }
  }

  // Helper method to get category icon
  String _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'furniture':
        return '🪑';
      case 'fabric':
      case 'fabrics':
        return '🧵';
      case 'frame structure':
        return '🖼';
      case 'carpet':
        return '🟫';
      case 'thermocol':
      case 'thermocol material':
        return '📦';
      case 'stationery':
        return '✏';
      case 'murti set':
        return '🙏';
      default:
        return '📦'; // Default icon
    }
  }

  Widget _buildImagePicker() {
    final formState = ref.watch(inventoryFormNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attach Image (optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.image,
                  allowMultiple: false,
                  withData: false, // Don't load bytes, just get file path
                  allowCompression: false, // Don't compress the image
                );
                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);
                  print(
                      '🔍 Debug: Selected file path: ${result.files.single.path}');
                  print('🔍 Debug: File name: ${result.files.single.name}');
                  print('🔍 Debug: File exists: ${await file.exists()}');

                  if (await file.exists()) {
                    // Read bytes from the file
                    final bytes = await file.readAsBytes();
                    print('🔍 Debug: File size: ${bytes.length} bytes');
                    ref.read(inventoryFormNotifierProvider.notifier).setImage(
                          bytes: bytes,
                          name: result.files.single.name,
                          path: result.files.single.path,
                        );
                    print(
                        '✅ Image selected and stored: ${result.files.single.path}');
                  } else {
                    print(
                        '❌ Selected file does not exist: ${result.files.single.path}');
                    // Try to get bytes directly as fallback
                    if (result.files.single.bytes != null) {
                      print('🔍 Debug: Using bytes directly as fallback');
                      ref.read(inventoryFormNotifierProvider.notifier).setImage(
                            bytes: result.files.single.bytes!,
                            name: result.files.single.name,
                            path: null, // No path available
                          );
                      print('✅ Image selected using bytes fallback');
                    } else {
                      print('❌ No bytes available either');
                    }
                  }
                } else {
                  print('❌ No file selected or path is null');
                }
              },
              icon: const Icon(Icons.attach_file),
              label: const Text('Choose Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            if (formState.imageName != null)
              Expanded(
                child: Text(
                  formState.imageName!,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.black87),
                ),
              ),
            if (formState.imageBytes != null)
              IconButton(
                tooltip: 'Remove',
                onPressed: () {
                  ref.read(inventoryFormNotifierProvider.notifier).clearImage();
                },
                icon: const Icon(Icons.close, color: Colors.redAccent),
              ),
          ],
        ),
        if (formState.imageBytes != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(
              formState.imageBytes!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }

  void _submitForm() async {
    print('Form submission started');
    if (_formKey.currentState!.validate()) {
      print('Form validation passed');
      final notifier = ref.read(inventoryFormNotifierProvider.notifier);

      if (notifier.validateForm()) {
        print('Business validation passed');
        // Prepare data for API
        final formData = _prepareFormData();
        print('Form data prepared: $formData');
        print('🔍 Debug: Image path in form data: ${formData['imagePath']}');

        try {
          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          // Check if this is a furniture, fabric, carpet, or frame structures category and use appropriate API
          final category =
              ref.read(inventoryFormNotifierProvider).selectedCategory;
          if (category?.name.toLowerCase() == 'furniture') {
            // Use furniture-specific API
            await ref.read(inventoryProvider.notifier).createFurnitureItem(
                  name: formData['name'],
                  material: formData['material'],
                  dimensions: formData['dimensions'],
                  unit: formData['unit'],
                  notes: formData['notes'],
                  storageLocation: formData['storage_location'],
                  quantityAvailable: formData['quantity_available'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                );
          } else if (category?.name.toLowerCase() == 'fabric' ||
              category?.name.toLowerCase() == 'fabrics') {
            // Use fabric-specific API
            await ref.read(inventoryProvider.notifier).createFabricItem(
                  name: formData['name'],
                  fabricType: formData['fabric_type'],
                  pattern: formData['pattern'],
                  width: formData['width'],
                  length: formData['length'],
                  color: formData['color'],
                  unit: formData['unit'],
                  storageLocation: formData['storage_location'],
                  notes: formData['notes'],
                  quantityAvailable: formData['quantity_available'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                );
          } else if (category?.name.toLowerCase() == 'carpet' ||
              category?.name.toLowerCase() == 'carpets') {
            // Use carpet-specific API
            await ref.read(inventoryProvider.notifier).createCarpetItem(
                  name: formData['name'],
                  unit: formData['unit'],
                  storageLocation: formData['storage_location'],
                  notes: formData['notes'],
                  quantityAvailable: formData['quantity_available'],
                  carpetType: formData['carpet_type'],
                  material: formData['material'],
                  size: formData['size'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                );
          } else if (category?.name.toLowerCase() == 'frame structure' ||
              category?.name.toLowerCase() == 'frame structures') {
            // Use frame structures-specific API
            await ref.read(inventoryProvider.notifier).createFrameStructureItem(
                  name: formData['name'],
                  unit: formData['unit'],
                  storageLocation: formData['storage_location'],
                  notes: formData['notes'],
                  quantityAvailable: formData['quantity_available'],
                  frameType: formData['frame_type'],
                  material: formData['material'],
                  dimensions: formData['dimensions'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                );
          } else if (category?.name.toLowerCase() == 'murti set' ||
              category?.name.toLowerCase() == 'murti sets') {
            // Use murti sets-specific API
            await ref.read(inventoryProvider.notifier).createMurtiSetsItem(
                  name: formData['name'],
                  unit: formData['unit'],
                  storageLocation: formData['storage_location'],
                  notes: formData['notes'],
                  quantityAvailable: formData['quantity_available'],
                  setNumber: formData['set_number'],
                  material: formData['material'],
                  dimensions: formData['dimensions'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                );
          } else if (category?.name.toLowerCase() == 'thermocol' ||
              category?.name.toLowerCase() == 'thermocol material' ||
              category?.name.toLowerCase() == 'thermocol materials') {
            // Use thermocol materials-specific API
            await ref
                .read(inventoryProvider.notifier)
                .createThermocolMaterialsItem(
                  name: formData['name'],
                  unit: formData['unit'],
                  storageLocation: formData['storage_location'],
                  notes: formData['notes'],
                  quantityAvailable: formData['quantity_available'],
                  thermocolType: formData['thermocol_type'],
                  dimensions: formData['dimensions'],
                  density: formData['density'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                );
          } else if (category?.name.toLowerCase() == 'stationery') {
            // Use stationery-specific API
            await ref.read(inventoryProvider.notifier).createStationeryItem(
                  name: formData['name'],
                  unit: formData['unit'],
                  storageLocation: formData['storage_location'],
                  notes: formData['notes'],
                  quantityAvailable: formData['quantity_available'],
                  specifications: formData['specifications'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                );
          } else {
            // Use general inventory API for other categories
            await ref.read(inventoryProvider.notifier).createItem(
                  name: formData['name'],
                  categoryId: category?.id ?? 1,
                  unit: formData['unit'],
                  storageLocation: formData['storage_location'],
                  notes: formData['notes'],
                  quantityAvailable: formData['quantity_available'],
                  itemImagePath: formData['imagePath'],
                  itemImageBytes: formData['imageBytes'],
                  itemImageName: formData['imageName'],
                  categoryDetails: formData['category_details'],
                );
          }

          // Close loading dialog
          Navigator.of(context).pop();

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Inventory item created successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Reset form
          ref.read(inventoryFormNotifierProvider.notifier).resetForm();

          // Navigate back
          Navigator.of(context).pop();
        } catch (e) {
          // Close loading dialog
          Navigator.of(context).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error creating item: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print('Business validation failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please fill in all required fields'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } else {
      print('Form validation failed');
    }
  }

  Map<String, dynamic> _prepareFormData() {
    final formState = ref.read(inventoryFormNotifierProvider);
    final category = formState.selectedCategory;

    Map<String, dynamic> data = {
      'name': '',
      'category_id': category?.id ?? 1,
      'unit': 'piece', // Default unit
      'storage_location': formState.location ?? 'Unknown',
      'notes': '',
      'quantity_available': 0.0,
      'category_details': {},
      'imagePath': formState.imagePath,
      'imageBytes': formState.imageBytes,
      'imageName': formState.imageName,
    };

    switch (category?.name.toLowerCase()) {
      case 'furniture':
        data['name'] = formState.furniture.name ?? 'Unknown';
        data['material'] = formState.furniture.material ?? 'Unknown';
        data['dimensions'] = formState.furniture.dimensions ?? 'Unknown';
        data['unit'] = formState.furniture.unit ?? 'piece';
        data['notes'] = formState.furniture.notes ?? 'Furniture item';
        data['storage_location'] =
            formState.furniture.storageLocation ?? 'Unknown';
        data['quantity_available'] =
            (formState.furniture.quantity ?? 1).toDouble();
        // Also keep category_details for general API compatibility
        data['category_details'] = {
          'material': formState.furniture.material ?? 'Unknown',
          'dimensions': formState.furniture.dimensions ?? 'Unknown',
        };
        break;
      case 'fabric':
      case 'fabrics':
        data['name'] = formState.fabric.name ?? 'Unknown';
        data['fabric_type'] = formState.fabric.type ?? 'Unknown';
        data['pattern'] = formState.fabric.pattern ?? 'Unknown';
        data['width'] = formState.fabric.width ?? 0.0;
        data['length'] = formState.fabric.length ?? 0.0;
        data['color'] = formState.fabric.color ?? 'Unknown';
        data['unit'] = formState.fabric.unit ?? 'meter';
        data['storage_location'] =
            formState.fabric.storageLocation ?? 'Unknown';
        data['notes'] = formState.fabric.notes ?? 'Fabric item';
        data['quantity_available'] = formState.fabric.stock ?? 0.0;
        // Also keep category_details for general API compatibility
        data['category_details'] = {
          'fabric_type': formState.fabric.type ?? 'Unknown',
          'pattern': formState.fabric.pattern ?? 'Unknown',
          'width': formState.fabric.width ?? 0.0,
          'length': formState.fabric.length ?? 0.0,
          'color': formState.fabric.color ?? 'Unknown',
        };
        break;
      case 'frame structure':
      case 'frame structures':
        data['name'] = formState.frame.name ?? 'Unknown';
        data['unit'] = formState.frame.unit ?? 'piece';
        data['storage_location'] = formState.frame.storageLocation ?? 'Unknown';
        data['notes'] = formState.frame.notes ?? 'Frame structure';
        data['quantity_available'] = (formState.frame.quantity ?? 1).toDouble();
        // For frame structure API, we need these fields directly in the main data
        data['frame_type'] = formState.frame.type ?? 'Unknown';
        data['material'] = formState.frame.material ?? 'Unknown';
        data['dimensions'] = formState.frame.dimensions ?? 'Unknown';
        // Also keep category_details for general API compatibility
        data['category_details'] = {
          'frame_type': formState.frame.type ?? 'Unknown',
          'material': formState.frame.material ?? 'Unknown',
          'dimensions': formState.frame.dimensions ?? 'Unknown',
        };
        break;
      case 'carpet':
      case 'carpets':
        data['name'] = formState.carpet.name ?? 'Unknown';
        data['unit'] = formState.carpet.unit ?? 'piece';
        data['storage_location'] =
            formState.carpet.storageLocation ?? 'Unknown';
        data['notes'] = formState.carpet.notes ?? 'Carpet item';
        data['quantity_available'] = (formState.carpet.stock ?? 1).toDouble();
        // For carpet API, we need these fields directly in the main data
        data['carpet_type'] = formState.carpet.type ?? 'Unknown';
        data['material'] = formState.carpet.material ?? 'Unknown';
        data['size'] = formState.carpet.size ?? 'Unknown';
        // Also keep category_details for general API compatibility
        data['category_details'] = {
          'carpet_type': formState.carpet.type ?? 'Unknown',
          'material': formState.carpet.material ?? 'Unknown',
          'size': formState.carpet.size ?? 'Unknown',
        };
        break;
      case 'thermocol':
      case 'thermocol material':
      case 'thermocol materials':
        data['name'] = formState.thermocol.name ?? 'Unknown';
        data['unit'] = formState.thermocol.unit ?? 'set';
        data['storage_location'] =
            formState.thermocol.storageLocation ?? 'Unknown';
        data['notes'] = formState.thermocol.notes ?? 'Thermocol material';
        data['quantity_available'] =
            (formState.thermocol.quantity ?? 1).toDouble();
        data['thermocol_type'] = formState.thermocol.thermocolType ?? 'Unknown';
        data['dimensions'] = formState.thermocol.dimensions ?? 'Unknown';
        data['density'] = formState.thermocol.density ?? 1.0;
        // Also keep category_details for general API compatibility
        data['category_details'] = {
          'thermocol_type': formState.thermocol.thermocolType ?? 'Unknown',
          'dimensions': formState.thermocol.dimensions ?? 'Unknown',
          'density': '${formState.thermocol.density ?? 1.0}',
        };
        break;
      case 'stationery':
        data['name'] = formState.stationery.name ?? 'Unknown';
        data['unit'] = formState.stationery.unit ?? 'piece';
        data['storage_location'] =
            formState.stationery.storageLocation ?? 'Unknown';
        data['notes'] = formState.stationery.notes ?? 'Stationery item';
        data['quantity_available'] =
            (formState.stationery.quantity ?? 1).toDouble();
        data['specifications'] =
            formState.stationery.specifications ?? 'Unknown';
        // Also keep category_details for general API compatibility
        data['category_details'] = {
          'specifications': formState.stationery.specifications ?? 'Unknown',
        };
        break;
      case 'murti set':
      case 'murti sets':
        data['name'] = formState.murti.name ?? 'Unknown';
        data['unit'] = formState.murti.unit ?? 'set';
        data['storage_location'] = formState.murti.storageLocation ?? 'Unknown';
        data['notes'] = formState.murti.notes ?? 'Murti set';
        data['quantity_available'] = (formState.murti.quantity ?? 1).toDouble();
        data['set_number'] = formState.murti.setNumber ?? '1';
        data['material'] = formState.murti.material ?? 'Unknown';
        data['dimensions'] = formState.murti.dimensions ?? 'Unknown';
        // Also keep category_details for general API compatibility
        data['category_details'] = {
          'set_number': formState.murti.setNumber ?? '1',
          'material': formState.murti.material ?? 'Unknown',
          'dimensions': formState.murti.dimensions ?? 'Unknown',
        };
        break;
      default:
        data['name'] = formState.furniture.name ?? 'Unknown';
        data['unit'] = 'piece';
        data['notes'] = 'Item';
        data['quantity_available'] =
            (formState.furniture.quantity ?? 1).toDouble();
        data['category_details'] = {
          'material': formState.furniture.material ?? 'Unknown',
          'dimensions': formState.furniture.dimensions ?? 'Unknown',
        };
        break;
    }

    return data;
  }
}
