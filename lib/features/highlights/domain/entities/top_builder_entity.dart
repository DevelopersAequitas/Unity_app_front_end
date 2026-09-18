import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

class TopBuilderEntity extends Equatable {
  final String id;
  final String name;
  final String? firstName;
  final String? lastName;
  final String city;
  final String company;
  final int lifeImpactedCount;
  final int introducedCount;
  final String avatarUrl;
  final String membershipStatus;
  final String designation;
  final String category;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isVerified;
  final bool isPro;
  final bool isConnected;
  final String connectionStatus;
  final bool isRequested;
  final bool canSendConnectionRequest;
  final int matchPercentage;
  final int rank;
  final int introducedMembersCount;

  const TopBuilderEntity({
    required this.id,
    required this.name,
    this.firstName,
    this.lastName,
    this.city = '',
    this.company = '',
    this.lifeImpactedCount = 0,
    this.introducedCount = 0,
    this.avatarUrl = '',
    this.membershipStatus = '',
    this.designation = '',
    this.category = '',
    this.isBookmarked = false,
    this.isFollowing = false,
    this.isVerified = false,
    this.isPro = false,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.isRequested = false,
    this.canSendConnectionRequest = true,
    this.matchPercentage = 0,
    this.rank = 0,
    this.introducedMembersCount = 0,
  });

  PeerEntity toPeerEntity() {
    return PeerEntity(
      id: id,
      displayName: name,
      firstName: firstName,
      lastName: lastName,
      profilePhotoUrl: avatarUrl.isNotEmpty ? avatarUrl : null,
      companyName: company.isNotEmpty ? company : null,
      city: city.isNotEmpty ? city : null,
      designation: designation.isNotEmpty ? designation : null,
      category: category.isNotEmpty ? category : null,
      lifeImpactedCount: lifeImpactedCount > 0 ? lifeImpactedCount : null,
      isVerified: isVerified,
      isBookmarked: isBookmarked,
      isFollowing: isFollowing,
      isPro: isPro,
      connectionStatus: connectionStatus.isNotEmpty
          ? connectionStatus
          : (isConnected
              ? 'connected'
              : (isRequested ? 'pending' : 'none')),
    );
  }

  TopBuilderEntity copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? city,
    String? company,
    int? lifeImpactedCount,
    int? introducedCount,
    String? avatarUrl,
    String? membershipStatus,
    String? designation,
    String? category,
    bool? isBookmarked,
    bool? isFollowing,
    bool? isVerified,
    bool? isPro,
    bool? isConnected,
    String? connectionStatus,
    bool? isRequested,
    bool? canSendConnectionRequest,
    int? matchPercentage,
    int? rank,
    int? introducedMembersCount,
  }) {
    return TopBuilderEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      city: city ?? this.city,
      company: company ?? this.company,
      lifeImpactedCount: lifeImpactedCount ?? this.lifeImpactedCount,
      introducedCount: introducedCount ?? this.introducedCount,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      designation: designation ?? this.designation,
      category: category ?? this.category,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFollowing: isFollowing ?? this.isFollowing,
      isVerified: isVerified ?? this.isVerified,
      isPro: isPro ?? this.isPro,
      isConnected: isConnected ?? this.isConnected,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isRequested: isRequested ?? this.isRequested,
      canSendConnectionRequest:
          canSendConnectionRequest ?? this.canSendConnectionRequest,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      rank: rank ?? this.rank,
      introducedMembersCount:
          introducedMembersCount ?? this.introducedMembersCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        firstName,
        lastName,
        city,
        company,
        lifeImpactedCount,
        introducedCount,
        avatarUrl,
        membershipStatus,
        designation,
        category,
        isBookmarked,
        isFollowing,
        isVerified,
        isPro,
        isConnected,
        connectionStatus,
        isRequested,
        canSendConnectionRequest,
        matchPercentage,
        rank,
        introducedMembersCount,
      ];
}
