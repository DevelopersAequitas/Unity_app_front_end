import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/chat_conversation_entity.dart';
import 'chat_message_model.dart';
import 'chat_user_model.dart';

class ChatConversationModel extends ChatConversationEntity {
  const ChatConversationModel({
    required super.id,
    super.user1Id,
    super.user2Id,
    super.lastMessageAt,
    super.otherUser,
    super.lastMessage,
    super.unreadCount = 0,
    super.createdAt,
    super.updatedAt,
  });

  factory ChatConversationModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    final user1Id = json['user1_id']?.toString();
    final user2Id = json['user2_id']?.toString();

    final lastMessageAt = AppDateFormatter.parseUtc(json['last_message_at']);

    ChatUserModel? otherUser;
    if (json['other_user'] is Map<String, dynamic>) {
      otherUser =
          ChatUserModel.fromJson(json['other_user'] as Map<String, dynamic>);
    } else if (json['user'] is Map<String, dynamic>) {
      otherUser = ChatUserModel.fromJson(json['user'] as Map<String, dynamic>);
    } else if (json['recipient'] is Map<String, dynamic>) {
      otherUser =
          ChatUserModel.fromJson(json['recipient'] as Map<String, dynamic>);
    }

    ChatMessageModel? lastMessage;
    if (json['last_message'] is Map<String, dynamic>) {
      lastMessage = ChatMessageModel.fromJson(
        json['last_message'] as Map<String, dynamic>,
        currentUserId: currentUserId,
      );
    }

    final unreadCount = json['unread_count'] is int
        ? json['unread_count'] as int
        : (int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0);

    final createdAt = AppDateFormatter.parseUtc(json['created_at']);
    final updatedAt = AppDateFormatter.parseUtc(json['updated_at']);

    return ChatConversationModel(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      lastMessageAt: lastMessageAt,
      otherUser: otherUser,
      lastMessage: lastMessage,
      unreadCount: unreadCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user1_id': user1Id,
      'user2_id': user2Id,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'other_user': (otherUser as ChatUserModel?)?.toJson(),
      'last_message': (lastMessage as ChatMessageModel?)?.toJson(),
      'unread_count': unreadCount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
