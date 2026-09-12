import '../../domain/entities/geo_peer_entity.dart';
import 'peer_model.dart';

class GeoPeerModel {
  final PeerModel peer;
  final double latitude;
  final double longitude;
  final double distanceKm;

  const GeoPeerModel({
    required this.peer,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
  });

  factory GeoPeerModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    final lat = (location?['latitude'] as num?)?.toDouble() ??
        (json['latitude'] as num?)?.toDouble() ??
        0.0;
    final lng = (location?['longitude'] as num?)?.toDouble() ??
        (json['longitude'] as num?)?.toDouble() ??
        0.0;
    final dist = (json['distance_km'] as num?)?.toDouble() ??
        (json['distance'] as num?)?.toDouble() ??
        0.0;

    return GeoPeerModel(
      peer: PeerModel.fromJson(json),
      latitude: lat,
      longitude: lng,
      distanceKm: dist,
    );
  }

  GeoPeerEntity toEntity() {
    final base = peer.toEntity();
    return GeoPeerEntity(
      id: base.id,
      displayName: base.displayName,
      firstName: base.firstName,
      lastName: base.lastName,
      profilePhotoUrl: base.profilePhotoUrl,
      companyName: base.companyName,
      city: base.city,
      designation: base.designation,
      category: base.category,
      lifeImpactedCount: base.lifeImpactedCount,
      isVerified: base.isVerified,
      isBookmarked: base.isBookmarked,
      isOnline: base.isOnline,
      connectionStatus: base.connectionStatus,
      latitude: latitude,
      longitude: longitude,
      distanceKm: distanceKm,
    );
  }
}
