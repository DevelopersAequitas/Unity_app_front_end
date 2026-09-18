import 'package:equatable/equatable.dart';

class P2pMeetingEntity extends Equatable {
  final String id;
  final String? postId;
  final String? initiatorUserId;
  final String? peerUserId;
  final String peerName;
  final String? peerDesignation;
  final String? peerCompany;
  final String? peerLocation;
  final String? peerCategory;
  final String? peerPhotoUrl;
  final bool isPeerPro;
  final String? meetingDate;
  final String? meetingPlace;
  final String? remarks;
  final List<String> mediaUrls;
  final int? coinsEarned;
  final int? impactEarned;
  final String? createdAt;
  final String? updatedAt;
  final bool isInitiatedByMe;

  const P2pMeetingEntity({
    required this.id,
    this.postId,
    this.initiatorUserId,
    this.peerUserId,
    required this.peerName,
    this.peerDesignation,
    this.peerCompany,
    this.peerLocation,
    this.peerCategory,
    this.peerPhotoUrl,
    this.isPeerPro = false,
    this.meetingDate,
    this.meetingPlace,
    this.remarks,
    this.mediaUrls = const [],
    this.coinsEarned,
    this.impactEarned,
    this.createdAt,
    this.updatedAt,
    this.isInitiatedByMe = false,
  });

  @override
  List<Object?> get props => [
        id,
        postId,
        initiatorUserId,
        peerUserId,
        peerName,
        peerDesignation,
        peerCompany,
        peerLocation,
        peerCategory,
        peerPhotoUrl,
        isPeerPro,
        meetingDate,
        meetingPlace,
        remarks,
        mediaUrls,
        coinsEarned,
        impactEarned,
        createdAt,
        updatedAt,
        isInitiatedByMe,
      ];
}
