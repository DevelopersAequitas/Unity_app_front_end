import 'package:equatable/equatable.dart';

class IntroVideoEntity extends Equatable {
  final String id;
  final String userId;
  final String? firstName;
  final String? lastName;
  final String displayName;
  final String name;
  final String? email;
  final String? phone;
  final String? companyName;
  final String? designation;
  final String? cityName;
  final String? level4Category;
  final String? profilePhotoUrl;
  final String? introVideoId;
  final String introVideoUrl;
  final int lifeImpactedCount;
  final int likesCount;
  final bool isLiked;
  final bool isConnected;
  final String? connectionStatus;
  final bool isRequested;
  final bool canSendConnectionRequest;
  final bool isPro;
  final bool isVerified;
  final bool isFollowing;
  final bool isBookmarked;
  final String? createdAt;
  final String? updatedAt;

  const IntroVideoEntity({
    required this.id,
    required this.userId,
    this.firstName,
    this.lastName,
    required this.displayName,
    required this.name,
    this.email,
    this.phone,
    this.companyName,
    this.designation,
    this.cityName,
    this.level4Category,
    this.profilePhotoUrl,
    this.introVideoId,
    required this.introVideoUrl,
    this.lifeImpactedCount = 0,
    this.likesCount = 0,
    this.isLiked = false,
    this.isConnected = false,
    this.connectionStatus,
    this.isRequested = false,
    this.canSendConnectionRequest = false,
    this.isPro = false,
    this.isVerified = false,
    this.isFollowing = false,
    this.isBookmarked = false,
    this.createdAt,
    this.updatedAt,
  });

  IntroVideoEntity copyWith({
    bool? isFollowing,
    bool? isBookmarked,
    bool? isLiked,
    int? likesCount,
    bool? isConnected,
    bool? isRequested,
    String? connectionStatus,
  }) {
    return IntroVideoEntity(
      id: id,
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      name: name,
      email: email,
      phone: phone,
      companyName: companyName,
      designation: designation,
      cityName: cityName,
      level4Category: level4Category,
      profilePhotoUrl: profilePhotoUrl,
      introVideoId: introVideoId,
      introVideoUrl: introVideoUrl,
      lifeImpactedCount: lifeImpactedCount,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      isConnected: isConnected ?? this.isConnected,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isRequested: isRequested ?? this.isRequested,
      canSendConnectionRequest: canSendConnectionRequest,
      isPro: isPro,
      isVerified: isVerified,
      isFollowing: isFollowing ?? this.isFollowing,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        displayName,
        introVideoUrl,
        isLiked,
        likesCount,
        isFollowing,
        isBookmarked,
        isConnected,
        isRequested,
      ];
}
