import '../../domain/entities/subscription_status_entity.dart';

class SubscriptionStatusModel extends SubscriptionStatusEntity {
  const SubscriptionStatusModel({
    required super.isPro,
    required super.membershipStatus,
    super.membershipStartsAt,
    super.membershipEndsAt,
    super.zohoSubscriptionId,
    super.zohoPlanCode,
    required super.hostedPageStatus,
  });

  factory SubscriptionStatusModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      try {
        return DateTime.parse(val.toString());
      } catch (_) {
        return null;
      }
    }

    final isPro = json['is_pro'] == true ||
        json['is_pro'] == 1 ||
        json['is_pro'] == '1' ||
        json['is_pro'] == 'true';

    return SubscriptionStatusModel(
      isPro: isPro,
      membershipStatus: json['membership_status']?.toString() ??
          (isPro ? 'pro_member' : 'free'),
      membershipStartsAt: parseDate(json['membership_starts_at'] ?? json['starts_at']),
      membershipEndsAt: parseDate(json['membership_ends_at'] ?? json['ends_at']),
      zohoSubscriptionId: json['zoho_subscription_id']?.toString() ??
          json['subscription_id']?.toString(),
      zohoPlanCode: json['zoho_plan_code']?.toString() ?? json['plan_code']?.toString(),
      hostedPageStatus: json['hostedpage_status']?.toString() ??
          json['status']?.toString() ??
          (isPro ? 'success' : 'pending'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_pro': isPro,
      'membership_status': membershipStatus,
      'membership_starts_at': membershipStartsAt?.toIso8601String(),
      'membership_ends_at': membershipEndsAt?.toIso8601String(),
      'zoho_subscription_id': zohoSubscriptionId,
      'zoho_plan_code': zohoPlanCode,
      'hostedpage_status': hostedPageStatus,
    };
  }
}
