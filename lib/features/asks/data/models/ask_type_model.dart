import '../../domain/entities/ask_type_entity.dart';

class AskTypeModel extends AskTypeEntity {
  const AskTypeModel({
    required super.id,
    required super.flowId,
    super.parentId,
    required super.code,
    required super.name,
    super.description,
    super.level,
    super.sortOrder,
    super.isActive,
    super.children,
    super.metadata,
  });

  factory AskTypeModel.fromJson(Map<String, dynamic> json) {
    return AskTypeModel(
      id: json['id']?.toString() ?? '',
      flowId: json['flow_id']?.toString() ?? '',
      parentId: json['parent_id']?.toString(),
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      level: (json['level'] as num?)?.toInt() ?? 1,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      children: json['children'] is List ? (json['children'] as List) : const [],
      metadata: json['metadata'] is List ? (json['metadata'] as List) : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'flow_id': flowId,
      'parent_id': parentId,
      'code': code,
      'name': name,
      'description': description,
      'level': level,
      'sort_order': sortOrder,
      'is_active': isActive,
      'children': children,
      'metadata': metadata,
    };
  }

  AskTypeEntity toEntity() => this;
}
