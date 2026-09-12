import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? avatarUrl;
  final int lifeImpactedCount;
  final int coinsBalance;

  const UserEntity({
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

  String get effectiveDisplayName {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!.trim();
    }
    final fullName = '${firstName ?? ''} ${lastName ?? ''}'.trim();
    if (fullName.isNotEmpty) return fullName;
    if (name != null && name!.trim().isNotEmpty) return name!.trim();
    return email.split('@').first;
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    displayName,
    firstName,
    lastName,
    avatarUrl,
    lifeImpactedCount,
    coinsBalance,
  ];
}
