import '../../domain/entities/category_item_entity.dart';

class CategoryItemModel {
  final dynamic id;
  final String name;
  final int level;
  final dynamic parentId;
  final bool isOther;
  final String? slug;

  const CategoryItemModel({
    required this.id,
    required this.name,
    this.level = 1,
    this.parentId,
    this.isOther = false,
    this.slug,
  });

  factory CategoryItemModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final isOther = json['is_other'] as bool? ?? (rawId == 'other');
    return CategoryItemModel(
      id: rawId,
      name: json['name'] as String? ?? '',
      level: json['level'] as int? ?? 1,
      parentId:
          json['parent_id'] ??
          json['circle_category_id'] ??
          json['level2_id'] ??
          json['level3_id'],
      isOther: isOther,
      slug: json['slug'] as String?,
    );
  }

  CategoryItemEntity toEntity() {
    return CategoryItemEntity(
      id: id,
      name: name,
      level: level,
      parentId: parentId,
      isOther: isOther,
      slug: slug,
    );
  }
}
