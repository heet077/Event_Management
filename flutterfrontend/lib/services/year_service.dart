import '../models/year_model.dart';
import 'api_service.dart';

class YearService {
  final ApiService api;

  YearService(this.api);

  Future<List<YearModel>> fetchYears() async {
    final response = await api.get('/years');
    return (response as List)
        .map((json) => YearModel.fromJson(json))
        .toList();
  }

  Future<YearModel> createYear(YearModel year) async {
    final response = await api.post('/years', body: year.toJson());
    return YearModel.fromJson(response);
  }

  Future<void> deleteYear(int id) async {
    await api.delete('/years/$id');
  }
}
