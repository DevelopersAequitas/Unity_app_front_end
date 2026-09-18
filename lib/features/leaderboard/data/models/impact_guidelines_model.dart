class ImpactGuidelineItemModel {
  final String id;
  final String action;
  final String category;
  final int impactValue;
  final String impactUnit;
  final int displayOrder;

  const ImpactGuidelineItemModel({
    required this.id,
    required this.action,
    required this.category,
    required this.impactValue,
    required this.impactUnit,
    required this.displayOrder,
  });

  factory ImpactGuidelineItemModel.fromJson(Map<String, dynamic> json) {
    return ImpactGuidelineItemModel(
      id: json['id']?.toString() ?? '',
      action: (json['action'] ?? json['activity'] ?? json['title'] ?? '').toString(),
      category: (json['category'] ?? json['group'] ?? 'General').toString(),
      impactValue: int.tryParse(json['impact_value']?.toString() ?? json['impact']?.toString() ?? '1') ?? 1,
      impactUnit: (json['impact_unit'] ?? json['unit'] ?? 'Lives').toString(),
      displayOrder: int.tryParse(json['display_order']?.toString() ?? '0') ?? 0,
    );
  }
}

class ImpactGuidelinesModel {
  final String title;
  final String description;
  final String? icon;
  final List<ImpactGuidelineItemModel> guidelines;

  const ImpactGuidelinesModel({
    required this.title,
    required this.description,
    this.icon,
    required this.guidelines,
  });

  factory ImpactGuidelinesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    final rawList = data['guidelines'] as List<dynamic>? ?? [];
    final list = rawList
        .whereType<Map<String, dynamic>>()
        .map((e) => ImpactGuidelineItemModel.fromJson(e))
        .toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));

    return ImpactGuidelinesModel(
      title: data['title']?.toString() ?? 'Your Life Impact Score',
      description: data['description']?.toString() ??
          'Study this. Know it. Start counting from today. Every action below earns you impact — tracked in the Unity App.',
      icon: data['icon']?.toString(),
      guidelines: list,
    );
  }
}
