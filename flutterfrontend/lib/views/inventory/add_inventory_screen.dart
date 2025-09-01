import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  void selectCategory(InventoryCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void updateFurnitureData({
    String? name,
    String? category,
    String? material,
    String? dimensions,
    int? quantity,
    String? location,
  }) {
    final furniture = state.furniture.copyWith(
      name: name,
      category: category,
      material: material,
      dimensions: dimensions,
      quantity: quantity,
      location: location,
    );
    state = state.copyWith(furniture: furniture);
  }

  void updateFabricData({
    String? type,
    String? pattern,
    String? color,
    double? width,
    double? length,
    int? stock,
  }) {
    final fabric = state.fabric.copyWith(
      type: type,
      pattern: pattern,
      color: color,
      width: width,
      length: length,
      stock: stock,
    );
    state = state.copyWith(fabric: fabric);
  }

  void updateFrameData({
    String? type,
    String? material,
    String? dimensions,
    int? quantity,
  }) {
    final frame = state.frame.copyWith(
      type: type,
      material: material,
      dimensions: dimensions,
      quantity: quantity,
    );
    state = state.copyWith(frame: frame);
  }

  void updateCarpetData({
    String? type,
    String? material,
    String? size,
    int? stock,
  }) {
    final carpet = state.carpet.copyWith(
      type: type,
      material: material,
      size: size,
      stock: stock,
    );
    state = state.copyWith(carpet: carpet);
  }

  void updateThermocolData({
    String? type,
    String? dimensions,
    double? density,
    int? stock,
  }) {
    final thermocol = state.thermocol.copyWith(
      type: type,
      dimensions: dimensions,
      density: density,
      stock: stock,
    );
    state = state.copyWith(thermocol: thermocol);
  }

  void updateStationeryData({
    String? name,
    String? category,
    String? specs,
    String? unit,
    int? quantity,
  }) {
    final stationery = state.stationery.copyWith(
      name: name,
      category: category,
      specs: specs,
      unit: unit,
      quantity: quantity,
    );
    state = state.copyWith(stationery: stationery);
  }

  void updateMurtiData({
    String? deity,
    String? material,
    String? dimensions,
    double? weight,
    int? quantity,
  }) {
    final murti = state.murti.copyWith(
      deity: deity,
      material: material,
      dimensions: dimensions,
      weight: weight,
      quantity: quantity,
    );
    state = state.copyWith(murti: murti);
  }

  void resetForm() {
    state = const InventoryFormState();
  }

  void setImage({required Uint8List bytes, required String name}) {
    state = state.copyWith(imageBytes: bytes, imageName: name);
  }

  void clearImage() {
    state = state.copyWith(imageBytes: null, imageName: null);
  }

  void setLocation(String value) {
    state = state.copyWith(location: value);
  }

  bool validateForm() {
    switch (state.selectedCategory) {
      case InventoryCategory.furniture:
        return state.furniture.name?.isNotEmpty == true &&
            state.furniture.material?.isNotEmpty == true &&
            (state.furniture.quantity ?? 0) > 0;
      case InventoryCategory.fabric:
        return state.fabric.type?.isNotEmpty == true &&
            state.fabric.pattern?.isNotEmpty == true &&
            state.fabric.color?.isNotEmpty == true;
      case InventoryCategory.frameStructure:
        return state.frame.type?.isNotEmpty == true &&
            state.frame.material?.isNotEmpty == true &&
            state.frame.dimensions?.isNotEmpty == true;
      case InventoryCategory.carpet:
        return state.carpet.type?.isNotEmpty == true &&
            state.carpet.material?.isNotEmpty == true &&
            state.carpet.size?.isNotEmpty == true;
      case InventoryCategory.thermocol:
        return state.thermocol.type?.isNotEmpty == true &&
            state.thermocol.dimensions?.isNotEmpty == true &&
            (state.thermocol.density ?? 0) > 0;
      case InventoryCategory.stationery:
        return state.stationery.name?.isNotEmpty == true &&
            state.stationery.category?.isNotEmpty == true &&
            (state.stationery.quantity ?? 0) > 0;
      case InventoryCategory.murtiSet:
        return state.murti.deity?.isNotEmpty == true &&
            state.murti.material?.isNotEmpty == true;
      case null:
        return false;
    }
  }
}

final inventoryFormNotifierProvider = StateNotifierProvider<InventoryFormNotifier, InventoryFormState>((ref) {
  return InventoryFormNotifier();
});

class InventoryFormState {
  final InventoryCategory? selectedCategory;
  final FurnitureData furniture;
  final FabricData fabric;
  final FrameData frame;
  final CarpetData carpet;
  final ThermocolData thermocol;
  final StationeryData stationery;
  final MurtiData murti;
  final Uint8List? imageBytes;
  final String? imageName;
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
    this.location,
  });

  InventoryFormState copyWith({
    InventoryCategory? selectedCategory,
    FurnitureData? furniture,
    FabricData? fabric,
    FrameData? frame,
    CarpetData? carpet,
    ThermocolData? thermocol,
    StationeryData? stationery,
    MurtiData? murti,
    Uint8List? imageBytes,
    String? imageName,
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
      location: location ?? this.location,
    );
  }
}

class FurnitureData {
  final String? name;
  final String? category;
  final String? material;
  final String? dimensions;
  final int? quantity;
  final String? location;

  const FurnitureData({
    this.name,
    this.category,
    this.material,
    this.dimensions,
    this.quantity,
    this.location,
  });

  FurnitureData copyWith({
    String? name,
    String? category,
    String? material,
    String? dimensions,
    int? quantity,
    String? location,
  }) {
    return FurnitureData(
      name: name ?? this.name,
      category: category ?? this.category,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
      quantity: quantity ?? this.quantity,
      location: location ?? this.location,
    );
  }
}

class FabricData {
  final String? type;
  final String? pattern;
  final String? color;
  final double? width;
  final double? length;
  final int? stock;

  const FabricData({
    this.type,
    this.pattern,
    this.color,
    this.width,
    this.length,
    this.stock,
  });

  FabricData copyWith({
    String? type,
    String? pattern,
    String? color,
    double? width,
    double? length,
    int? stock,
  }) {
    return FabricData(
      type: type ?? this.type,
      pattern: pattern ?? this.pattern,
      color: color ?? this.color,
      width: width ?? this.width,
      length: length ?? this.length,
      stock: stock ?? this.stock,
    );
  }
}

class FrameData {
  final String? type;
  final String? material;
  final String? dimensions;
  final int? quantity;

  const FrameData({
    this.type,
    this.material,
    this.dimensions,
    this.quantity,
  });

  FrameData copyWith({
    String? type,
    String? material,
    String? dimensions,
    int? quantity,
  }) {
    return FrameData(
      type: type ?? this.type,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CarpetData {
  final String? type;
  final String? material;
  final String? size;
  final int? stock;

  const CarpetData({
    this.type,
    this.material,
    this.size,
    this.stock,
  });

  CarpetData copyWith({
    String? type,
    String? material,
    String? size,
    int? stock,
  }) {
    return CarpetData(
      type: type ?? this.type,
      material: material ?? this.material,
      size: size ?? this.size,
      stock: stock ?? this.stock,
    );
  }
}

class ThermocolData {
  final String? type;
  final String? dimensions;
  final double? density;
  final int? stock;

  const ThermocolData({
    this.type,
    this.dimensions,
    this.density,
    this.stock,
  });

  ThermocolData copyWith({
    String? type,
    String? dimensions,
    double? density,
    int? stock,
  }) {
    return ThermocolData(
      type: type ?? this.type,
      dimensions: dimensions ?? this.dimensions,
      density: density ?? this.density,
      stock: stock ?? this.stock,
    );
  }
}

class StationeryData {
  final String? name;
  final String? category;
  final String? specs;
  final String? unit;
  final int? quantity;

  const StationeryData({
    this.name,
    this.category,
    this.specs,
    this.unit,
    this.quantity,
  });

  StationeryData copyWith({
    String? name,
    String? category,
    String? specs,
    String? unit,
    int? quantity,
  }) {
    return StationeryData(
      name: name ?? this.name,
      category: category ?? this.category,
      specs: specs ?? this.specs,
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
    );
  }
}

class MurtiData {
  final String? deity;
  final String? material;
  final String? dimensions;
  final double? weight;
  final int? quantity;

  const MurtiData({
    this.deity,
    this.material,
    this.dimensions,
    this.weight,
    this.quantity,
  });

  MurtiData copyWith({
    String? deity,
    String? material,
    String? dimensions,
    double? weight,
    int? quantity,
  }) {
    return MurtiData(
      deity: deity ?? this.deity,
      material: material ?? this.material,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      quantity: quantity ?? this.quantity,
    );
  }
}