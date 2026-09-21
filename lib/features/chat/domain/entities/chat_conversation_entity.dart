import 'package:equatable/equatable.dart';
import 'chat_message_entity.dart';
import 'chat_user_entity.dart';

class ChatConversationEntity extends Equatable {
  final String id;
  final String? user1Id;
  final String? user2Id;
  final DateTime? lastMessageAt;
  final ChatUserEntity? otherUser;
  final ChatMessageEntity? lastMessage;
  final int unreadCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatConversationEntity({
    required this.id,
    this.user1Id,
    this.user2Id,
    this.lastMessageAt,
    this.otherUser,
    this.lastMessage,
    this.unreadCount = 0,
    this.createdAt,
    this.updatedAt,
  });

  ChatConversationEntity copyWith({
    String? id,
    String? user1Id,
    String? user2Id,
    DateTime? lastMessageAt,
    ChatUserEntity? otherUser,
    ChatMessageEntity? lastMessage,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatConversationEntity(
      id: id ?? this.id,
      user1Id: user1Id ?? this.user1Id,
      user2Id: user2Id ?? this.user2Id,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      otherUser: otherUser ?? this.otherUser,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        lastMessageAt,
        otherUser,
        lastMessage,
        unreadCount,
        createdAt,
        updatedAt,
      ];
}
