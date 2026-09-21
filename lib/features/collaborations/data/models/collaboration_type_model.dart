import '../../domain/entities/collaboration_type.dart';

class CollaborationTypeModel extends CollaborationType {
  const CollaborationTypeModel({
    required super.id,
    required super.label,
  });

  factory CollaborationTypeModel.fromJson(Map<String, dynamic> json) {
    return CollaborationTypeModel(
      id: json['id']?.toString() ?? '',
      label: json['name']?.toString() ?? json['label']?.toString() ?? '',
    );
  }
}
