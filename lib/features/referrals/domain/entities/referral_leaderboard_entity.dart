import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

class ReferralLeaderboardEntity extends Equatable {
  final int rank;
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? designation;
  final String? category;
  final String? city;
  final String? profilePhotoUrl;
  final bool isConnected;
  final String connectionStatus;
  final bool isRequested;
  final bool canSendConnectionRequest;
  final bool isFollowing;
  final bool isBookmark;
  final bool isPro;
  final bool isVerified;
  final num score;
  final int referralsCount;

  const ReferralLeaderboardEntity({
    required this.rank,
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.companyName,
    this.designation,
    this.category,
    this.city,
    this.profilePhotoUrl,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.isRequested = false,
    this.canSendConnectionRequest = false,
    this.isFollowing = false,
    this.isBookmark = false,
    this.isPro = false,
    this.isVerified = false,
    this.score = 0,
    this.referralsCount = 0,
  });

  PeerEntity toPeerEntity() {
    return PeerEntity(
      id: id,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      profilePhotoUrl: profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty
          ? profilePhotoUrl
          : null,
      companyName: companyName != null && companyName!.isNotEmpty
          ? companyName
          : null,
      city: city != null && city!.isNotEmpty ? city : null,
      designation:
          designation != null && designation!.isNotEmpty ? designation : null,
      category: category != null && category!.isNotEmpty ? category : null,
      isVerified: isVerified,
      isBookmarked: isBookmark,
      isFollowing: isFollowing,
      isPro: isPro,
      connectionStatus: connectionStatus.isNotEmpty
          ? connectionStatus
          : (isConnected
              ? 'connected'
              : (isRequested ? 'pending' : 'none')),
    );
  }

  @override
  List<Object?> get props => [
        rank,
        id,
        displayName,
        firstName,
        lastName,
        companyName,
        designation,
        category,
        city,
        profilePhotoUrl,
        isConnected,
        connectionStatus,
        isRequested,
        canSendConnectionRequest,
        isFollowing,
        isBookmark,
        isPro,
        isVerified,
        score,
        referralsCount,
      ];
}
