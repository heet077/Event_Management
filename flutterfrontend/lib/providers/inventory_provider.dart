import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import '../services/inventory_service.dart';
import '../utils/constants.dart';

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String categoryName;
  final String unit;
  final String storageLocation;
  final String notes;
  final double availableQuantity;
  final String? material;
  final String? createdAt;
  final String? itemImage;
  final String? status;
  final Uint8List? imageBytes;
  final String? imageName;

  // Category-specific fields
  final String? dimensions;
  final String? fabricType;
  final String? pattern;
  final double? width;
  final double? length;
  final String? color;
  final String? carpetType;
  final String? size;
  final String? frameType;
  final String? setNumber;
  final String? specifications;
  final String? thermocolType;
  final double? density;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryName,
    required this.unit,
    required this.storageLocation,
    required this.notes,
    required this.availableQuantity,
    this.material,
    this.createdAt,
    this.itemImage,
    this.status,
    this.imageBytes,
    this.imageName,
    this.dimensions,
    this.fabricType,
    this.pattern,
    this.width,
    this.length,
    this.color,
    this.carpetType,
    this.size,
    this.frameType,
    this.setNumber,
    this.specifications,
    this.thermocolType,
    this.density,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'categoryName': categoryName,
      'unit': unit,
      'storageLocation': storageLocation,
      'notes': notes,
      'availableQuantity': availableQuantity,
      'material': material,
      'createdAt': createdAt,
      'itemImage': itemImage,
      'status': status,
      'imageBytes': imageBytes,
      'imageName': imageName,
      'dimensions': dimensions,
      'fabricType': fabricType,
      'pattern': pattern,
      'width': width,
      'length': length,
      'color': color,
      'carpetType': carpetType,
      'size': size,
      'frameType': frameType,
      'setNumber': setNumber,
      'specifications': specifications,
      'thermocolType': thermocolType,
      'density': density,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    // Extract category-specific details based on category name
    final categoryName = map['category_name']?.toString().toLowerCase() ?? '';
    Map<String, dynamic>? categoryDetails;

    print('🔍 Parsing item: ${map['name']} (Category: $categoryName)');

    // Get the appropriate details object based on category
    switch (categoryName) {
      case 'furniture':
        categoryDetails = map['furniture_details'];
        print('🔍 Found furniture_details: $categoryDetails');
        break;
      case 'fabric':
      case 'fabrics':
        categoryDetails = map['fabric_details'];
        print('🔍 Found fabric_details: $categoryDetails');
        break;
      case 'carpet':
      case 'carpets':
        categoryDetails = map['carpet_details'];
        print('🔍 Found carpet_details: $categoryDetails');
        break;
      case 'frame structure':
      case 'frame structures':
        categoryDetails = map['frame_structure_details'];
        print('🔍 Found frame_structure_details: $categoryDetails');
        break;
      case 'murti set':
      case 'murti sets':
        categoryDetails = map['murti_set_details'];
        print('🔍 Found murti_set_details: $categoryDetails');
        break;
      case 'stationery':
        categoryDetails = map['stationery_details'];
        print('🔍 Found stationery_details: $categoryDetails');
        break;
      case 'thermocol':
      case 'thermocol material':
      case 'thermocol materials':
        categoryDetails = map['thermocol_details'];
        print('🔍 Found thermocol_details: $categoryDetails');
        break;
      default:
        print('🔍 No category details found for: $categoryName');
    }

    return InventoryItem(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      category: map['category_id']?.toString() ?? '',
      categoryName: map['category_name'] ?? '',
      unit: map['unit'] ?? '',
      storageLocation: map['storage_location'] ?? '',
      notes: map['notes'] ?? '',
      availableQuantity:
          double.tryParse(map['available_quantity']?.toString() ?? '0') ?? 0.0,
      material: categoryDetails?['material'] ?? map['material'],
      createdAt: map['created_at'],
      itemImage: map['item_image'],
      status: map['status'],
      imageBytes: map['imageBytes'] != null
          ? Uint8List.fromList(map['imageBytes'])
          : null,
      imageName: map['imageName'],
      // Parse category-specific fields from the details object
      dimensions: categoryDetails?['dimensions'],
      fabricType: categoryDetails?['fabric_type'],
      pattern: categoryDetails?['pattern'],
      width: categoryDetails?['width'] != null
          ? double.tryParse(categoryDetails!['width'].toString())
          : null,
      length: categoryDetails?['length'] != null
          ? double.tryParse(categoryDetails!['length'].toString())
          : null,
      color: categoryDetails?['color'],
      carpetType: categoryDetails?['carpet_type'],
      size: categoryDetails?['size'],
      frameType: categoryDetails?['frame_type'],
      setNumber: categoryDetails?['set_number'],
      specifications: categoryDetails?['specifications'],
      thermocolType: categoryDetails?['thermocol_type'],
      density: categoryDetails?['density'] != null
          ? double.tryParse(categoryDetails!['density'].toString())
          : null,
    );
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    String? categoryName,
    String? unit,
    String? storageLocation,
    String? notes,
    double? availableQuantity,
    String? material,
    String? createdAt,
    String? itemImage,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
    String? dimensions,
    String? fabricType,
    String? pattern,
    double? width,
    double? length,
    String? color,
    String? carpetType,
    String? size,
    String? frameType,
    String? setNumber,
    String? specifications,
    String? thermocolType,
    double? density,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      categoryName: categoryName ?? this.categoryName,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      material: material ?? this.material,
      createdAt: createdAt ?? this.createdAt,
      itemImage: itemImage ?? this.itemImage,
      status: status ?? this.status,
      imageBytes: imageBytes ?? this.imageBytes,
      imageName: imageName ?? this.imageName,
      dimensions: dimensions ?? this.dimensions,
      fabricType: fabricType ?? this.fabricType,
      pattern: pattern ?? this.pattern,
      width: width ?? this.width,
      length: length ?? this.length,
      color: color ?? this.color,
      carpetType: carpetType ?? this.carpetType,
      size: size ?? this.size,
      frameType: frameType ?? this.frameType,
      setNumber: setNumber ?? this.setNumber,
      specifications: specifications ?? this.specifications,
      thermocolType: thermocolType ?? this.thermocolType,
      density: density ?? this.density,
    );
  }
}

class InventoryNotifier extends StateNotifier<List<InventoryItem>> {
  final InventoryService _inventoryService;
  final List<Map<String, dynamic>> _issuedItems = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get issuedItems => _issuedItems;
  List<Map<String, dynamic>> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  InventoryNotifier(this._inventoryService) : super([]) {
    loadInventoryData();
  }

  // Load inventory data from API
  Future<void> loadInventoryData() async {
    _isLoading = true;
    _error = null;

    try {
      // Load both items and categories
      final itemsResponse = await _inventoryService.getAllItems();
      final categoriesResponse = await _inventoryService.getAllCategories();

      if (itemsResponse['success'] == true) {
        final itemsData = itemsResponse['data'] as List;
        final items =
            itemsData.map((item) => InventoryItem.fromMap(item)).toList();
        state = items;
      }

      if (categoriesResponse['success'] == true) {
        _categories =
            List<Map<String, dynamic>>.from(categoriesResponse['data']);
      }

      print('✅ Inventory data loaded successfully');
    } catch (e) {
      _error = e.toString();
      print('❌ Error loading inventory data: $e');
    } finally {
      _isLoading = false;
    }
  }

  // Refresh inventory data
  Future<void> refreshInventoryData() async {
    await loadInventoryData();
  }

  // Add new item
  Future<void> addItem(Map<String, dynamic> itemData) async {
    try {
      final response = await _inventoryService.addItem(itemData);
      if (response['success'] == true) {
        // Reload data to get the updated list
        await loadInventoryData();
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error adding item: $e');
    }
  }

  // Update item
  Future<void> updateItem(String id, Map<String, dynamic> itemData) async {
    try {
      final response = await _inventoryService.updateItem(id, itemData);
      if (response['success'] == true) {
        // Reload data to get the updated list
        await loadInventoryData();
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating item: $e');
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    try {
      final response = await _inventoryService.deleteItem(id);
      if (response['success'] == true) {
        // Reload data to get the updated list
        await loadInventoryData();
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error deleting item: $e');
    }
  }

  // Issue inventory (local tracking)
  void issueInventory(String itemId, int quantity, String eventName) {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final item = state[index];

      // Track the issued item
      _issuedItems.add({
        'itemId': itemId,
        'itemName': item.name,
        'quantity': quantity,
        'eventName': eventName,
        'issueDate': DateTime.now().toString().split(' ')[0],
        'remainingQuantity': (item.availableQuantity) - quantity,
      });
    }
  }

  // Create furniture item using specific API
  Future<void> createFurnitureItem({
    required String name,
    required String material,
    required String dimensions,
    required String unit,
    required String notes,
    required String storageLocation,
    required double quantityAvailable,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createFurnitureItem(
        name: name,
        material: material,
        dimensions: dimensions,
        unit: unit,
        notes: notes,
        storageLocation: storageLocation,
        quantityAvailable: quantityAvailable,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Furniture item created successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to create furniture item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating furniture item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Create murti sets item using specific API
  Future<void> createMurtiSetsItem({
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String setNumber,
    required String material,
    required String dimensions,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createMurtiSetsItem(
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        setNumber: setNumber,
        material: material,
        dimensions: dimensions,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Murti sets item created successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to create murti sets item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating murti sets item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Create stationery item using specific API
  Future<void> createStationeryItem({
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String specifications,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createStationeryItem(
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        specifications: specifications,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Stationery item created successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to create stationery item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating stationery item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Create thermocol materials item using specific API
  Future<void> createThermocolMaterialsItem({
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String thermocolType,
    required String dimensions,
    required double density,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createThermocolMaterialsItem(
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        thermocolType: thermocolType,
        dimensions: dimensions,
        density: density,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print(
            '✅ Thermocol materials item created successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to create thermocol materials item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating thermocol materials item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Update furniture item using specific API
  Future<void> updateFurnitureItem({
    required int id,
    required String name,
    required String material,
    required String dimensions,
    required String unit,
    required String notes,
    required String storageLocation,
    required double quantityAvailable,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.updateFurnitureItem(
        id: id,
        name: name,
        material: material,
        dimensions: dimensions,
        unit: unit,
        notes: notes,
        storageLocation: storageLocation,
        quantityAvailable: quantityAvailable,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Furniture item updated successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to update furniture item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating furniture item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Update carpet item using specific API
  Future<void> updateCarpetItem({
    required int id,
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String carpetType,
    required String material,
    required String size,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.updateCarpetItem(
        id: id,
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        carpetType: carpetType,
        material: material,
        size: size,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Carpet item updated successfully: ${response['data']}');
      } else {
        throw Exception(response['message'] ?? 'Failed to update carpet item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating carpet item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Update fabric item using specific API
  Future<void> updateFabricItem({
    required int id,
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String fabricType,
    required String pattern,
    required double width,
    required double length,
    required String color,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.updateFabricItem(
        id: id,
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        fabricType: fabricType,
        pattern: pattern,
        width: width,
        length: length,
        color: color,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Fabric item updated successfully: ${response['data']}');
      } else {
        throw Exception(response['message'] ?? 'Failed to update fabric item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating fabric item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Update frame structure item using specific API
  Future<void> updateFrameStructureItem({
    required int id,
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String frameType,
    required String material,
    required String dimensions,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.updateFrameStructureItem(
        id: id,
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        frameType: frameType,
        material: material,
        dimensions: dimensions,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print(
            '✅ Frame structure item updated successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to update frame structure item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating frame structure item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Update thermocol materials item using specific API
  Future<void> updateThermocolMaterialsItem({
    required int id,
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String thermocolType,
    required double density,
    required String dimensions,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.updateThermocolMaterialsItem(
        id: id,
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        thermocolType: thermocolType,
        density: density,
        dimensions: dimensions,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print(
            '✅ Thermocol materials item updated successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to update thermocol materials item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating thermocol materials item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Update murti sets item using specific API
  Future<void> updateMurtiSetsItem({
    required int id,
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String setNumber,
    required String material,
    required String dimensions,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.updateMurtiSetsItem(
        id: id,
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        setNumber: setNumber,
        material: material,
        dimensions: dimensions,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Murti sets item updated successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to update murti sets item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating murti sets item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Update stationery item using specific API
  Future<void> updateStationeryItem({
    required int id,
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String specifications,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.updateStationeryItem(
        id: id,
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        specifications: specifications,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Stationery item updated successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to update stationery item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error updating stationery item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Delete inventory item
  Future<void> deleteInventoryItem({
    required int id,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.deleteInventoryItem(
        id: id,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Inventory item deleted successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to delete inventory item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error deleting inventory item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Issue inventory item to event
  Future<void> issueInventoryToEvent({
    required int itemId,
    required int eventId,
    required double quantity,
    required String notes,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.issueInventoryToEvent(
        itemId: itemId,
        eventId: eventId,
        quantity: quantity,
        notes: notes,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated stock quantities
        await loadInventoryData();
        print(
            '✅ Inventory item issued to event successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to issue inventory to event');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error issuing inventory to event: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Get events list
  Future<List<Map<String, dynamic>>> getEventsList() async {
    try {
      final response = await _inventoryService.getEventsList();

      if (response['success'] == true) {
        final events = List<Map<String, dynamic>>.from(response['data'] ?? []);
        print('✅ Events list retrieved successfully: ${events.length} events');
        return events;
      } else {
        throw Exception(response['message'] ?? 'Failed to get events list');
      }
    } catch (e) {
      print('❌ Error getting events list: $e');
      rethrow;
    }
  }

  // Get issuance history by item ID
  Future<Map<String, dynamic>> getIssuanceHistoryByItemId({
    required int itemId,
  }) async {
    try {
      final response = await _inventoryService.getIssuanceHistoryByItemId(
        itemId: itemId,
      );

      if (response['success'] == true) {
        print('✅ Issuance history retrieved successfully for item $itemId');
        return response;
      } else {
        throw Exception(
            response['message'] ?? 'Failed to get issuance history');
      }
    } catch (e) {
      print('❌ Error getting issuance history: $e');
      rethrow;
    }
  }

  // Update issuance (for returns)
  Future<void> updateIssuance({
    required int id,
    required int itemId,
    required String transactionType,
    required double quantity,
    required int eventId,
    required String notes,
  }) async {
    try {
      final response = await _inventoryService.updateIssuance(
        id: id,
        itemId: itemId,
        transactionType: transactionType,
        quantity: quantity,
        eventId: eventId,
        notes: notes,
      );

      if (response['success'] == true) {
        print('✅ Issuance updated successfully');
        // Reload inventory data to reflect stock changes
        await loadInventoryData();
      } else {
        throw Exception(response['message'] ?? 'Failed to update issuance');
      }
    } catch (e) {
      print('❌ Error updating issuance: $e');
      rethrow;
    }
  }

  // Create frame structure item using specific API
  Future<void> createFrameStructureItem({
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String frameType,
    required String material,
    required String dimensions,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createFrameStructureItem(
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        frameType: frameType,
        material: material,
        dimensions: dimensions,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print(
            '✅ Frame structure item created successfully: ${response['data']}');
      } else {
        throw Exception(
            response['message'] ?? 'Failed to create frame structure item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating frame structure item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Create fabric item using specific API
  Future<void> createFabricItem({
    required String name,
    required String fabricType,
    required String pattern,
    required double width,
    required double length,
    required String color,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createFabricItem(
        name: name,
        fabricType: fabricType,
        pattern: pattern,
        width: width,
        length: length,
        color: color,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Fabric item created successfully: ${response['data']}');
      } else {
        throw Exception(response['message'] ?? 'Failed to create fabric item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating fabric item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Create carpet item using specific API
  Future<void> createCarpetItem({
    required String name,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    required String carpetType,
    required String material,
    required String size,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createCarpetItem(
        name: name,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        carpetType: carpetType,
        material: material,
        size: size,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print('✅ Carpet item created successfully: ${response['data']}');
      } else {
        throw Exception(response['message'] ?? 'Failed to create carpet item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating carpet item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  // Create new inventory item
  Future<void> createItem({
    required String name,
    required int categoryId,
    required String unit,
    required String storageLocation,
    required String notes,
    required double quantityAvailable,
    File? itemImage,
    String? itemImagePath,
    Uint8List? itemImageBytes,
    String? itemImageName,
    required Map<String, dynamic> categoryDetails,
  }) async {
    _isLoading = true;
    _error = null;

    try {
      final response = await _inventoryService.createItem(
        name: name,
        categoryId: categoryId,
        unit: unit,
        storageLocation: storageLocation,
        notes: notes,
        quantityAvailable: quantityAvailable,
        itemImage: itemImage,
        itemImagePath: itemImagePath,
        itemImageBytes: itemImageBytes,
        itemImageName: itemImageName,
        categoryDetails: categoryDetails,
      );

      if (response['success'] == true) {
        // Reload inventory data to get the updated list
        await loadInventoryData();
        print(
            '✅ Inventory item created successfully: ${response['data']['name']}');
      } else {
        throw Exception(response['message'] ?? 'Failed to create item');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Error creating inventory item: $e');
      rethrow;
    } finally {
      _isLoading = false;
    }
  }

  void clear() => state = [];

  // Get current quantity of an item
  double getItemQuantity(String itemId) {
    final item = state.firstWhere((item) => item.id == itemId,
        orElse: () => InventoryItem(
              id: '',
              name: '',
              category: '',
              categoryName: '',
              unit: '',
              storageLocation: '',
              notes: '',
              availableQuantity: 0.0,
            ));
    return item.availableQuantity;
  }

  // Get issued items for a specific event
  List<Map<String, dynamic>> getIssuedItemsForEvent(String eventName) {
    return _issuedItems
        .where((item) => item['eventName'] == eventName)
        .toList();
  }

  // Get total count of items
  int get totalItemsCount => state.length;

  // Get total count of categories
  int get totalCategoriesCount => _categories.length;

  // Get low stock items count
  int get lowStockCount =>
      state.where((item) => item.availableQuantity <= 5).length;
}

// Service provider
final inventoryServiceProvider = Provider<InventoryService>((ref) {
  return InventoryService(apiBaseUrl);
});

// Main inventory provider
final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, List<InventoryItem>>((ref) {
  final inventoryService = ref.read(inventoryServiceProvider);
  return InventoryNotifier(inventoryService);
});
