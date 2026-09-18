import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

class IntroducedPeerEntity extends Equatable {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String businessName;
  final String designation;
  final String city;
  final String category;
  final String avatarUrl;
  final String status;
  final String introducedDate;
  final bool isVerified;
  final bool isPro;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isConnected;
  final String connectionStatus;
  final int? lifeImpactedCount;

  const IntroducedPeerEntity({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.businessName = '',
    this.designation = '',
    this.city = '',
    this.category = '',
    this.avatarUrl = '',
    this.status = 'active',
    this.introducedDate = '',
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
        status,
        introducedDate,
        isVerified,
        isPro,
        isBookmarked,
        isFollowing,
        isConnected,
        connectionStatus,
        lifeImpactedCount,
      ];
}
