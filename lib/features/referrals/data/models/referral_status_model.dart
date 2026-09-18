import '../../domain/entities/referral_status_entity.dart';

class ReferralStatusModel extends ReferralStatusEntity {
  const ReferralStatusModel({
    required super.id,
    required super.name,
  });

  factory ReferralStatusModel.fromJson(Map<String, dynamic> json) {
    return ReferralStatusModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()) ?? 0,
      name: (json['name'] ?? json['status_name'] ?? json['title'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
