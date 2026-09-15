import 'package:equatable/equatable.dart';
import '../../../peers/domain/entities/peer_entity.dart';

class CircleMemberEntity extends Equatable {
  final String id;
  final String? userId;
  final String name;
  final String? displayName;
  final String? role;
  final String? designation;
  final String? companyName;
  final String? avatarUrl;
  final bool isLeader;
  final String? city;
  final String? businessCategory;
  final String? businessSubCategory;
  final String? level4Category;
  final String? membershipStatus;
  final int? lifeImpactedCount;
  final bool isPro;
  final bool isFollowing;
  final bool isConnected;
  final String connectionStatus;
  final bool isRequested;
  final bool isBookmark;

  const CircleMemberEntity({
    required this.id,
    this.userId,
    required this.name,
    this.displayName,
    this.role,
    this.designation,
    this.companyName,
    this.avatarUrl,
    this.isLeader = false,
    this.city,
    this.businessCategory,
    this.businessSubCategory,
    this.level4Category,
    this.membershipStatus,
    this.lifeImpactedCount,
    this.isPro = false,
    this.isFollowing = false,
    this.isConnected = false,
    this.connectionStatus = 'none',
    this.isRequested = false,
    this.isBookmark = false,
  });

  String get effectiveName {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!.trim();
    }
    return name.isNotEmpty ? name : 'Peer';
  }

  String get effectiveRoleLabel {
    if (role == null || role!.isEmpty) return 'Member';
    final r = role!.toLowerCase().replaceAll('_', ' ');
    if (r == 'circle director') return 'Circle Director';
    if (r == 'industry director') return 'Industry Director';
    if (r == 'circle founder') return 'Circle Founder';
    return r.split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
  }

  String? get effectiveCategoryTag {
    if (level4Category != null && level4Category!.trim().isNotEmpty) {
      return level4Category!.trim();
    }
    if (businessSubCategory != null && businessSubCategory!.trim().isNotEmpty) {
      return businessSubCategory!.trim();
    }
    if (businessCategory != null && businessCategory!.trim().isNotEmpty) {
      return businessCategory!.trim();
    }
    return null;
  }

  PeerEntity toPeerEntity() {
    return PeerEntity(
      id: userId ?? id,
      displayName: effectiveName,
      profilePhotoUrl: avatarUrl,
      companyName: companyName,
      city: city,
      designation: designation,
      category: effectiveCategoryTag,
      lifeImpactedCount: lifeImpactedCount,
      isVerified: isLeader,
      isPro: isPro,
      isFollowing: isFollowing,
      connectionStatus: connectionStatus,
      isBookmarked: isBookmark,
    );
  }

  CircleMemberEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? displayName,
    String? role,
    String? designation,
    String? companyName,
    String? avatarUrl,
    bool? isLeader,
    String? city,
    String? businessCategory,
    String? businessSubCategory,
    String? level4Category,
    String? membershipStatus,
    int? lifeImpactedCount,
    bool? isPro,
    bool? isFollowing,
    bool? isConnected,
    String? connectionStatus,
    bool? isRequested,
    bool? isBookmark,
  }) {
    return CircleMemberEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      designation: designation ?? this.designation,
      companyName: companyName ?? this.companyName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isLeader: isLeader ?? this.isLeader,
      city: city ?? this.city,
      businessCategory: businessCategory ?? this.businessCategory,
      businessSubCategory: businessSubCategory ?? this.businessSubCategory,
      level4Category: level4Category ?? this.level4Category,
      membershipStatus: membershipStatus ?? this.membershipStatus,
      lifeImpactedCount: lifeImpactedCount ?? this.lifeImpactedCount,
      isPro: isPro ?? this.isPro,
      isFollowing: isFollowing ?? this.isFollowing,
      isConnected: isConnected ?? this.isConnected,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      isRequested: isRequested ?? this.isRequested,
      isBookmark: isBookmark ?? this.isBookmark,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        displayName,
        role,
        designation,
        companyName,
        avatarUrl,
        isLeader,
        city,
        businessCategory,
        businessSubCategory,
        level4Category,
        membershipStatus,
        lifeImpactedCount,
        isPro,
        isFollowing,
        isConnected,
        connectionStatus,
        isRequested,
        isBookmark,
      ];
}

