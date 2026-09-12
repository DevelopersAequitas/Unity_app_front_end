import '../../domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String? name;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final int lifeImpactedCount;
  final int coinsBalance;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
    this.displayName,
    this.firstName,
    this.lastName,
    this.avatarUrl,
    this.lifeImpactedCount = 0,
    this.coinsBalance = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final lifeImpact = json['life_impacted_count'] ?? json['lives_impacted'];
    final coins = json['coins_balance'] ?? json['coins'];

    return UserModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: json['name'] as String?,
      displayName: (json['display_name'] ?? json['displayName']) as String?,
      firstName: (json['first_name'] ?? json['firstName']) as String?,
      lastName: (json['last_name'] ?? json['lastName']) as String?,
      avatarUrl: (json['avatar_url'] ??
              json['avatar'] ??
              json['profile_photo_url']) as
          String?,
      lifeImpactedCount: lifeImpact is int
          ? lifeImpact
          : int.tryParse(lifeImpact?.toString() ?? '0') ?? 0,
      coinsBalance: coins is int
          ? coins
          : int.tryParse(coins?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'display_name': displayName,
      'first_name': firstName,
      'last_name': lastName,
      'avatar_url': avatarUrl,
      'life_impacted_count': lifeImpactedCount,
      'coins_balance': coinsBalance,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      avatarUrl: avatarUrl,
      lifeImpactedCount: lifeImpactedCount,
      coinsBalance: coinsBalance,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      displayName: entity.displayName,
      firstName: entity.firstName,
      lastName: entity.lastName,
      avatarUrl: entity.avatarUrl,
      lifeImpactedCount: entity.lifeImpactedCount,
      coinsBalance: entity.coinsBalance,
    );
  }
}
