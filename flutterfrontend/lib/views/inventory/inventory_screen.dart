import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'add_inventory_screen.dart';
import '../../themes/app_theme.dart'; // Import your AppTheme file
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: InventoryCategory.values.length,
                      itemBuilder: (context, index) {
                        final category = InventoryCategory.values[index];
                        final isSelected = formState.selectedCategory == category;

                        return GestureDetector(
                          onTap: () {
                            ref.read(inventoryFormNotifierProvider.notifier)
                                .selectCategory(category);
                          },
                          child: Container(
                            width: 110,
                            margin: const EdgeInsets.only(right: 16),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.secondary,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.chartDivider,
                                width: isSelected ? 2 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected
                                      ? AppColors.primary.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.06),
                                  spreadRadius: 0,
                                  blurRadius: isSelected ? 20 : 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  category.icon,
                                  style: const TextStyle(fontSize: 36),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  category.displayName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.primary,
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

  Widget _buildForm(InventoryCategory category) {
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
                      category.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        category.displayName,
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
  }) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      validator: validator,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  // Inside _InventoryFormPageState

  List<Widget> _buildCategoryFields(InventoryCategory category) {
    switch (category) {
      case InventoryCategory.furniture:
        return [
          _buildTextField(
              label: "Furniture Name",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFurnitureData(quantity: int.tryParse(value));
              }),
        ];

      case InventoryCategory.fabric:
        return [
          _buildTextField(
              label: "Fabric Type",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(type: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Pattern",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(pattern: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Color",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFabricData(color: value);
              }),
        ];

      case InventoryCategory.frameStructure:
        return [
          _buildTextField(
              label: "Frame Type",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(type: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Dimensions",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateFrameData(dimensions: value);
              }),
        ];

      case InventoryCategory.carpet:
        return [
          _buildTextField(
              label: "Carpet Type",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(type: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Size",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateCarpetData(size: value);
              }),
        ];

      case InventoryCategory.thermocol:
        return [
          _buildTextField(
              label: "Type",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(type: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Dimensions",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(dimensions: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Density",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateThermocolData(density: double.tryParse(value));
              }),
        ];

      case InventoryCategory.stationery:
        return [
          _buildTextField(
              label: "Stationery Name",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(name: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Category",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(category: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Quantity",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateStationeryData(quantity: int.tryParse(value));
              }),
        ];

      case InventoryCategory.murtiSet:
        return [
          _buildTextField(
              label: "Deity",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(deity: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Material",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(material: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Dimensions",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(dimensions: value);
              }),
          const SizedBox(height: 16),
          _buildTextField(
              label: "Weight",
              onChanged: (value) {
                ref.read(inventoryFormNotifierProvider.notifier)
                    .updateMurtiData(weight: double.tryParse(value));
              }),
        ];
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
                  withData: true,
                );
                if (result != null && result.files.single.bytes != null) {
                  ref
                      .read(inventoryFormNotifierProvider.notifier)
                      .setImage(
                        bytes: result.files.single.bytes!,
                        name: result.files.single.name,
                      );
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
                  ref
                      .read(inventoryFormNotifierProvider.notifier)
                      .clearImage();
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



  void _submitForm() {
    print('Form submission started');
    if (_formKey.currentState!.validate()) {
      print('Form validation passed');
      final notifier = ref.read(inventoryFormNotifierProvider.notifier);

      if (notifier.validateForm()) {
        print('Business validation passed');
        // Prepare data to return
        final formData = _prepareFormData();
        print('Form data prepared: $formData');
        
        // Navigate back with the form data
        Navigator.pop(context, formData);
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
      'category': category?.displayName ?? 'Unknown',
      'location': formState.location ?? 'Unknown',
      'imageBytes': formState.imageBytes,
      'imageName': formState.imageName,
    };

    switch (category) {
      case InventoryCategory.furniture:
        data.addAll({
          'name': formState.furniture.name ?? 'Unknown',
          'material': formState.furniture.material ?? 'Unknown',
          'quantity': formState.furniture.quantity ?? 1,
        });
        break;
      case InventoryCategory.fabric:
        data.addAll({
          'name': formState.fabric.type ?? 'Unknown',
          'material': formState.fabric.pattern ?? 'Unknown',
          'quantity': formState.fabric.stock ?? 1,
        });
        break;
      case InventoryCategory.frameStructure:
        data.addAll({
          'name': formState.frame.type ?? 'Unknown',
          'material': formState.frame.material ?? 'Unknown',
          'quantity': formState.frame.quantity ?? 1,
        });
        break;
      case InventoryCategory.carpet:
        data.addAll({
          'name': formState.carpet.type ?? 'Unknown',
          'material': formState.carpet.material ?? 'Unknown',
          'quantity': formState.carpet.stock ?? 1,
        });
        break;
      case InventoryCategory.thermocol:
        data.addAll({
          'name': formState.thermocol.type ?? 'Unknown',
          'material': 'Thermocol',
          'quantity': formState.thermocol.stock ?? 1,
        });
        break;
      case InventoryCategory.stationery:
        data.addAll({
          'name': formState.stationery.name ?? 'Unknown',
          'material': formState.stationery.category ?? 'Unknown',
          'quantity': formState.stationery.quantity ?? 1,
        });
        break;
      case InventoryCategory.murtiSet:
        data.addAll({
          'name': formState.murti.deity ?? 'Unknown',
          'material': formState.murti.material ?? 'Unknown',
          'quantity': formState.murti.quantity ?? 1,
        });
        break;
      case null:
        data.addAll({
          'name': 'Unknown',
          'material': 'Unknown',
          'quantity': 1,
        });
        break;
    }

    return data;
  }
}
