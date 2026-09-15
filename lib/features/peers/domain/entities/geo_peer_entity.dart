import 'peer_entity.dart';

class GeoPeerEntity extends PeerEntity {
  final double latitude;
  final double longitude;
  final double distanceKm;

  const GeoPeerEntity({
    required super.id,
    required super.displayName,
    super.firstName,
    super.lastName,
    super.profilePhotoUrl,
    super.companyName,
    super.city,
    super.designation,
    super.category,
    super.lifeImpactedCount,
    super.isVerified = false,
    super.isBookmarked = false,
    super.isFollowing = false,
    super.isPro = false,
    super.isOnline = false,
    super.connectionStatus = 'none',
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  @override
  GeoPeerEntity copyWith({
    String? id,
    String? displayName,
    String? firstName,
    String? lastName,
    String? profilePhotoUrl,
    String? companyName,
    String? city,
    String? designation,
    String? category,
    int? lifeImpactedCount,
    bool? isVerified,
    bool? isBookmarked,
    bool? isFollowing,
    bool? isPro,
    bool? isOnline,
    String? connectionStatus,
    double? latitude,
    double? longitude,
    double? distanceKm,
  }) {
    return GeoPeerEntity(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      companyName: companyName ?? this.companyName,
      city: city ?? this.city,
      designation: designation ?? this.designation,
      category: category ?? this.category,
      lifeImpactedCount: lifeImpactedCount ?? this.lifeImpactedCount,
      isVerified: isVerified ?? this.isVerified,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFollowing: isFollowing ?? this.isFollowing,
      isPro: isPro ?? this.isPro,
      isOnline: isOnline ?? this.isOnline,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        latitude,
        longitude,
        distanceKm,
      ];
}
