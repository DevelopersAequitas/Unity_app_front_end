import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/circle_join_request_entity.dart';

class CircleJoinRequestModel extends CircleJoinRequestEntity {
  const CircleJoinRequestModel({
    required super.id,
    required super.categoryId,
    required super.categoryName,
    super.level4CategoryId,
    super.level4CategoryName,
    required super.circleId,
    required super.circleName,
    required super.reasonForJoining,
    required super.status,
    required super.statusLabel,
    required super.displayStatus,
    required super.paymentStatus,
    required super.requestedAt,
    super.cdApprovalStatus,
    super.cdApprovedBy,
    super.cdApprovedAt,
    super.cdRejectedBy,
    super.cdRejectedAt,
    super.cdRejectionReason,
    super.idApprovalStatus,
    super.idApprovedBy,
    super.idApprovedAt,
    super.idRejectedBy,
    super.idRejectedAt,
    super.idRejectionReason,
    super.dedApprovalStatus,
    super.dedApprovedBy,
    super.dedApprovedAt,
    super.feeMarkedAt,
    super.feePaidAt,
    super.rejectionReason,
    super.amount,
    super.currency,
    super.paymentUrl,
    super.isPro = false,
    super.canPay = false,
  });

  factory CircleJoinRequestModel.fromJson(Map<String, dynamic> json) {
    final parsedDate = AppDateFormatter.parseUtc(
          json['requested_at'] ??
              json['created_at'] ??
              json['updated_at'] ??
              json['date'],
        ) ??
        DateTime.now();

    String catId = '';
    String catName = '';
    if (json['level1_category'] is Map<String, dynamic>) {
      catId = json['level1_category']['id']?.toString() ?? '';
      catName = json['level1_category']['name']?.toString() ?? '';
    } else if (json['category'] is Map<String, dynamic>) {
      catId = json['category']['id']?.toString() ?? '';
      catName = json['category']['name']?.toString() ?? '';
    } else if (json['circle'] is Map<String, dynamic> &&
        json['circle']['categories'] is List &&
        (json['circle']['categories'] as List).isNotEmpty) {
      final firstCat = (json['circle']['categories'] as List).first;
      if (firstCat is Map<String, dynamic>) {
        catId = firstCat['id']?.toString() ?? '';
        catName = firstCat['name']?.toString() ?? '';
      }
    }

    if (catId.isEmpty) {
      catId = json['category_id']?.toString() ??
          json['circle_id']?.toString() ??
          '';
    }
    if (catName.isEmpty) {
      catName = json['category_name']?.toString() ??
          json['circle_name']?.toString() ??
          '';
    }

    String? l4Id;
    String? l4Name;
    if (json['level4_category'] is Map<String, dynamic>) {
      l4Id = json['level4_category']['id']?.toString();
      l4Name = json['level4_category']['name']?.toString();
    } else if (json['level4_category_id'] != null) {
      l4Id = json['level4_category_id']?.toString();
      l4Name = json['level4_category_name']?.toString();
    }

    String cName = catName;
    if (cName.isEmpty) {
      if (json['circle'] is Map<String, dynamic>) {
        cName = (json['circle']['name'] ?? json['circle']['title'] ?? '').toString();
      }
      if (cName.isEmpty) {
        cName = json['circle_name']?.toString() ?? 'Circle';
      }
    }

    String? extractPersonName(dynamic val) {
      if (val == null) return null;
      if (val is Map<String, dynamic>) return val['name']?.toString() ?? val['username']?.toString();
      return val.toString();
    }

    DateTime? parseDate(dynamic val) => AppDateFormatter.parseUtc(val);

    String? cdApprStatus = json['cd_approval_status']?.toString();
    String? cdApprBy = extractPersonName(json['cd_approved_by']);
    DateTime? cdApprAt = parseDate(json['cd_approved_at']);
    String? cdRejBy = extractPersonName(json['cd_rejected_by']);
    DateTime? cdRejAt = parseDate(json['cd_rejected_at']);
    String? cdRejection = json['cd_rejection_reason']?.toString();

    if (json['cd_approval'] is Map<String, dynamic>) {
      final cdMap = json['cd_approval'] as Map<String, dynamic>;
      cdApprStatus ??= cdMap['status']?.toString();
      cdApprBy ??= extractPersonName(cdMap['approved_by']);
      cdApprAt ??= parseDate(cdMap['approved_at']);
      cdRejBy ??= extractPersonName(cdMap['rejected_by']);
      cdRejAt ??= parseDate(cdMap['rejected_at']);
      cdRejection ??= cdMap['rejection_reason']?.toString();
    }

    String? idApprStatus = json['id_approval_status']?.toString();
    String? idApprBy = extractPersonName(json['id_approved_by']);
    DateTime? idApprAt = parseDate(json['id_approved_at']);
    String? idRejBy = extractPersonName(json['id_rejected_by']);
    DateTime? idRejAt = parseDate(json['id_rejected_at']);
    String? idRejection = json['id_rejection_reason']?.toString();

    if (json['id_approval'] is Map<String, dynamic>) {
      final idMap = json['id_approval'] as Map<String, dynamic>;
      idApprStatus ??= idMap['status']?.toString();
      idApprBy ??= extractPersonName(idMap['approved_by']);
      idApprAt ??= parseDate(idMap['approved_at']);
      idRejBy ??= extractPersonName(idMap['rejected_by']);
      idRejAt ??= parseDate(idMap['rejected_at']);
      idRejection ??= idMap['rejection_reason']?.toString();
    }

    final dedApprBy = extractPersonName(json['ded_approved_by']);
    final dedApprAt = parseDate(json['ded_approved_at']);

    final feeMarkedAt = parseDate(json['fee_marked_at']);
    final feePaidAt = parseDate(json['fee_paid_at'] ?? (json['payment'] is Map ? json['payment']['paid_at'] : null));

    final generalRejection = cdRejection ??
        idRejection ??
        (json['rejection'] is Map ? json['rejection']['reason']?.toString() : null) ??
        json['rejection_reason']?.toString();

    double? amt;
    String? curr;
    String? payUrl;
    if (json['payment'] is Map<String, dynamic>) {
      final p = json['payment'] as Map<String, dynamic>;
      amt = double.tryParse(p['amount']?.toString() ?? p['fee']?.toString() ?? '');
      curr = p['currency']?.toString();
      payUrl = p['payment_url']?.toString() ?? p['payment_link']?.toString() ?? p['checkout_url']?.toString() ?? p['url']?.toString();
    }

    amt ??= double.tryParse(json['fee_amount']?.toString() ?? json['amount']?.toString() ?? json['fee']?.toString() ?? '');
    curr ??= json['currency']?.toString() ?? 'INR';
    payUrl ??= json['payment_url']?.toString() ?? json['payment_link']?.toString() ?? json['checkout_url']?.toString() ?? json['pay_url']?.toString();

    final isPro = json['is_pro'] == true || json['is_pro'] == 1 || json['is_pro'] == '1' || json['is_pro'] == 'true';
    final canPay = json['can_pay'] == true || json['can_pay'] == 1 || json['can_pay'] == '1' || json['can_pay'] == 'true';

    final status = json['status']?.toString() ?? 'pending';
    final statusLabel = json['status_label']?.toString() ?? 'Under Review';
    final displayStatus = json['display_status']?.toString() ?? statusLabel;

    return CircleJoinRequestModel(
      id: json['id']?.toString() ?? '',
      categoryId: catId,
      categoryName: catName.isNotEmpty ? catName : cName,
      level4CategoryId: l4Id,
      level4CategoryName: l4Name,
      circleId: json['circle_id']?.toString() ?? catId,
      circleName: cName,
      reasonForJoining: json['reason_for_joining']?.toString() ??
          json['reason']?.toString() ??
          '',
      status: status,
      statusLabel: statusLabel,
      displayStatus: displayStatus,
      paymentStatus: json['payment_status']?.toString() ?? 'unpaid',
      requestedAt: parsedDate,
      cdApprovalStatus: cdApprStatus,
      cdApprovedBy: cdApprBy,
      cdApprovedAt: cdApprAt,
      cdRejectedBy: cdRejBy,
      cdRejectedAt: cdRejAt,
      cdRejectionReason: cdRejection,
      idApprovalStatus: idApprStatus,
      idApprovedBy: idApprBy,
      idApprovedAt: idApprAt,
      idRejectedBy: idRejBy,
      idRejectedAt: idRejAt,
      idRejectionReason: idRejection,
      dedApprovalStatus: json['ded_approval_status']?.toString(),
      dedApprovedBy: dedApprBy,
      dedApprovedAt: dedApprAt,
      feeMarkedAt: feeMarkedAt,
      feePaidAt: feePaidAt,
      rejectionReason: generalRejection,
      amount: amt,
      currency: curr,
      paymentUrl: payUrl,
      isPro: isPro,
      canPay: canPay,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'category_name': categoryName,
      'level4_category_id': level4CategoryId,
      'level4_category_name': level4CategoryName,
      'circle_id': circleId,
      'circle_name': circleName,
      'reason_for_joining': reasonForJoining,
      'status': status,
      'status_label': statusLabel,
      'display_status': displayStatus,
      'payment_status': paymentStatus,
      'payment_url': paymentUrl,
      'amount': amount,
      'currency': currency,
      'is_pro': isPro,
      'can_pay': canPay,
      'requested_at': requestedAt.toIso8601String(),
    };
  }
}
