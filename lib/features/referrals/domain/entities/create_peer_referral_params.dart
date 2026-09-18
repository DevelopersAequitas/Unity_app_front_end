import 'package:equatable/equatable.dart';

class CreatePeerReferralParams extends Equatable {
  final String referredName;
  final String referredPhone;
  final String? referredEmail;
  final String? referredCompanyName;
  final String? referredDesignation;
  final String? mainCircleId;
  final String? circleId;
  final dynamic openCategoryId;
  final String? message;

  const CreatePeerReferralParams({
    required this.referredName,
    required this.referredPhone,
    this.referredEmail,
    this.referredCompanyName,
    this.referredDesignation,
    this.mainCircleId,
    this.circleId,
    this.openCategoryId,
    this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'referred_name': referredName.trim(),
      'referred_phone': referredPhone.trim(),
      if (referredEmail != null && referredEmail!.trim().isNotEmpty)
        'referred_email': referredEmail!.trim(),
      if (referredCompanyName != null && referredCompanyName!.trim().isNotEmpty)
        'referred_company_name': referredCompanyName!.trim(),
      if (referredDesignation != null && referredDesignation!.trim().isNotEmpty)
        'referred_designation': referredDesignation!.trim(),
      if (mainCircleId != null && mainCircleId!.trim().isNotEmpty)
        'main_circle_id': mainCircleId!.trim(),
      if (circleId != null && circleId!.trim().isNotEmpty)
        'circle_id': circleId!.trim(),
      if (openCategoryId != null)
        'open_category_id': openCategoryId,
      if (message != null && message!.trim().isNotEmpty)
        'message': message!.trim(),
    };
  }

  @override
  List<Object?> get props => [
        referredName,
        referredPhone,
        referredEmail,
        referredCompanyName,
        referredDesignation,
        mainCircleId,
        circleId,
        openCategoryId,
        message,
      ];
}
