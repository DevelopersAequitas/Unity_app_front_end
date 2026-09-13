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
      connectionStatus: 'none',
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
      ];
}
