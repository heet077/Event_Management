import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cost_model.dart';
import '../services/cost_service.dart';
import 'api_provider.dart';

final costServiceProvider = Provider<CostService>(
      (ref) => CostService(ref.read(apiServiceProvider)),
);

final costProvider = StateNotifierProvider<CostNotifier, List<CostModel>>((ref) {
  return CostNotifier(ref);
});

class CostNotifier extends StateNotifier<List<CostModel>> {
  final Ref ref;

  CostNotifier(this.ref) : super([]);

  Future<void> fetchCosts({int? eventId}) async {
    try {
      final costService = ref.read(costServiceProvider);
      final costs = await costService.getCosts(eventId: eventId);
      state = costs;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> addCost(CostModel cost) async {
    try {
      final costService = ref.read(costServiceProvider);
      final newCost = await costService.addCost(cost);
      state = [...state, newCost];
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteCost(int id) async {
    try {
      final costService = ref.read(costServiceProvider);
      await costService.deleteCost(id);
      state = state.where((c) => c.id != id).toList();
    } catch (e) {
      // Handle error
    }
  }
}
