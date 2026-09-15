import 'package:equatable/equatable.dart';
import 'package:unity_app/features/peers/domain/entities/peer_entity.dart';

class CircleClosedCategoryEntity extends Equatable {
  final String id;
  final String? categoryId;
  final String name;
  final String? level2Name;
  final String? level3Name;
  final String? occupantUserId;
  final String? occupantName;
  final String? occupantAvatarUrl;
  final String? occupantCompany;
  final String? occupantDesignation;
  final String? occupantCity;
  final int? occupantImpactCount;
  final bool occupantIsBookmarked;
  final bool occupantIsFollowing;
  final bool occupantIsPro;
  final bool occupantIsConnected;
  final bool occupantIsRequested;
  final String occupantConnectionStatus;

  const CircleClosedCategoryEntity({
    required this.id,
    this.categoryId,
    required this.name,
    this.level2Name,
    this.level3Name,
    this.occupantUserId,
    this.occupantName,
    this.occupantAvatarUrl,
    this.occupantCompany,
    this.occupantDesignation,
    this.occupantCity,
    this.occupantImpactCount,
    this.occupantIsBookmarked = false,
    this.occupantIsFollowing = false,
    this.occupantIsPro = false,
    this.occupantIsConnected = false,
    this.occupantIsRequested = false,
    this.occupantConnectionStatus = 'none',
  });

  PeerEntity toPeerEntity() {
    return PeerEntity(
      id: (occupantUserId != null && occupantUserId!.isNotEmpty) ? occupantUserId! : id,
      displayName: (occupantName != null && occupantName!.isNotEmpty) ? occupantName! : 'Peer Member',
      profilePhotoUrl: occupantAvatarUrl,
      companyName: occupantCompany,
      designation: occupantDesignation,
      city: occupantCity,
      category: name,
      lifeImpactedCount: occupantImpactCount,
      isBookmarked: occupantIsBookmarked,
      isFollowing: occupantIsFollowing,
      isPro: occupantIsPro,
      connectionStatus: occupantConnectionStatus,
    );
  }

  CircleClosedCategoryEntity copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? level2Name,
    String? level3Name,
    String? occupantUserId,
    String? occupantName,
    String? occupantAvatarUrl,
    String? occupantCompany,
    String? occupantDesignation,
    String? occupantCity,
    int? occupantImpactCount,
    bool? occupantIsBookmarked,
    bool? occupantIsFollowing,
    bool? occupantIsPro,
    bool? occupantIsConnected,
    bool? occupantIsRequested,
    String? occupantConnectionStatus,
  }) {
    return CircleClosedCategoryEntity(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      level2Name: level2Name ?? this.level2Name,
      level3Name: level3Name ?? this.level3Name,
      occupantUserId: occupantUserId ?? this.occupantUserId,
      occupantName: occupantName ?? this.occupantName,
      occupantAvatarUrl: occupantAvatarUrl ?? this.occupantAvatarUrl,
      occupantCompany: occupantCompany ?? this.occupantCompany,
      occupantDesignation: occupantDesignation ?? this.occupantDesignation,
      occupantCity: occupantCity ?? this.occupantCity,
      occupantImpactCount: occupantImpactCount ?? this.occupantImpactCount,
      occupantIsBookmarked: occupantIsBookmarked ?? this.occupantIsBookmarked,
      occupantIsFollowing: occupantIsFollowing ?? this.occupantIsFollowing,
      occupantIsPro: occupantIsPro ?? this.occupantIsPro,
      occupantIsConnected: occupantIsConnected ?? this.occupantIsConnected,
      occupantIsRequested: occupantIsRequested ?? this.occupantIsRequested,
      occupantConnectionStatus: occupantConnectionStatus ?? this.occupantConnectionStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        categoryId,
        name,
        level2Name,
        level3Name,
        occupantUserId,
        occupantName,
        occupantAvatarUrl,
        occupantCompany,
        occupantDesignation,
        occupantCity,
        occupantImpactCount,
        occupantIsBookmarked,
        occupantIsFollowing,
        occupantIsPro,
        occupantIsConnected,
        occupantIsRequested,
        occupantConnectionStatus,
      ];
}

