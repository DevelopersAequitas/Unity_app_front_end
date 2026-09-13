import 'package:equatable/equatable.dart';
import 'circle_leader_entity.dart';
import 'circle_meeting_entity.dart';

class CircleEntity extends Equatable {
  final String id;
  final String name;
  final String? slug;
  final String? circleKey;
  final String? category;
  final String? city;
  final String? state;
  final String? country;
  final String? description;
  final String membershipStatus; // 'Active', 'Pending', etc.
  final int membersCount;
  final int peersCount;
  final String meetingFrequency;
  final String meetingMode;
  final CircleMeetingEntity? nextMeeting;
  final String? rank; // 'Gold', 'Silver', 'Bronze', 'New'
  final String? stage; // 'Pre-Launch Circle', 'Active'
  final String? logoUrl;
  final String? coverImageUrl;
  final List<String> memberAvatars;
  final List<CircleLeaderEntity> circleLeaders;
  final List<CircleLeaderEntity> regionalLeaders;
  final List<CircleLeaderEntity> leadership;
  final List<String> focusAreas;
  final String? type;

  const CircleEntity({
    required this.id,
    required this.name,
    this.slug,
    this.circleKey,
    this.category,
    this.city,
    this.state,
    this.country,
    this.description,
    this.membershipStatus = 'Active',
    this.membersCount = 0,
    this.peersCount = 0,
    this.meetingFrequency = 'Monthly',
    this.meetingMode = 'Offline',
    this.nextMeeting,
    this.rank,
    this.stage,
    this.logoUrl,
    this.coverImageUrl,
    this.memberAvatars = const [],
    this.circleLeaders = const [],
    this.regionalLeaders = const [],
    this.leadership = const [],
    this.focusAreas = const [],
    this.type,
  });

  List<CircleLeaderEntity> get allLeaders =>
      circleLeaders.isNotEmpty || regionalLeaders.isNotEmpty
          ? [...circleLeaders, ...regionalLeaders]
          : leadership;

  String get formattedLocation {
    final parts = [
      if (city != null && city!.trim().isNotEmpty) city!.trim(),
      if (state != null && state!.trim().isNotEmpty) state!.trim(),
    ];
    return parts.isNotEmpty ? parts.join(', ') : (country ?? '');
  }

  bool get isActiveMembership =>
      membershipStatus.toLowerCase() == 'active' ||
      membershipStatus.toLowerCase() == 'approved';

  bool get isPendingMembership =>
      membershipStatus.toLowerCase() == 'pending' ||
      membershipStatus.toLowerCase() == 'requested';

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        circleKey,
        category,
        city,
        state,
        country,
        description,
        membershipStatus,
        membersCount,
        peersCount,
        meetingFrequency,
        meetingMode,
        nextMeeting,
        rank,
        stage,
        logoUrl,
        coverImageUrl,
        memberAvatars,
        circleLeaders,
        regionalLeaders,
        leadership,
        focusAreas,
        type,
      ];
}
