import '../../domain/entities/circle_open_category_entity.dart';

class CircleOpenCategoryModel extends CircleOpenCategoryEntity {
  const CircleOpenCategoryModel({
    required super.id,
    required super.name,
    super.level,
    super.isClosed,
    super.children,
  });

  factory CircleOpenCategoryModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] ?? json['subcategories'] ?? [];
    List<CircleOpenCategoryModel> parsedChildren = [];
    if (rawChildren is List) {
      parsedChildren = rawChildren
          .whereType<Map<String, dynamic>>()
          .map((c) => CircleOpenCategoryModel.fromJson(c))
          .toList();
    }

    return CircleOpenCategoryModel(
      id: (json['id'] ?? json['category_id'] ?? '').toString(),
      name: (json['name'] ?? json['category_name'] ?? json['title'] ?? '').toString(),
      level: (json['level'] is num) ? (json['level'] as num).toInt() : 2,
      isClosed: json['is_closed'] == true || json['closed'] == true,
      children: parsedChildren,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'level': level,
      'is_closed': isClosed,
      'children': children
          .map((c) => (c is CircleOpenCategoryModel) ? c.toJson() : {
                'id': c.id,
                'name': c.name,
                'level': c.level,
                'is_closed': c.isClosed,
              })
          .toList(),
    };
  }
}
