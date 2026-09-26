import '../../domain/entities/circle_package_entity.dart';

class CirclePackageModel extends CirclePackageEntity {
  const CirclePackageModel({
    required super.circleId,
    required super.circleName,
    super.addonCode,
    super.addonName,
    required super.amount,
    super.currency = 'INR',
    super.durationMonths = 12,
    super.joinable = true,
  });

  factory CirclePackageModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val, [int fallback = 12]) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? fallback;
      return fallback;
    }

    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    return CirclePackageModel(
      circleId: data['circle_id']?.toString() ?? '',
      circleName: data['circle_name']?.toString() ?? 'Circle Package',
      addonCode: data['addon_code']?.toString(),
      addonName: data['addon_name']?.toString(),
      amount: parseDouble(data['amount'] ?? data['fee'] ?? data['price']),
      currency: data['currency']?.toString() ?? 'INR',
      durationMonths: parseInt(data['duration_months'] ?? data['duration'], 12),
      joinable: data['joinable'] == true || data['joinable'] == 1 || data['joinable'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle_id': circleId,
      'circle_name': circleName,
      'addon_code': addonCode,
      'addon_name': addonName,
      'amount': amount,
      'currency': currency,
      'duration_months': durationMonths,
      'joinable': joinable,
    };
  }
}
