import '../models/year_model.dart';
import 'api_service.dart';

class YearService {
  final ApiService api;

  YearService(this.api);

  Future<List<YearModel>> fetchYears() async {
    print('Fetching years from API...');
    
    // Try different endpoints
    try {
      final response = await api.post('/api/years/getAll', body: {});
      print('Years API response: $response');
      
      if (response is List) {
        final years = response.map((json) => YearModel.fromJson(json)).toList();
        print('Parsed years: ${years.length} years found');
        for (var year in years) {
          print('Year: ${year.yearName} (ID: ${year.id})');
        }
        return years;
      } else {
        print('Error: Response is not a List, got: ${response.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error with /api/years/getAll, trying /api/years: $e');
      try {
        // Fallback to GET /api/years
        final response = await api.get('/api/years');
        print('Years API response (fallback): $response');
        
        if (response is List) {
          final years = response.map((json) => YearModel.fromJson(json)).toList();
          print('Parsed years (fallback): ${years.length} years found');
          return years;
        } else {
          print('Error: Fallback response is not a List, got: ${response.runtimeType}');
          return [];
        }
      } catch (e2) {
        print('Error with both endpoints: $e2');
        return [];
      }
    }
  }

  Future<YearModel> createYear(YearModel year) async {
    final response = await api.post('/api/years', body: year.toJson());
    return YearModel.fromJson(response);
  }

  Future<void> deleteYear(int id) async {
    await api.delete('/api/years/$id');
  }
}
