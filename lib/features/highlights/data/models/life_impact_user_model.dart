import '../../domain/entities/life_impact_user_entity.dart';

class LifeImpactUserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String email;
  final int lifeImpactedCount;

  const LifeImpactUserModel({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.displayName = '',
    this.email = '',
    this.lifeImpactedCount = 0,
  });

  factory LifeImpactUserModel.fromJson(Map<String, dynamic> json) {
    return LifeImpactUserModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      displayName: json['display_name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      lifeImpactedCount: (json['life_impacted_count'] as num?)?.toInt() ?? 0,
    );
  }

  LifeImpactUserEntity toEntity() {
    return LifeImpactUserEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      email: email,
      lifeImpactedCount: lifeImpactedCount,
    );
  }
}
