import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_conversation_entity.dart';

enum ChatListStatus { initial, loading, success, error }

class ChatListState extends Equatable {
  final ChatListStatus status;
  final List<ChatConversationEntity> directChats;
  final List<ChatConversationEntity> filteredDirectChats;
  final String searchQuery;
  final int totalUnreadCount;
  final String? errorMessage;

  const ChatListState({
    this.status = ChatListStatus.initial,
    this.directChats = const [],
    this.filteredDirectChats = const [],
    this.searchQuery = '',
    this.totalUnreadCount = 0,
    this.errorMessage,
  });

  ChatListState copyWith({
    ChatListStatus? status,
    List<ChatConversationEntity>? directChats,
    List<ChatConversationEntity>? filteredDirectChats,
    String? searchQuery,
    int? totalUnreadCount,
    String? errorMessage,
  }) {
    return ChatListState(
      status: status ?? this.status,
      directChats: directChats ?? this.directChats,
      filteredDirectChats: filteredDirectChats ?? this.filteredDirectChats,
      searchQuery: searchQuery ?? this.searchQuery,
      totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        directChats,
        filteredDirectChats,
        searchQuery,
        totalUnreadCount,
        errorMessage,
      ];
}
