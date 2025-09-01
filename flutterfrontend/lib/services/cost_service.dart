import '../models/cost_model.dart';
import 'api_service.dart';

class CostService {
  final ApiService _apiService;

  CostService(this._apiService);

  Future<List<CostModel>> getCosts({int? eventId}) async {
    final endpoint = eventId != null ? '/costs/event/$eventId' : '/costs';
    final response = await _apiService.get(endpoint);
    return (response as List).map((e) => CostModel.fromJson(e)).toList();
  }

  Future<CostModel> addCost(CostModel cost) async {
    final response = await _apiService.post('/costs', body: cost.toJson());
    return CostModel.fromJson(response);
  }

  Future<void> deleteCost(int id) async {
    await _apiService.delete('/costs/$id');
  }
}
