import 'package:equatable/equatable.dart';

class CreateBusinessDealParams extends Equatable {
  final String toUserId;
  final String dealDate;
  final double dealAmount;
  final String businessType; // "new" or "repeat"
  final String? comment;
  final String? referralId;
  final List<String>? mediaFileIds;

  const CreateBusinessDealParams({
    required this.toUserId,
    required this.dealDate,
    required this.dealAmount,
    this.businessType = 'new',
    this.comment,
    this.referralId,
    this.mediaFileIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'to_user_id': toUserId,
      'deal_date': dealDate,
      'deal_amount': dealAmount,
      'business_type': businessType,
      if (comment != null && comment!.trim().isNotEmpty)
        'comment': comment!.trim(),
      if (referralId != null && referralId!.trim().isNotEmpty)
        'referral_id': referralId!.trim(),
      if (mediaFileIds != null && mediaFileIds!.isNotEmpty)
        'media_file_ids': mediaFileIds,
    };
  }

  @override
  List<Object?> get props => [
        toUserId,
        dealDate,
        dealAmount,
        businessType,
        comment,
        referralId,
        mediaFileIds,
      ];
}
