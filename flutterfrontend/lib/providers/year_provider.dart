import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/year_model.dart';
import '../services/year_service.dart';
import 'api_provider.dart';

final yearServiceProvider = Provider<YearService>((ref) {
  final api = ref.read(apiServiceProvider);
  return YearService(api);
});

final yearProvider = StateNotifierProvider<YearNotifier, List<YearModel>>((ref) {
  final service = ref.read(yearServiceProvider);
  return YearNotifier(ref, service);
});

class YearNotifier extends StateNotifier<List<YearModel>> {
  final Ref ref;
  final YearService service;

  YearNotifier(this.ref, this.service) : super([]);

  Future<void> fetchYears() async {
    try {
      final years = await service.fetchYears();
      state = years;
    } catch (e) {
      print('Error fetching years: $e');
    }
  }

  Future<void> addYear(YearModel year) async {
    try {
      await service.createYear(year);
      await fetchYears();
    } catch (e) {
      print('Error adding year: $e');
    }
  }

  Future<void> deleteYear(int id) async {
    try {
      await service.deleteYear(id);
      state = state.where((y) => y.id != id).toList();
    } catch (e) {
      print('Error deleting year: $e');
    }
  }
}
