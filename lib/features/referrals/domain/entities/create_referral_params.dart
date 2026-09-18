import 'package:equatable/equatable.dart';

class CreateReferralParams extends Equatable {
  final String toUserId;
  final String referralType;
  final String referralDate;
  final String referralOf;
  final String? phone;
  final String? email;
  final String? address;
  final int hotValue;
  final String? remarks;

  const CreateReferralParams({
    required this.toUserId,
    this.referralType = 'b2b_referral',
    required this.referralDate,
    required this.referralOf,
    this.phone,
    this.email,
    this.address,
    this.hotValue = 3,
    this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      'to_user_id': toUserId,
      'referral_type': referralType,
      'referral_date': referralDate,
      'referral_of': referralOf,
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
      if (email != null && email!.trim().isNotEmpty) 'email': email!.trim(),
      if (address != null && address!.trim().isNotEmpty) 'address': address!.trim(),
      'hot_value': hotValue,
      if (remarks != null && remarks!.trim().isNotEmpty) 'remarks': remarks!.trim(),
    };
  }

  @override
  List<Object?> get props => [
        toUserId,
        referralType,
        referralDate,
        referralOf,
        phone,
        email,
        address,
        hotValue,
        remarks,
      ];
}
