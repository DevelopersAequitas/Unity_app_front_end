import 'package:equatable/equatable.dart';

class ReferrerCircleEntity extends Equatable {
  final String id;
  final String name;

  const ReferrerCircleEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}

class ReferrerEntity extends Equatable {
  final String id;
  final String? name;
  final String? email;
  final String? companyName;
  final String? city;
  final ReferrerCircleEntity? circle;

  const ReferrerEntity({
    required this.id,
    this.name,
    this.email,
    this.companyName,
    this.city,
    this.circle,
  });

  @override
  List<Object?> get props => [id, name, email, companyName, city, circle];
}

class ReferralValidationEntity extends Equatable {
  final bool valid;
  final String? referralCode;
  final String? referralLink;
  final ReferrerEntity? referrer;
  final String? referrerName;

  const ReferralValidationEntity({
    required this.valid,
    this.referralCode,
    this.referralLink,
    this.referrer,
    this.referrerName,
  });

  String get displayName =>
      referrer?.name ?? referrerName ?? (valid ? 'Verified Peer' : '');

  @override
  List<Object?> get props => [
    valid,
    referralCode,
    referralLink,
    referrer,
    referrerName,
  ];
}
