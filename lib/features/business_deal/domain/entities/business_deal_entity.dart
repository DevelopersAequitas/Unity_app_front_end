import 'package:equatable/equatable.dart';

class BusinessDealEntity extends Equatable {
  final String id;
  final String? fromUserId;
  final String? toUserId;
  final String dealDate;
  final double dealAmount;
  final String businessType; // 'new' or 'repeat'
  final String? comment;
  final String? referralId;
  final String peerName;
  final String? peerPhotoUrl;
  final String? peerDesignation;
  final String? peerCompany;
  final String? peerLocation;
  final String? city;
  final String? category;
  final int? lifeImpactedCount;
  final bool isPro;
  final String? createdAt;
  final String? updatedAt;
  final int? coinsEarned;
  final int? impactEarned;
  final String? postId;
  final List<String> mediaUrls;

  const BusinessDealEntity({
    required this.id,
    this.fromUserId,
    this.toUserId,
    required this.dealDate,
    required this.dealAmount,
    this.businessType = 'new',
    this.comment,
    this.referralId,
    required this.peerName,
    this.peerPhotoUrl,
    this.peerDesignation,
    this.peerCompany,
    this.peerLocation,
    this.city,
    this.category,
    this.lifeImpactedCount,
    this.isPro = false,
    this.createdAt,
    this.updatedAt,
    this.coinsEarned,
    this.impactEarned,
    this.postId,
    this.mediaUrls = const [],
  });

  bool get isNewBusiness => businessType.toLowerCase() == 'new';
  bool get isRepeatBusiness => businessType.toLowerCase() == 'repeat';

  String get businessTypeLabel => isNewBusiness ? 'New Business' : 'Repeat Business';

  String get subtitle {
    final des = peerDesignation?.trim() ?? '';
    final comp = peerCompany?.trim() ?? '';
    if (des.isNotEmpty && comp.isNotEmpty) {
      return '$des at $comp';
    } else if (des.isNotEmpty) {
      return des;
    } else if (comp.isNotEmpty) {
      return comp;
    }
    return '';
  }

  String get locationSubtitle {
    final loc = (city ?? peerLocation)?.trim() ?? '';
    if (loc.isNotEmpty) {
      return loc;
    }
    return '';
  }

  @override
  List<Object?> get props => [
        id,
        fromUserId,
        toUserId,
        dealDate,
        dealAmount,
        businessType,
        comment,
        referralId,
        peerName,
        peerPhotoUrl,
        peerDesignation,
        peerCompany,
        peerLocation,
        city,
        category,
        lifeImpactedCount,
        isPro,
        createdAt,
        updatedAt,
        coinsEarned,
        impactEarned,
        postId,
        mediaUrls,
      ];
}
