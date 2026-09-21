import 'package:equatable/equatable.dart';
import 'chat_user_entity.dart';

class LeadershipRosterEntity extends Equatable {
  final String circleId;
  final String circleName;
  final String? circleSlug;
  final int totalMembers;
  final int totalMessages;
  final int unreadCount;
  final bool isLeadershipMember;
  final bool canSendMessage;
  final List<ChatUserEntity> members;

  const LeadershipRosterEntity({
    required this.circleId,
    required this.circleName,
    this.circleSlug,
    this.totalMembers = 0,
    this.totalMessages = 0,
    this.unreadCount = 0,
    this.isLeadershipMember = false,
    this.canSendMessage = false,
    this.members = const [],
  });

  @override
  List<Object?> get props => [
        circleId,
        circleName,
        circleSlug,
        totalMembers,
        totalMessages,
        unreadCount,
        isLeadershipMember,
        canSendMessage,
        members,
      ];
}
