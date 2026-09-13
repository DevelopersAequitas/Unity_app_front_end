import '../../domain/entities/circle_join_request_entity.dart';

class CircleJoinRequestModel extends CircleJoinRequestEntity {
  const CircleJoinRequestModel({
    required super.id,
    required super.circleId,
    required super.circleName,
    required super.reasonForJoining,
    required super.status,
    required super.statusLabel,
    required super.displayStatus,
    required super.paymentStatus,
    required super.requestedAt,
    super.cdApprovalStatus,
    super.idApprovalStatus,
    super.rejectionReason,
    super.amount,
    super.currency,
    super.paymentUrl,
  });

  factory CircleJoinRequestModel.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    try {
      final raw = json['requested_at'] ?? json['created_at'];
      parsedDate = raw != null ? DateTime.parse(raw.toString()) : DateTime.now();
    } catch (_) {
      parsedDate = DateTime.now();
    }

    String cName = '';
    if (json['circle'] is Map<String, dynamic>) {
      cName = (json['circle']['name'] ?? json['circle']['title'] ?? '').toString();
    }
    if (cName.isEmpty) {
      cName = json['circle_name']?.toString() ?? 'Circle';
    }

    final cdApproval = json['cd_approval'] is Map<String, dynamic>
        ? json['cd_approval']['status']?.toString()
        : null;
    final idApproval = json['id_approval'] is Map<String, dynamic>
        ? json['id_approval']['status']?.toString()
        : null;

    final rejection = json['rejection'] is Map<String, dynamic>
        ? json['rejection']['reason']?.toString()
        : json['rejection_reason']?.toString();

    double? amt;
    String? curr;
    String? payUrl;
    if (json['payment'] is Map<String, dynamic>) {
      final p = json['payment'] as Map<String, dynamic>;
      amt = double.tryParse(p['amount']?.toString() ?? '');
      curr = p['currency']?.toString();
      payUrl = p['payment_url']?.toString();
    }

    final status = json['status']?.toString() ?? 'pending';
    final statusLabel = json['status_label']?.toString() ?? 'Under Review';
    final displayStatus = json['display_status']?.toString() ?? statusLabel;

    return CircleJoinRequestModel(
      id: json['id']?.toString() ?? '',
      circleId: json['circle_id']?.toString() ?? '',
      circleName: cName,
      reasonForJoining: json['reason_for_joining']?.toString() ??
          json['reason']?.toString() ??
          '',
      status: status,
      statusLabel: statusLabel,
      displayStatus: displayStatus,
      paymentStatus: json['payment_status']?.toString() ?? 'unpaid',
      requestedAt: parsedDate,
      cdApprovalStatus: cdApproval,
      idApprovalStatus: idApproval,
      rejectionReason: rejection,
      amount: amt,
      currency: curr,
      paymentUrl: payUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'circle_id': circleId,
      'circle_name': circleName,
      'reason_for_joining': reasonForJoining,
      'status': status,
      'status_label': statusLabel,
      'display_status': displayStatus,
      'payment_status': paymentStatus,
      'requested_at': requestedAt.toIso8601String(),
    };
  }
}
