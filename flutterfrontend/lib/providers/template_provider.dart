import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_template_model.dart';
import '../services/event_template_service.dart';
import 'api_provider.dart';

final templateServiceProvider = Provider<EventTemplateService>((ref) {
  final api = ref.read(apiServiceProvider);
  return EventTemplateService(api);
});

final templateProvider =
StateNotifierProvider<TemplateNotifier, List<EventTemplateModel>>((ref) {
  final service = ref.read(templateServiceProvider);
  return TemplateNotifier(ref, service);
});

class TemplateNotifier extends StateNotifier<List<EventTemplateModel>> {
  final Ref ref;
  final EventTemplateService service;

  TemplateNotifier(this.ref, this.service) : super([]);

  Future<void> fetchTemplates() async {
    try {
      print('Fetching templates from API...');
      final templates = await service.fetchTemplates();
      print('Successfully fetched ${templates.length} templates');
      state = templates;
    } catch (e) {
      print('Error fetching templates: $e');
      // Keep the current state on error, don't clear it
    }
  }

  Future<void> addTemplate(EventTemplateModel template) async {
    try {
      await service.addTemplate(template);
      await fetchTemplates();
    } catch (e) {
      print('Error adding template: $e');
    }
  }

  Future<void> updateTemplate(int id, EventTemplateModel template) async {
    try {
      await service.updateTemplate(id, template);
      await fetchTemplates();
    } catch (e) {
      print('Error updating template: $e');
    }
  }

  Future<void> deleteTemplate(int id) async {
    try {
      await service.deleteTemplate(id);
      await fetchTemplates();
    } catch (e) {
      print('Error deleting template: $e');
    }
  }
}
