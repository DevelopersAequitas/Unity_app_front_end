import '../../domain/entities/claim_activity_entity.dart';

class ClaimActivityFieldModel {
  final String key;
  final String label;
  final String type;
  final bool required;
  final String? placeholder;

  const ClaimActivityFieldModel({
    required this.key,
    required this.label,
    this.type = 'text',
    this.required = true,
    this.placeholder,
  });

  factory ClaimActivityFieldModel.fromJson(Map<String, dynamic> json) {
    return ClaimActivityFieldModel(
      key: json['key']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      required: json['required'] == true,
      placeholder: json['placeholder']?.toString() ?? json['hint']?.toString(),
    );
  }

  ClaimActivityFieldEntity toEntity() {
    return ClaimActivityFieldEntity(
      key: key,
      label: label,
      type: type,
      required: required,
      placeholder: placeholder,
    );
  }
}

class ClaimActivityModel {
  final String code;
  final String label;
  final int coins;
  final String description;
  final List<ClaimActivityFieldModel> fields;

  const ClaimActivityModel({
    required this.code,
    required this.label,
    this.coins = 0,
    this.description = '',
    this.fields = const [],
  });

  factory ClaimActivityModel.fromJson(Map<String, dynamic> json) {
    List<ClaimActivityFieldModel> parsedFields = [];
    if (json['fields'] is List) {
      parsedFields = (json['fields'] as List)
          .whereType<Map<String, dynamic>>()
          .map((f) => ClaimActivityFieldModel.fromJson(f))
          .toList();
    }

    return ClaimActivityModel(
      code: json['code']?.toString() ?? '',
      label: json['label']?.toString() ?? json['title']?.toString() ?? 'Activity',
      coins: (json['coins'] ?? json['coins_awarded'] ?? json['reward'] ?? 0) as int,
      description: json['description']?.toString() ?? '',
      fields: parsedFields,
    );
  }

  ClaimActivityEntity toEntity() {
    return ClaimActivityEntity(
      code: code,
      label: label,
      coins: coins,
      description: description,
      fields: fields.map((f) => f.toEntity()).toList(),
    );
  }
}
