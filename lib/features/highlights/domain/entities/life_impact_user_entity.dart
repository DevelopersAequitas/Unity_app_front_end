import 'package:equatable/equatable.dart';

class LifeImpactUserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String email;
  final int lifeImpactedCount;

  const LifeImpactUserEntity({
    this.id = '',
    this.firstName = '',
    this.lastName = '',
    this.displayName = '',
    this.email = '',
    this.lifeImpactedCount = 0,
  });

  String get fullName {
    if (displayName.isNotEmpty) return displayName;
    final name = '$firstName $lastName'.trim();
    return name.isNotEmpty ? name : 'Peer';
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        displayName,
        email,
        lifeImpactedCount,
      ];
}
