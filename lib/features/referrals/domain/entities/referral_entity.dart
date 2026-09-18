import 'package:equatable/equatable.dart';

class ReferralEntity extends Equatable {
  final String id;
  final String? fromUserId;
  final String? toUserId;
  final String referralType;
  final String referralDate;
  final String referralOf;
  final String? phone;
  final String? email;
  final String? address;
  final int hotValue; // 1 to 5
  final String? remarks;
  final int? statusId;
  final String statusName;
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

  const ReferralEntity({
    required this.id,
    this.fromUserId,
    this.toUserId,
    this.referralType = 'b2b_referral',
    required this.referralDate,
    required this.referralOf,
    this.phone,
    this.email,
    this.address,
    this.hotValue = 3,
    this.remarks,
    this.statusId,
    this.statusName = 'Pending',
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
  });

  String get referralTypeLabel {
    switch (referralType.toLowerCase()) {
      case 'b2b_referral':
        return 'B2B Referral';
      case 'customer_referral':
        return 'Customer Referral';
      case 'b2g_referral':
        return 'B2G Referral';
      case 'collaborative_projects':
        return 'Collaborative Project';
      case 'referral_partnerships':
        return 'Referral Partnership';
      case 'vendor_referrals':
        return 'Vendor Referral';
      case 'others':
        return 'Other Referral';
      default:
        return referralType.replaceAll('_', ' ').split(' ').map((w) {
          if (w.isEmpty) return '';
          return '${w[0].toUpperCase()}${w.substring(1)}';
        }).join(' ');
    }
  }

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
        referralType,
        referralDate,
        referralOf,
        phone,
        email,
        address,
        hotValue,
        remarks,
        statusId,
        statusName,
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
      ];
}
