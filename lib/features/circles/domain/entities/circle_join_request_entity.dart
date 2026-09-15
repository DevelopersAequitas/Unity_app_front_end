import 'package:equatable/equatable.dart';

class CircleJoinRequestEntity extends Equatable {
  final String id;
  final String categoryId;
  final String categoryName;
  final String? level4CategoryId;
  final String? level4CategoryName;
  final String circleId;
  final String circleName;
  final String reasonForJoining;
  final String status;
  final String statusLabel;
  final String displayStatus;
  final String paymentStatus;
  final DateTime requestedAt;
  final String? cdApprovalStatus;
  final String? cdApprovedBy;
  final DateTime? cdApprovedAt;
  final String? cdRejectedBy;
  final DateTime? cdRejectedAt;
  final String? cdRejectionReason;
  final String? idApprovalStatus;
  final String? idApprovedBy;
  final DateTime? idApprovedAt;
  final String? idRejectedBy;
  final DateTime? idRejectedAt;
  final String? idRejectionReason;
  final String? dedApprovalStatus;
  final String? dedApprovedBy;
  final DateTime? dedApprovedAt;
  final DateTime? feeMarkedAt;
  final DateTime? feePaidAt;
  final String? rejectionReason;
  final double? amount;
  final String? currency;
  final String? paymentUrl;
  final bool isPro;
  final bool canPay;

  const CircleJoinRequestEntity({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    this.level4CategoryId,
    this.level4CategoryName,
    required this.circleId,
    required this.circleName,
    required this.reasonForJoining,
    required this.status,
    required this.statusLabel,
    required this.displayStatus,
    required this.paymentStatus,
    required this.requestedAt,
    this.cdApprovalStatus,
    this.cdApprovedBy,
    this.cdApprovedAt,
    this.cdRejectedBy,
    this.cdRejectedAt,
    this.cdRejectionReason,
    this.idApprovalStatus,
    this.idApprovedBy,
    this.idApprovedAt,
    this.idRejectedBy,
    this.idRejectedAt,
    this.idRejectionReason,
    this.dedApprovalStatus,
    this.dedApprovedBy,
    this.dedApprovedAt,
    this.feeMarkedAt,
    this.feePaidAt,
    this.rejectionReason,
    this.amount,
    this.currency,
    this.paymentUrl,
    this.isPro = false,
    this.canPay = false,
  });

  bool get isApproved =>
      status.toLowerCase() == 'approved' ||
      displayStatus.toLowerCase() == 'approved' ||
      status.toLowerCase() == 'active';

  bool get isRejected =>
      status.toLowerCase().contains('rejected') ||
      displayStatus.toLowerCase().contains('rejected');

  String get effectiveRejectionReason =>
      cdRejectionReason ?? idRejectionReason ?? rejectionReason ?? '';

  bool get isCdApproved =>
      cdApprovedAt != null ||
      (cdApprovedBy != null && cdApprovedBy!.isNotEmpty) ||
      cdApprovalStatus?.toLowerCase() == 'approved' ||
      status.toLowerCase().contains('approved_by_cd') ||
      status.toLowerCase().contains('pending_id') ||
      status.toLowerCase().contains('pending_ded') ||
      status.toLowerCase().contains('fee') ||
      isApproved;

  bool get isIdApproved =>
      idApprovedAt != null ||
      (idApprovedBy != null && idApprovedBy!.isNotEmpty) ||
      idApprovalStatus?.toLowerCase() == 'approved' ||
      status.toLowerCase().contains('approved_by_id') ||
      status.toLowerCase().contains('pending_ded') ||
      status.toLowerCase().contains('fee') ||
      isApproved;

  bool get isPaymentRequired =>
      (paymentUrl != null && paymentUrl!.isNotEmpty) ||
      feeMarkedAt != null ||
      status.toLowerCase().contains('fee') ||
      status.toLowerCase().contains('payment') ||
      paymentStatus.toLowerCase() == 'unpaid' ||
      paymentStatus.toLowerCase() == 'pending';

  bool get isPaid =>
      paymentStatus.toLowerCase() == 'paid' ||
      feePaidAt != null ||
      isApproved;

  @override
  List<Object?> get props => [
        id,
        categoryId,
        categoryName,
        level4CategoryId,
        level4CategoryName,
        circleId,
        circleName,
        reasonForJoining,
        status,
        statusLabel,
        displayStatus,
        paymentStatus,
        requestedAt,
        cdApprovalStatus,
        cdApprovedBy,
        cdApprovedAt,
        cdRejectedBy,
        cdRejectedAt,
        cdRejectionReason,
        idApprovalStatus,
        idApprovedBy,
        idApprovedAt,
        idRejectedBy,
        idRejectedAt,
        idRejectionReason,
        dedApprovalStatus,
        dedApprovedBy,
        dedApprovedAt,
        feeMarkedAt,
        feePaidAt,
        rejectionReason,
        amount,
        currency,
        paymentUrl,
        isPro,
        canPay,
      ];
}
