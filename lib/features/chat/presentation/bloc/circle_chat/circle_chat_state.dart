import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/entities/message_reader_entity.dart';

enum CircleChatStatus { initial, loading, success, error }

class CircleChatState extends Equatable {
  final CircleChatStatus status;
  final String circleId;
  final String? circleName;
  final List<ChatMessageEntity> messages;
  final ChatMessageEntity? quotedReply;
  final List<MessageReaderEntity> selectedMessageReaders;
  final String? selectedMessageId;
  final bool isLoadingReaders;
  final bool isSending;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final int currentPage;
  final String? errorMessage;

  const CircleChatState({
    this.status = CircleChatStatus.initial,
    this.circleId = '',
    this.circleName,
    this.messages = const [],
    this.quotedReply,
    this.selectedMessageReaders = const [],
    this.selectedMessageId,
    this.isLoadingReaders = false,
    this.isSending = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  CircleChatState copyWith({
    CircleChatStatus? status,
    String? circleId,
    String? circleName,
    List<ChatMessageEntity>? messages,
    ChatMessageEntity? quotedReply,
    bool clearQuotedReply = false,
    List<MessageReaderEntity>? selectedMessageReaders,
    String? selectedMessageId,
    bool? isLoadingReaders,
    bool? isSending,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    int? currentPage,
    String? errorMessage,
  }) {
    return CircleChatState(
      status: status ?? this.status,
      circleId: circleId ?? this.circleId,
      circleName: circleName ?? this.circleName,
      messages: messages ?? this.messages,
      quotedReply:
          clearQuotedReply ? null : (quotedReply ?? this.quotedReply),
      selectedMessageReaders:
          selectedMessageReaders ?? this.selectedMessageReaders,
      selectedMessageId: selectedMessageId ?? this.selectedMessageId,
      isLoadingReaders: isLoadingReaders ?? this.isLoadingReaders,
      isSending: isSending ?? this.isSending,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        circleId,
        circleName,
        messages,
        quotedReply,
        selectedMessageReaders,
        selectedMessageId,
        isLoadingReaders,
        isSending,
        isLoadingMore,
        hasReachedEnd,
        currentPage,
        errorMessage,
      ];
}
