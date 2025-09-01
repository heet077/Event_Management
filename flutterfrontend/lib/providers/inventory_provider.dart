import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';

class InventoryItem {
  final String id;
  final String name;
  final String category;
  final String material;
  final int quantity;
  final String location;
  final String lastUpdated;
  final String status;
  final Uint8List? imageBytes;
  final String? imageName;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.material,
    required this.quantity,
    required this.location,
    required this.lastUpdated,
    required this.status,
    this.imageBytes,
    this.imageName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'material': material,
      'quantity': quantity,
      'location': location,
      'lastUpdated': lastUpdated,
      'status': status,
      'imageBytes': imageBytes,
      'imageName': imageName,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      material: map['material'] ?? '',
      quantity: map['quantity'] ?? 0,
      location: map['location'] ?? '',
      lastUpdated: map['lastUpdated'] ?? '',
      status: map['status'] ?? '',
      imageBytes: map['imageBytes'] != null ? Uint8List.fromList(map['imageBytes']) : null,
      imageName: map['imageName'],
    );
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    String? category,
    String? material,
    int? quantity,
    String? location,
    String? lastUpdated,
    String? status,
    Uint8List? imageBytes,
    String? imageName,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      material: material ?? this.material,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      status: status ?? this.status,
      imageBytes: imageBytes ?? this.imageBytes,
      imageName: imageName ?? this.imageName,
    );
  }
}

class InventoryNotifier extends StateNotifier<List<InventoryItem>> {
  // Track issued items
  final List<Map<String, dynamic>> _issuedItems = [];
  
  List<Map<String, dynamic>> get issuedItems => _issuedItems;
  
  InventoryNotifier() : super([
    InventoryItem(
      id: '1',
      name: 'Wooden Chair',
      category: 'Furniture',
      material: 'Teak Wood',
      quantity: 5,
      location: 'Warehouse A',
      lastUpdated: '2024-01-15',
      status: 'In Stock',
    ),
    InventoryItem(
      id: '2',
      name: 'Silk Fabric',
      category: 'Fabric',
      material: 'Silk',
      quantity: 20,
      location: 'Storage Room B',
      lastUpdated: '2024-01-14',
      status: 'Low Stock',
    ),
    InventoryItem(
      id: '3',
      name: 'Photo Frame',
      category: 'Frame Structure',
      material: 'Metal',
      quantity: 15,
      location: 'Warehouse C',
      lastUpdated: '2024-01-13',
      status: 'In Stock',
    ),
    InventoryItem(
      id: '4',
      name: 'Persian Carpet',
      category: 'Carpet',
      material: 'Wool',
      quantity: 3,
      location: 'Showroom',
      lastUpdated: '2024-01-12',
      status: 'In Stock',
    ),
    InventoryItem(
      id: '5',
      name: 'Thermocol Sheet',
      category: 'Thermocol Material',
      material: 'EPS',
      quantity: 50,
      location: 'Storage Room A',
      lastUpdated: '2024-01-11',
      status: 'In Stock',
    ),
  ]);

  void addItem(InventoryItem item) {
    state = [item, ...state];
  }

  void updateItem(String id, InventoryItem updatedItem) {
    final index = state.indexWhere((item) => item.id == id);
    if (index != -1) {
      final updatedState = List<InventoryItem>.from(state);
      updatedState[index] = updatedItem;
      state = updatedState;
    }
  }

  void deleteItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void issueInventory(String itemId, int quantity, String eventName) {
    final index = state.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      final updatedState = List<InventoryItem>.from(state);
      final item = updatedState[index];
      final updatedItem = item.copyWith(
        quantity: item.quantity - quantity,
        status: (item.quantity - quantity) > 5 ? 'In Stock' : 'Low Stock',
        lastUpdated: DateTime.now().toString().split(' ')[0],
      );
      updatedState[index] = updatedItem;
      state = updatedState;
      
      // Track the issued item
      _issuedItems.add({
        'itemId': itemId,
        'itemName': item.name,
        'quantity': quantity,
        'eventName': eventName,
        'issueDate': DateTime.now().toString().split(' ')[0],
        'remainingQuantity': updatedItem.quantity,
      });
    }
  }

  void clear() => state = [];
  
  // Get current quantity of an item
  int getItemQuantity(String itemId) {
    final item = state.firstWhere((item) => item.id == itemId, orElse: () => InventoryItem(id: '', name: '', category: '', material: '', quantity: 0, location: '', lastUpdated: '', status: ''));
    return item.quantity;
  }
  
  // Get issued items for a specific event
  List<Map<String, dynamic>> getIssuedItemsForEvent(String eventName) {
    return _issuedItems.where((item) => item['eventName'] == eventName).toList();
  }
}

final inventoryProvider = StateNotifierProvider<InventoryNotifier, List<InventoryItem>>((ref) => InventoryNotifier());
