class YearModel {
  final int id;
  final String yearName;
  final DateTime createdAt;

  YearModel({
    required this.id,
    required this.yearName,
    required this.createdAt,
  });

  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
      id: json['id'],
      yearName: json['year_name'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year_name': yearName,
    };
  }
}
