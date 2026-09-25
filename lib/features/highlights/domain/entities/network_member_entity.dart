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

  NetworkMemberEntity copyWith({
    String? id,
    String? name,
    String? firstName,
    String? lastName,
    String? businessName,
    String? designation,
    String? city,
    String? category,
    String? avatarUrl,
    String? joinedDate,
    String? status,
    String? referralType,
    String? referralTitle,
    int? coinsEarned,
    bool? isVerified,
    bool? isPro,
    bool? isBookmarked,
    bool? isFollowing,
    bool? isConnected,
    String? connectionStatus,
    int? lifeImpactedCount,
  }) {
    return NetworkMemberEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      designation: designation ?? this.designation,
      city: city ?? this.city,
      category: category ?? this.category,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      joinedDate: joinedDate ?? this.joinedDate,
      status: status ?? this.status,
      referralType: referralType ?? this.referralType,
      referralTitle: referralTitle ?? this.referralTitle,
      coinsEarned: coinsEarned ?? this.coinsEarned,
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
