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

  IntroducedPeerEntity copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? businessName,
    String? designation,
    String? city,
    String? category,
    String? avatarUrl,
    String? status,
    String? introducedDate,
    bool? isVerified,
    bool? isPro,
    bool? isBookmarked,
    bool? isFollowing,
    bool? isConnected,
    String? connectionStatus,
    int? lifeImpactedCount,
  }) {
    return IntroducedPeerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      designation: designation ?? this.designation,
      city: city ?? this.city,
      category: category ?? this.category,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      introducedDate: introducedDate ?? this.introducedDate,
      isVerified: isVerified ?? this.isVerified,
      isPro: isPro ?? this.isPro,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFollowing: isFollowing ?? this.isFollowing,
      isConnected: isConnected ?? this.isConnected,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      lifeImpactedCount: lifeImpactedCount ?? this.lifeImpactedCount,
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
