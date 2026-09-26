import '../../domain/entities/ask_flow_entity.dart';

class AskFlowModel extends AskFlowEntity {
  const AskFlowModel({
    required super.id,
    required super.code,
    required super.name,
    required super.description,
    super.icon,
    super.sortOrder,
    super.isActive,
    super.metadata,
  });

  factory AskFlowModel.fromJson(Map<String, dynamic> json) {
    return AskFlowModel(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString(),
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] == true || json['is_active'] == 1,
      metadata: json['metadata'] is List ? (json['metadata'] as List) : const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'icon': icon,
      'sort_order': sortOrder,
      'is_active': isActive,
      'metadata': metadata,
    };
  }

  AskFlowEntity toEntity() => this;
}
