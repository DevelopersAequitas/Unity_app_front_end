import 'package:equatable/equatable.dart';

class SubscriptionHistoryEntity extends Equatable {
  final String id;
  final String planId;
  final String planName;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String status;
  final bool isCirclePayment;

  const SubscriptionHistoryEntity({
    required this.id,
    required this.planId,
    required this.planName,
    this.startsAt,
    this.endsAt,
    required this.status,
    this.isCirclePayment = false,
  });

  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object?> get props => [
        id,
        planId,
        planName,
        startsAt,
        endsAt,
        status,
        isCirclePayment,
      ];
}
