import '../models/event_model.dart';
import 'api_service.dart';

class EventService {
  final ApiService api;

  EventService(this.api);

  Future<List<EventModel>> fetchEvents() async {
    final response = await api.get('/events');
    return (response as List)
        .map((json) => EventModel.fromJson(json))
        .toList();
  }

  Future<EventModel> createEvent(EventModel event) async {
    final response = await api.post('/events', body: event.toJson());
    return EventModel.fromJson(response);
  }

  Future<EventModel> updateEvent(int id, EventModel event) async {
    final response = await api.put('/events/$id', body: event.toJson());
    return EventModel.fromJson(response);
  }

  Future<void> deleteEvent(int id) async {
    await api.delete('/events/$id');
  }
}
