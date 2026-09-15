import 'package:equatable/equatable.dart';

class SubscriptionStatusEntity extends Equatable {
  final bool isPro;
  final String membershipStatus;
  final DateTime? membershipStartsAt;
  final DateTime? membershipEndsAt;
  final String? zohoSubscriptionId;
  final String? zohoPlanCode;
  final String hostedPageStatus;

  const SubscriptionStatusEntity({
    required this.isPro,
    required this.membershipStatus,
    this.membershipStartsAt,
    this.membershipEndsAt,
    this.zohoSubscriptionId,
    this.zohoPlanCode,
    required this.hostedPageStatus,
  });

  bool get isSuccessful =>
      isPro ||
      hostedPageStatus.toLowerCase() == 'success' ||
      hostedPageStatus.toLowerCase() == 'completed';

  @override
  List<Object?> get props => [
        isPro,
        membershipStatus,
        membershipStartsAt,
        membershipEndsAt,
        zohoSubscriptionId,
        zohoPlanCode,
        hostedPageStatus,
      ];
}
