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

  bool get isPendingCdApproval => status.toLowerCase() == 'pending_cd_approval';
  bool get isPendingIdApproval => status.toLowerCase() == 'pending_id_approval';
  bool get isPendingCircleFee =>
      status.toLowerCase() == 'pending_circle_fee' || canPay;
  bool get isMember =>
      status.toLowerCase() == 'paid' ||
      status.toLowerCase() == 'circle_member' ||
      isApproved;

  bool get isRejectedByCd => status.toLowerCase() == 'rejected_by_cd';
  bool get isRejectedById => status.toLowerCase() == 'rejected_by_id';
  bool get isCancelled => status.toLowerCase() == 'cancelled';

  bool get isApproved =>
      status.toLowerCase() == 'approved' ||
      displayStatus.toLowerCase() == 'approved' ||
      status.toLowerCase() == 'active' ||
      status.toLowerCase() == 'paid' ||
      status.toLowerCase() == 'circle_member';

  bool get isRejected =>
      status.toLowerCase().contains('rejected') ||
      displayStatus.toLowerCase().contains('rejected');

  String get effectiveRejectionReason =>
      cdRejectionReason ?? idRejectionReason ?? rejectionReason ?? '';

  bool get isCdApproved {
    if (isPendingCdApproval || isRejectedByCd || isCancelled) return false;
    if (cdApprovalStatus?.toLowerCase() == 'pending' ||
        cdApprovalStatus?.toLowerCase() == 'rejected') {
      return false;
    }
    return cdApprovalStatus?.toLowerCase() == 'approved' ||
        status.toLowerCase() == 'pending_id_approval' ||
        status.toLowerCase() == 'pending_circle_fee' ||
        status.toLowerCase().contains('approved_by_cd') ||
        (cdApprovedAt != null && cdApprovalStatus?.toLowerCase() != 'pending') ||
        isApproved;
  }

  bool get isIdApproved {
    if (isPendingCdApproval ||
        isPendingIdApproval ||
        isRejectedByCd ||
        isRejectedById ||
        isCancelled) {
      return false;
    }
    if (idApprovalStatus?.toLowerCase() == 'pending' ||
        idApprovalStatus?.toLowerCase() == 'rejected') {
      return false;
    }
    return idApprovalStatus?.toLowerCase() == 'approved' ||
        status.toLowerCase() == 'pending_circle_fee' ||
        status.toLowerCase().contains('approved_by_id') ||
        (idApprovedAt != null && idApprovalStatus?.toLowerCase() != 'pending') ||
        isApproved;
  }

  bool get isPaymentRequired =>
      !isPaid &&
      isCdApproved &&
      isIdApproved &&
      (canPay ||
          status.toLowerCase() == 'pending_circle_fee' ||
          (paymentUrl != null && paymentUrl!.isNotEmpty));

  bool get isPaid =>
      paymentStatus.toLowerCase() == 'paid' ||
      status.toLowerCase() == 'paid' ||
      status.toLowerCase() == 'circle_member' ||
      feePaidAt != null ||
      status.toLowerCase() == 'approved';

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
