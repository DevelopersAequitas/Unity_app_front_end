import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_conversation_entity.dart';
import '../../../domain/entities/chat_message_entity.dart';

enum DirectChatStatus { initial, loading, success, error }

class DirectChatState extends Equatable {
  final DirectChatStatus status;
  final String? chatId;
  final String? peerUserId;
  final String? peerName;
  final String? peerAvatar;
  final ChatConversationEntity? conversation;
  final List<ChatMessageEntity> messages;
  final bool isSending;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final int currentPage;
  final bool isPeerTyping;
  final String? errorMessage;

  const DirectChatState({
    this.status = DirectChatStatus.initial,
    this.chatId,
    this.peerUserId,
    this.peerName,
    this.peerAvatar,
    this.conversation,
    this.messages = const [],
    this.isSending = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.isPeerTyping = false,
    this.errorMessage,
  });

  DirectChatState copyWith({
    DirectChatStatus? status,
    String? chatId,
    String? peerUserId,
    String? peerName,
    String? peerAvatar,
    ChatConversationEntity? conversation,
    List<ChatMessageEntity>? messages,
    bool? isSending,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    int? currentPage,
    bool? isPeerTyping,
    String? errorMessage,
  }) {
    return DirectChatState(
      status: status ?? this.status,
      chatId: chatId ?? this.chatId,
      peerUserId: peerUserId ?? this.peerUserId,
      peerName: peerName ?? this.peerName,
      peerAvatar: peerAvatar ?? this.peerAvatar,
      conversation: conversation ?? this.conversation,
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      isPeerTyping: isPeerTyping ?? this.isPeerTyping,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        chatId,
        peerUserId,
        peerName,
        peerAvatar,
        conversation,
        messages,
        isSending,
        isLoadingMore,
        hasReachedEnd,
        currentPage,
        isPeerTyping,
        errorMessage,
      ];
}
