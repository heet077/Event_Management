class EventModel {
  final int id;
  final int templateId;
  final int yearId;
  final DateTime date;
  final String location;
  final String? description;
  final String? coverImage;
  final DateTime createdAt;

  EventModel({
    required this.id,
    required this.templateId,
    required this.yearId,
    required this.date,
    required this.location,
    this.description,
    this.coverImage,
    required this.createdAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      templateId: json['template_id'],
      yearId: json['year_id'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      description: json['description'],
      coverImage: json['cover_image'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'template_id': templateId,
      'year_id': yearId,
      'date': date.toIso8601String(),
      'location': location,
      'description': description,
      'cover_image': coverImage,
    };
  }
}
