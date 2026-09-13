import '../../domain/entities/circle_category_entity.dart';

class CircleCategoryModel extends CircleCategoryEntity {
  const CircleCategoryModel({
    required super.id,
    required super.name,
    super.slug,
    super.circleKey,
    super.level = 1,
    super.sortOrder = 0,
    super.isActive = true,
    super.memberCount = 0,
    super.childLevel2Count = 0,
    super.childLevel3Count = 0,
    super.childLevel4Count = 0,
    super.iconUrl,
  });

  factory CircleCategoryModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, [int fallback = 0]) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    bool parseBool(dynamic value, [bool fallback = true]) {
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return fallback;
    }

    return CircleCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString(),
      circleKey: json['circle_key']?.toString() ?? json['key']?.toString(),
      level: parseInt(json['level'], 1),
      sortOrder: parseInt(json['sort_order'], 0),
      isActive: parseBool(json['is_active'], true),
      memberCount: parseInt(
        json['members_count'] ?? json['member_count'] ?? json['count'],
        0,
      ),
      childLevel2Count: parseInt(json['child_level2_count'], 0),
      childLevel3Count: parseInt(json['child_level3_count'], 0),
      childLevel4Count: parseInt(json['child_level4_count'], 0),
      iconUrl: json['icon_url']?.toString() ?? json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'circle_key': circleKey,
      'level': level,
      'sort_order': sortOrder,
      'is_active': isActive,
      'members_count': memberCount,
      'child_level2_count': childLevel2Count,
      'child_level3_count': childLevel3Count,
      'child_level4_count': childLevel4Count,
      'icon_url': iconUrl,
    };
  }
}
