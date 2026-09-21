import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/subscription_history_entity.dart';

class SubscriptionHistoryModel extends SubscriptionHistoryEntity {
  const SubscriptionHistoryModel({
    required super.id,
    required super.planId,
    required super.planName,
    super.startsAt,
    super.endsAt,
    required super.status,
    super.isCirclePayment = false,
  });

  factory SubscriptionHistoryModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) => AppDateFormatter.parseUtc(val);

    String planId = '';
    String planName = 'Pro Membership';
    if (json['membership_plan'] is Map<String, dynamic>) {
      final p = json['membership_plan'] as Map<String, dynamic>;
      planId = p['id']?.toString() ?? p['plan_code']?.toString() ?? '';
      planName = p['name']?.toString() ?? planName;
    } else if (json['plan_code'] != null) {
      planId = json['plan_code'].toString();
      planName = json['plan_name']?.toString() ?? planName;
    }

    return SubscriptionHistoryModel(
      id: json['id']?.toString() ?? '',
      planId: planId,
      planName: planName,
      startsAt: parseDate(json['starts_at']),
      endsAt: parseDate(json['ends_at']),
      status: json['status']?.toString() ?? 'active',
      isCirclePayment: json['is_circle_payment'] == true ||
          json['circle_payment']?.toString().toLowerCase() == 'yes',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_id': planId,
      'plan_name': planName,
      'starts_at': startsAt?.toIso8601String(),
      'ends_at': endsAt?.toIso8601String(),
      'status': status,
      'is_circle_payment': isCirclePayment,
    };
  }
}
