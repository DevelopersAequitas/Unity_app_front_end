import '../../domain/entities/referral_validation_entity.dart';

class ReferralValidationModel extends ReferralValidationEntity {
  const ReferralValidationModel({
    required super.valid,
    super.referralCode,
    super.referralLink,
    super.referrer,
    super.referrerName,
  });

  factory ReferralValidationModel.fromJson(Map<String, dynamic> json) {
    final root =
        (json.containsKey('data') && json['data'] is Map<String, dynamic>)
            ? json['data'] as Map<String, dynamic>
            : json;

    final isValid = root['valid'] == true;
    final code = root['referral_code']?.toString() ??
        root['code']?.toString() ??
        root['token']?.toString();
    final link = root['referral_link']?.toString() ??
        root['link']?.toString() ??
        root['invite_link']?.toString();
    final referrerNameFallback = root['referrer_name']?.toString() ??
        root['name']?.toString();

    ReferrerEntity? referrerEntity;
    if (root['referrer'] is Map<String, dynamic>) {
      final refMap = root['referrer'] as Map<String, dynamic>;
      ReferrerCircleEntity? circleEntity;
      if (refMap['circle'] is Map<String, dynamic>) {
        final cMap = refMap['circle'] as Map<String, dynamic>;
        circleEntity = ReferrerCircleEntity(
          id: (cMap['id'] ?? '').toString(),
          name: (cMap['name'] ?? '').toString(),
        );
      }

      referrerEntity = ReferrerEntity(
        id: (refMap['id'] ?? '').toString(),
        name: refMap['name']?.toString() ??
            refMap['display_name']?.toString(),
        email: refMap['email']?.toString(),
        companyName: refMap['company_name']?.toString(),
        city: refMap['city'] is Map
            ? refMap['city']['name']?.toString()
            : refMap['city']?.toString(),
        circle: circleEntity,
      );
    }

    return ReferralValidationModel(
      valid: isValid,
      referralCode: code,
      referralLink: link,
      referrer: referrerEntity,
      referrerName: referrerNameFallback ?? referrerEntity?.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'valid': valid,
      'referral_code': referralCode,
      'referral_link': referralLink,
      'referrer_name': referrerName,
      if (referrer != null)
        'referrer': {
          'id': referrer!.id,
          'name': referrer!.name,
          'email': referrer!.email,
          'company_name': referrer!.companyName,
          'city': referrer!.city,
          if (referrer!.circle != null)
            'circle': {
              'id': referrer!.circle!.id,
              'name': referrer!.circle!.name,
            },
        },
    };
  }
}
