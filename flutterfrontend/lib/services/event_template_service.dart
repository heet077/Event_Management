import '../models/event_template_model.dart';
import 'api_service.dart';

class EventTemplateService {
  final ApiService api;

  EventTemplateService(this.api);

  Future<List<EventTemplateModel>> fetchTemplates() async {
    final response = await api.get('/event-templates');
    return (response as List)
        .map((json) => EventTemplateModel.fromJson(json))
        .toList();
  }

  Future<EventTemplateModel> addTemplate(EventTemplateModel template) async {
    final response = await api.post('/event-templates', body: template.toJson());
    return EventTemplateModel.fromJson(response);
  }

  Future<EventTemplateModel> updateTemplate(int id, EventTemplateModel template) async {
    final response = await api.put('/event-templates/$id', body: template.toJson());
    return EventTemplateModel.fromJson(response);
  }

  Future<void> deleteTemplate(int id) async {
    await api.delete('/event-templates/$id');
  }
}
