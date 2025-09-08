import '../models/event_template_model.dart';
import 'api_service.dart';

class EventTemplateService {
  final ApiService api;

  EventTemplateService(this.api);

  Future<List<EventTemplateModel>> fetchTemplates() async {
    try {
      print('Making API call to fetch templates...');
      final response = await api.post('/api/event-templates/getAll', body: {});
      print('API response received: $response');
      
      if (response is List) {
        final templates = response
            .map((json) => EventTemplateModel.fromJson(json))
            .toList();
        print('Successfully parsed ${templates.length} templates');
        return templates;
      } else {
        print('Unexpected response format: ${response.runtimeType}');
        return [];
      }
    } catch (e) {
      print('Error in fetchTemplates: $e');
      rethrow;
    }
  }

  Future<EventTemplateModel> addTemplate(EventTemplateModel template) async {
    final response = await api.post('/api/event-templates', body: template.toJson());
    return EventTemplateModel.fromJson(response);
  }

  Future<Map<String, dynamic>> createTemplate(String name) async {
    print('Creating event template with name: $name');
    final response = await api.post('/api/event-templates/create', body: {
      'name': name,
    });
    print('Event template creation response: $response');
    return response;
  }

  Future<EventTemplateModel> updateTemplate(int id, EventTemplateModel template) async {
    final response = await api.put('/api/event-templates/$id', body: template.toJson());
    return EventTemplateModel.fromJson(response);
  }

  Future<void> deleteTemplate(int id) async {
    await api.delete('/api/event-templates/$id');
  }
}
