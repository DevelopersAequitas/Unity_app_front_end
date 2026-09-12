import 'package:equatable/equatable.dart';

class PeerEntity extends Equatable {
  final String id;
  final String displayName;
  final String? firstName;
  final String? lastName;
  final String? profilePhotoUrl;
  final String? companyName;
  final String? city;
  final String? designation;
  final String? category;
  final int? lifeImpactedCount;
  final bool isVerified;
  final bool isBookmarked;
  final bool isFollowing;
  final bool isOnline;
  final String connectionStatus; // 'none', 'pending', 'connected'

  const PeerEntity({
    required this.id,
    required this.displayName,
    this.firstName,
    this.lastName,
    this.profilePhotoUrl,
    this.companyName,
    this.city,
    this.designation,
    this.category,
    this.lifeImpactedCount,
    this.isVerified = false,
    this.isBookmarked = false,
    this.isFollowing = false,
    this.isOnline = false,
    this.connectionStatus = 'none',
  });

  PeerEntity copyWith({
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
    bool? isOnline,
    String? connectionStatus,
  }) {
    return PeerEntity(
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
      isOnline: isOnline ?? this.isOnline,
      connectionStatus: connectionStatus ?? this.connectionStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        firstName,
        lastName,
        profilePhotoUrl,
        companyName,
        city,
        designation,
        category,
        lifeImpactedCount,
        isVerified,
        isBookmarked,
        isFollowing,
        isOnline,
        connectionStatus,
      ];
}
