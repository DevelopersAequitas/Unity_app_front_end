import '../../domain/entities/life_impact_entity.dart';

class LifeImpactModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int impactPoints;
  final String date;

  const LifeImpactModel({
    required this.id,
    required this.title,
    this.description = '',
    this.category = '',
    this.impactPoints = 1,
    this.date = '',
  });

  factory LifeImpactModel.fromJson(Map<String, dynamic> json) {
    final titleRaw = json['title']?.toString() ??
        json['action_label']?.toString() ??
        json['activity_name']?.toString() ??
        'Life Impact';
    final descRaw = json['description']?.toString() ??
        json['story_to_share']?.toString() ??
        json['remarks']?.toString() ??
        '';
    final catRaw = json['category']?.toString() ??
        json['activity_type']?.toString() ??
        'Collaboration';
    final pts = (json['impact_value'] ?? json['impact'] ?? json['points'] ?? 1) as int;
    final dateRaw = json['created_at']?.toString() ?? json['date']?.toString() ?? '';

    return LifeImpactModel(
      id: json['id']?.toString() ?? '',
      title: titleRaw,
      description: descRaw,
      category: catRaw,
      impactPoints: pts,
      date: dateRaw,
    );
  }

  LifeImpactEntity toEntity() {
    return LifeImpactEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      impactPoints: impactPoints,
      date: date,
    );
  }
}
