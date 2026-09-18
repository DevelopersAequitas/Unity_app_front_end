import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

class NetworkMemberEntity extends Equatable {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String businessName;
  final String designation;
  final String city;
  final String category;
  final String avatarUrl;
  final String joinedDate;
  final String status;
  final String referralType;
  final String referralTitle;
  final int coinsEarned;
  final bool isVerified;
  final bool isPro;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isConnected;
  final String connectionStatus;
  final int? lifeImpactedCount;

  const NetworkMemberEntity({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.businessName = '',
    this.designation = '',
    this.city = '',
    this.category = '',
    this.avatarUrl = '',
    this.joinedDate = '',
    this.status = 'active',
    this.referralType = '',
    this.referralTitle = '',
    this.coinsEarned = 0,
    this.isVerified = false,
    this.isPro = false,
    this.isBookmarked = false,
    this.isFollowing = false,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.lifeImpactedCount,
  });

  PeerEntity toPeerEntity() {
    return PeerEntity(
      id: id,
      displayName: name,
      firstName: firstName,
      lastName: lastName,
      profilePhotoUrl: avatarUrl.isNotEmpty ? avatarUrl : null,
      companyName: businessName.isNotEmpty ? businessName : null,
      city: city.isNotEmpty ? city : null,
      designation: designation.isNotEmpty ? designation : null,
      category: category.isNotEmpty ? category : null,
      lifeImpactedCount: lifeImpactedCount,
      isVerified: isVerified,
      isBookmarked: isBookmarked,
      isFollowing: isFollowing,
      isPro: isPro,
      connectionStatus: connectionStatus.isNotEmpty
          ? connectionStatus
          : (isConnected ? 'connected' : 'none'),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        firstName,
        lastName,
        businessName,
        designation,
        city,
        category,
        avatarUrl,
        joinedDate,
        status,
        referralType,
        referralTitle,
        coinsEarned,
        isVerified,
        isPro,
        isBookmarked,
        isFollowing,
        isConnected,
        connectionStatus,
        lifeImpactedCount,
      ];
}
