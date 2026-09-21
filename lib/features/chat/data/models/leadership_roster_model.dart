import '../../domain/entities/leadership_roster_entity.dart';
import 'chat_user_model.dart';

class LeadershipRosterModel extends LeadershipRosterEntity {
  const LeadershipRosterModel({
    required super.circleId,
    required super.circleName,
    super.circleSlug,
    super.totalMembers = 0,
    super.totalMessages = 0,
    super.unreadCount = 0,
    super.isLeadershipMember = false,
    super.canSendMessage = false,
    super.members = const [],
  });

  factory LeadershipRosterModel.fromJson(Map<String, dynamic> json) {
    String circleId = '';
    String circleName = '';
    String? circleSlug;

    if (json['circle'] is Map<String, dynamic>) {
      final circle = json['circle'] as Map<String, dynamic>;
      circleId = (circle['id'] ?? '').toString();
      circleName = (circle['name'] ?? '').toString();
      circleSlug = circle['slug']?.toString();
    } else {
      circleId = (json['circle_id'] ?? '').toString();
      circleName = (json['circle_name'] ?? '').toString();
    }

    int totalMembers = 0;
    int totalMessages = 0;
    int unreadCount = 0;

    if (json['chat'] is Map<String, dynamic>) {
      final chat = json['chat'] as Map<String, dynamic>;
      totalMembers = chat['total_members'] is int
          ? chat['total_members'] as int
          : (int.tryParse(chat['total_members']?.toString() ?? '0') ?? 0);
      totalMessages = chat['total_messages'] is int
          ? chat['total_messages'] as int
          : (int.tryParse(chat['total_messages']?.toString() ?? '0') ?? 0);
      unreadCount = chat['unread_count'] is int
          ? chat['unread_count'] as int
          : (int.tryParse(chat['unread_count']?.toString() ?? '0') ?? 0);
    }

    bool isLeadershipMember = false;
    bool canSendMessage = false;

    if (json['current_user'] is Map<String, dynamic>) {
      final currentUser = json['current_user'] as Map<String, dynamic>;
      isLeadershipMember = currentUser['is_leadership_member'] == true;
      canSendMessage = currentUser['can_send_message'] == true;
    }

    List<ChatUserModel> membersList = [];
    if (json['members'] is List) {
      for (final item in json['members']) {
        if (item is Map<String, dynamic>) {
          final leaderRole = item['leader_role']?.toString();
          final title = item['title']?.toString();
          if (item['user'] is Map<String, dynamic>) {
            final userMap = Map<String, dynamic>.from(item['user'] as Map);
            userMap['leader_role'] = leaderRole;
            userMap['title'] = title;
            membersList.add(ChatUserModel.fromJson(userMap));
          } else {
            membersList.add(ChatUserModel.fromJson(item));
          }
        }
      }
    }

    return LeadershipRosterModel(
      circleId: circleId,
      circleName: circleName.isEmpty ? 'Circle Leadership' : circleName,
      circleSlug: circleSlug,
      totalMembers: totalMembers > 0 ? totalMembers : membersList.length,
      totalMessages: totalMessages,
      unreadCount: unreadCount,
      isLeadershipMember: isLeadershipMember,
      canSendMessage: canSendMessage,
      members: membersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'circle': {
        'id': circleId,
        'name': circleName,
        'slug': circleSlug,
      },
      'chat': {
        'total_members': totalMembers,
        'total_messages': totalMessages,
        'unread_count': unreadCount,
      },
      'current_user': {
        'is_leadership_member': isLeadershipMember,
        'can_send_message': canSendMessage,
      },
      'members': members.map((m) => (m as ChatUserModel).toJson()).toList(),
    };
  }
}
