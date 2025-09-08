import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/category_model.dart';

enum InventoryCategory {
  furniture,
  fabric,
  frameStructure,
  carpet,
  thermocol,
  stationery,
  murtiSet,
}

extension InventoryCategoryExtension on InventoryCategory {
  String get displayName {
    switch (this) {
      case InventoryCategory.furniture:
        return 'Furniture';
      case InventoryCategory.fabric:
        return 'Fabric';
      case InventoryCategory.frameStructure:
        return 'Frame Structure';
      case InventoryCategory.carpet:
        return 'Carpet';
      case InventoryCategory.thermocol:
        return 'Thermocol Material';
      case InventoryCategory.stationery:
        return 'Stationery';
      case InventoryCategory.murtiSet:
        return 'Murti Set';
    }
  }

  String get icon {
    switch (this) {
      case InventoryCategory.furniture:
        return '🪑';
      case InventoryCategory.fabric:
        return '🧵';
      case InventoryCategory.frameStructure:
        return '🖼';
      case InventoryCategory.carpet:
        return '🟫';
      case InventoryCategory.thermocol:
        return '📦';
      case InventoryCategory.stationery:
        return '✏';
      case InventoryCategory.murtiSet:
        return '🙏';
    }
  }
}

class InventoryFormNotifier extends StateNotifier<InventoryFormState> {
  InventoryFormNotifier() : super(const InventoryFormState());

  void selectCategory(CategoryModel category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateFurnitureData({
    String? name,
    String? material,
    String? dimensions,
    String? unit,
    String? notes,
    String? storageLocation,
    int? quantity,
  }) {
    final furniture = state.furniture.copyWith(
      name: name,
      material: material,
      dimensions: dimensions,
      unit: unit,
      notes: notes,
      storageLocation: storageLocation,
      quantity: quantity,
    );
    state = state.copyWith(furniture: furniture);
  }

  void updateFabricData({
    String? name,
    String? type,
    String? pattern,
    double? width,
    double? length,
    String? color,
    String? unit,
    String? storageLocation,
    String? notes,
    double? stock,
  }) {
    final fabric = state.fabric.copyWith(
      name: name,
      type: type,
      pattern: pattern,
      width: width,
      length: length,
      color: color,
      unit: unit,
      storageLocation: storageLocation,
      notes: notes,
      stock: stock,
    );
    state = state.copyWith(fabric: fabric);
  }

  void updateFrameData({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    String? type,
    String? material,
    String? dimensions,
    int? quantity,
  }) {
    final frame = state.frame.copyWith(
      name: name,
      unit: unit,
      storageLocation: storageLocation,
      notes: notes,
      type: type,
      material: material,
      dimensions: dimensions,
      quantity: quantity,
    );
    state = state.copyWith(frame: frame);
  }

  void updateCarpetData({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    String? type,
    String? material,
    String? size,
    int? stock,
  }) {
    final carpet = state.carpet.copyWith(
      name: name,
      unit: unit,
      storageLocation: storageLocation,
      notes: notes,
      type: type,
      material: material,
      size: size,
      stock: stock,
    );
    state = state.copyWith(carpet: carpet);
  }

  void updateThermocolData({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    int? quantity,
    String? thermocolType,
    String? dimensions,
    double? density,
  }) {
    final thermocol = state.thermocol.copyWith(
      name: name,
      unit: unit,
      storageLocation: storageLocation,
      notes: notes,
      quantity: quantity,
      thermocolType: thermocolType,
      dimensions: dimensions,
      density: density,
    );
    state = state.copyWith(thermocol: thermocol);
  }

  void updateStationeryData({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    int? quantity,
    String? specifications,
  }) {
    final stationery = state.stationery.copyWith(
      name: name,
      unit: unit,
      storageLocation: storageLocation,
      notes: notes,
      quantity: quantity,
      specifications: specifications,
    );
    state = state.copyWith(stationery: stationery);
  }

  void updateMurtiData({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    int? quantity,
    String? setNumber,
    String? material,
    String? dimensions,
  }) {
    final murti = state.murti.copyWith(
      name: name,
      unit: unit,
      storageLocation: storageLocation,
      notes: notes,
      quantity: quantity,
      setNumber: setNumber,
      material: material,
      dimensions: dimensions,
    );
    state = state.copyWith(murti: murti);
  }

  void resetForm() {
    state = const InventoryFormState();
  }

  void setImage(
      {required Uint8List bytes, required String name, String? path}) {
    state = state.copyWith(imageBytes: bytes, imageName: name, imagePath: path);
  }

  void clearImage() {
    state = state.copyWith(imageBytes: null, imageName: null, imagePath: null);
  }

  void setLocation(String value) {
    state = state.copyWith(location: value);
  }

  bool validateForm() {
    if (state.selectedCategory == null) return false;

    final categoryName = state.selectedCategory!.name.toLowerCase();

    switch (categoryName) {
      case 'furniture':
        return state.furniture.name?.isNotEmpty == true &&
            state.furniture.material?.isNotEmpty == true &&
            state.furniture.dimensions?.isNotEmpty == true &&
            state.furniture.unit?.isNotEmpty == true &&
            state.furniture.notes?.isNotEmpty == true &&
            state.furniture.storageLocation?.isNotEmpty == true &&
            (state.furniture.quantity ?? 0) > 0;
      case 'fabric':
      case 'fabrics':
        return state.fabric.name?.isNotEmpty == true &&
            state.fabric.type?.isNotEmpty == true &&
            state.fabric.pattern?.isNotEmpty == true &&
            state.fabric.width != null &&
            state.fabric.width! > 0 &&
            state.fabric.length != null &&
            state.fabric.length! > 0 &&
            state.fabric.color?.isNotEmpty == true &&
            state.fabric.unit?.isNotEmpty == true &&
            state.fabric.storageLocation?.isNotEmpty == true &&
            state.fabric.notes?.isNotEmpty == true &&
            state.fabric.stock != null &&
            state.fabric.stock! > 0;
      case 'frame structure':
      case 'frame structures':
        return state.frame.name?.isNotEmpty == true &&
            state.frame.unit?.isNotEmpty == true &&
            state.frame.storageLocation?.isNotEmpty == true &&
            state.frame.notes?.isNotEmpty == true &&
            state.frame.type?.isNotEmpty == true &&
            state.frame.material?.isNotEmpty == true &&
            state.frame.dimensions?.isNotEmpty == true &&
            (state.frame.quantity ?? 0) > 0;
      case 'carpet':
      case 'carpets':
        return state.carpet.name?.isNotEmpty == true &&
            state.carpet.unit?.isNotEmpty == true &&
            state.carpet.storageLocation?.isNotEmpty == true &&
            state.carpet.notes?.isNotEmpty == true &&
            state.carpet.type?.isNotEmpty == true &&
            state.carpet.material?.isNotEmpty == true &&
            state.carpet.size?.isNotEmpty == true &&
            (state.carpet.stock ?? 0) > 0;
      case 'thermocol':
      case 'thermocol material':
      case 'thermocol materials':
        return state.thermocol.name?.isNotEmpty == true &&
            state.thermocol.unit?.isNotEmpty == true &&
            state.thermocol.storageLocation?.isNotEmpty == true &&
            state.thermocol.notes?.isNotEmpty == true &&
            state.thermocol.thermocolType?.isNotEmpty == true &&
            state.thermocol.dimensions?.isNotEmpty == true &&
            (state.thermocol.density ?? 0) > 0 &&
            (state.thermocol.quantity ?? 0) > 0;
      case 'stationery':
        return state.stationery.name?.isNotEmpty == true &&
            state.stationery.unit?.isNotEmpty == true &&
            state.stationery.storageLocation?.isNotEmpty == true &&
            state.stationery.notes?.isNotEmpty == true &&
            state.stationery.specifications?.isNotEmpty == true &&
            (state.stationery.quantity ?? 0) > 0;
      case 'murti set':
      case 'murti sets':
        return state.murti.name?.isNotEmpty == true &&
            state.murti.unit?.isNotEmpty == true &&
            state.murti.storageLocation?.isNotEmpty == true &&
            state.murti.notes?.isNotEmpty == true &&
            state.murti.setNumber?.isNotEmpty == true &&
            state.murti.material?.isNotEmpty == true &&
            state.murti.dimensions?.isNotEmpty == true &&
            (state.murti.quantity ?? 0) > 0;
      default:
        // For any other category, use furniture validation as default
        return state.furniture.name?.isNotEmpty == true &&
            state.furniture.material?.isNotEmpty == true &&
            (state.furniture.quantity ?? 0) > 0;
    }
  }
}

final inventoryFormNotifierProvider =
    StateNotifierProvider<InventoryFormNotifier, InventoryFormState>((ref) {
  return InventoryFormNotifier();
});

class InventoryFormState {
  final CategoryModel? selectedCategory;
  final FurnitureData furniture;
  final FabricData fabric;
  final FrameData frame;
  final CarpetData carpet;
  final ThermocolData thermocol;
  final StationeryData stationery;
  final MurtiData murti;
  final Uint8List? imageBytes;
  final String? imageName;
  final String? imagePath;
  final String? location;

  const InventoryFormState({
    this.selectedCategory,
    this.furniture = const FurnitureData(),
    this.fabric = const FabricData(),
    this.frame = const FrameData(),
    this.carpet = const CarpetData(),
    this.thermocol = const ThermocolData(),
    this.stationery = const StationeryData(),
    this.murti = const MurtiData(),
    this.imageBytes,
    this.imageName,
    this.imagePath,
    this.location,
  });

  InventoryFormState copyWith({
    CategoryModel? selectedCategory,
    FurnitureData? furniture,
    FabricData? fabric,
    FrameData? frame,
    CarpetData? carpet,
    ThermocolData? thermocol,
    StationeryData? stationery,
    MurtiData? murti,
    Uint8List? imageBytes,
    String? imageName,
    String? imagePath,
    String? location,
  }) {
    return InventoryFormState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      furniture: furniture ?? this.furniture,
      fabric: fabric ?? this.fabric,
      frame: frame ?? this.frame,
      carpet: carpet ?? this.carpet,
      thermocol: thermocol ?? this.thermocol,
      stationery: stationery ?? this.stationery,
      murti: murti ?? this.murti,
      imageBytes: imageBytes ?? this.imageBytes,
      imageName: imageName ?? this.imageName,
      imagePath: imagePath ?? this.imagePath,
      location: location ?? this.location,
    );
  }
}

class FurnitureData {
  final String? name;
  final String? material;
  final String? dimensions;
  final String? unit;
  final String? notes;
  final String? storageLocation;
  final int? quantity;

  const FurnitureData({
    this.name,
    this.material,
    this.dimensions,
    this.unit,
    this.notes,
    this.storageLocation,
    this.quantity,
  });

  FurnitureData copyWith({
    String? name,
    String? material,
    String? dimensions,
    String? unit,
    String? notes,
    String? storageLocation,
    int? quantity,
  }) {
    return FurnitureData(
      name: name ?? this.name,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
      unit: unit ?? this.unit,
      notes: notes ?? this.notes,
      storageLocation: storageLocation ?? this.storageLocation,
      quantity: quantity ?? this.quantity,
    );
  }
}

class FabricData {
  final String? name;
  final String? type;
  final String? pattern;
  final double? width;
  final double? length;
  final String? color;
  final String? unit;
  final String? storageLocation;
  final String? notes;
  final double? stock;

  const FabricData({
    this.name,
    this.type,
    this.pattern,
    this.width,
    this.length,
    this.color,
    this.unit,
    this.storageLocation,
    this.notes,
    this.stock,
  });

  FabricData copyWith({
    String? name,
    String? type,
    String? pattern,
    double? width,
    double? length,
    String? color,
    String? unit,
    String? storageLocation,
    String? notes,
    double? stock,
  }) {
    return FabricData(
      name: name ?? this.name,
      type: type ?? this.type,
      pattern: pattern ?? this.pattern,
      width: width ?? this.width,
      length: length ?? this.length,
      color: color ?? this.color,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      stock: stock ?? this.stock,
    );
  }
}

class FrameData {
  final String? name;
  final String? unit;
  final String? storageLocation;
  final String? notes;
  final String? type;
  final String? material;
  final String? dimensions;
  final int? quantity;

  const FrameData({
    this.name,
    this.unit,
    this.storageLocation,
    this.notes,
    this.type,
    this.material,
    this.dimensions,
    this.quantity,
  });

  FrameData copyWith({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    String? type,
    String? material,
    String? dimensions,
    int? quantity,
  }) {
    return FrameData(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CarpetData {
  final String? name;
  final String? unit;
  final String? storageLocation;
  final String? notes;
  final String? type;
  final String? material;
  final String? size;
  final int? stock;

  const CarpetData({
    this.name,
    this.unit,
    this.storageLocation,
    this.notes,
    this.type,
    this.material,
    this.size,
    this.stock,
  });

  CarpetData copyWith({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    String? type,
    String? material,
    String? size,
    int? stock,
  }) {
    return CarpetData(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      type: type ?? this.type,
      material: material ?? this.material,
      size: size ?? this.size,
      stock: stock ?? this.stock,
    );
  }
}

class ThermocolData {
  final String? name;
  final String? unit;
  final String? storageLocation;
  final String? notes;
  final int? quantity;
  final String? thermocolType;
  final String? dimensions;
  final double? density;

  const ThermocolData({
    this.name,
    this.unit,
    this.storageLocation,
    this.notes,
    this.quantity,
    this.thermocolType,
    this.dimensions,
    this.density,
  });

  ThermocolData copyWith({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    int? quantity,
    String? thermocolType,
    String? dimensions,
    double? density,
  }) {
    return ThermocolData(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
      thermocolType: thermocolType ?? this.thermocolType,
      dimensions: dimensions ?? this.dimensions,
      density: density ?? this.density,
    );
  }
}

class StationeryData {
  final String? name;
  final String? unit;
  final String? storageLocation;
  final String? notes;
  final int? quantity;
  final String? specifications;

  const StationeryData({
    this.name,
    this.unit,
    this.storageLocation,
    this.notes,
    this.quantity,
    this.specifications,
  });

  StationeryData copyWith({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    int? quantity,
    String? specifications,
  }) {
    return StationeryData(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
      specifications: specifications ?? this.specifications,
    );
  }
}

class MurtiData {
  final String? name;
  final String? unit;
  final String? storageLocation;
  final String? notes;
  final int? quantity;
  final String? setNumber;
  final String? material;
  final String? dimensions;

  const MurtiData({
    this.name,
    this.unit,
    this.storageLocation,
    this.notes,
    this.quantity,
    this.setNumber,
    this.material,
    this.dimensions,
  });

  MurtiData copyWith({
    String? name,
    String? unit,
    String? storageLocation,
    String? notes,
    int? quantity,
    String? setNumber,
    String? material,
    String? dimensions,
  }) {
    return MurtiData(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      storageLocation: storageLocation ?? this.storageLocation,
      notes: notes ?? this.notes,
      quantity: quantity ?? this.quantity,
      setNumber: setNumber ?? this.setNumber,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
    );
  }
}
