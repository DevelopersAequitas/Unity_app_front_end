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
    super.isOnline = false,
    super.connectionStatus = 'none',
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        latitude,
        longitude,
        distanceKm,
      ];
}
