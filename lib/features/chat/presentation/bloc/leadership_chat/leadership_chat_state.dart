import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/entities/leadership_roster_entity.dart';

enum LeadershipChatStatus { initial, loading, success, error }

class LeadershipChatState extends Equatable {
  final LeadershipChatStatus status;
  final String circleId;
  final String? circleName;
  final LeadershipRosterEntity? roster;
  final List<ChatMessageEntity> messages;
  final ChatMessageEntity? quotedReply;
  final bool isSending;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final int currentPage;
  final String? errorMessage;

  const LeadershipChatState({
    this.status = LeadershipChatStatus.initial,
    this.circleId = '',
    this.circleName,
    this.roster,
    this.messages = const [],
    this.quotedReply,
    this.isSending = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  LeadershipChatState copyWith({
    LeadershipChatStatus? status,
    String? circleId,
    String? circleName,
    LeadershipRosterEntity? roster,
    List<ChatMessageEntity>? messages,
    ChatMessageEntity? quotedReply,
    bool clearQuotedReply = false,
    bool? isSending,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    int? currentPage,
    String? errorMessage,
  }) {
    return LeadershipChatState(
      status: status ?? this.status,
      circleId: circleId ?? this.circleId,
      circleName: circleName ?? this.circleName,
      roster: roster ?? this.roster,
      messages: messages ?? this.messages,
      quotedReply:
          clearQuotedReply ? null : (quotedReply ?? this.quotedReply),
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
        roster,
        messages,
        quotedReply,
        isSending,
        isLoadingMore,
        hasReachedEnd,
        currentPage,
        errorMessage,
      ];
}
