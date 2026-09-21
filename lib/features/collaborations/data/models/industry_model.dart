import '../../domain/entities/industry.dart';

class IndustryModel extends Industry {
  const IndustryModel({
    required super.id,
    required super.label,
  });

  factory IndustryModel.fromJson(Map<String, dynamic> json) {
    return IndustryModel(
      id: json['id']?.toString() ?? '',
      label: json['name']?.toString() ?? json['label']?.toString() ?? '',
    );
  }
}

class IndustryParentModel extends IndustryParent {
  const IndustryParentModel({
    required super.name,
    required super.children,
  });

  factory IndustryParentModel.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString() ?? '';
    final childrenRaw = json['children'] as List?;
    final children = childrenRaw != null
        ? childrenRaw
            .whereType<Map<String, dynamic>>()
            .map((e) => IndustryModel.fromJson(e))
            .toList()
        : <IndustryModel>[];

    return IndustryParentModel(
      name: name,
      children: children,
    );
  }
}
