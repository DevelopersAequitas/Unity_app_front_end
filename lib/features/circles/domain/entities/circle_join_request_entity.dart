import 'package:equatable/equatable.dart';

class CircleJoinRequestEntity extends Equatable {
  final String id;
  final String circleId;
  final String circleName;
  final String reasonForJoining;
  final String status;
  final String statusLabel;
  final String displayStatus;
  final String paymentStatus;
  final DateTime requestedAt;
  final String? cdApprovalStatus;
  final String? idApprovalStatus;
  final String? rejectionReason;
  final double? amount;
  final String? currency;
  final String? paymentUrl;

  const CircleJoinRequestEntity({
    required this.id,
    required this.circleId,
    required this.circleName,
    required this.reasonForJoining,
    required this.status,
    required this.statusLabel,
    required this.displayStatus,
    required this.paymentStatus,
    required this.requestedAt,
    this.cdApprovalStatus,
    this.idApprovalStatus,
    this.rejectionReason,
    this.amount,
    this.currency,
    this.paymentUrl,
  });

  bool get isApproved =>
      status.toLowerCase() == 'approved' ||
      displayStatus.toLowerCase() == 'approved';

  bool get isRejected =>
      status.toLowerCase() == 'rejected' ||
      displayStatus.toLowerCase() == 'rejected';

  @override
  List<Object?> get props => [
        id,
        circleId,
        circleName,
        reasonForJoining,
        status,
        statusLabel,
        displayStatus,
        paymentStatus,
        requestedAt,
        cdApprovalStatus,
        idApprovalStatus,
        rejectionReason,
        amount,
        currency,
        paymentUrl,
      ];
}
