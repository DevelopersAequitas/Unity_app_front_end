import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message_entity.dart';

abstract class LeadershipChatEvent extends Equatable {
  const LeadershipChatEvent();

  @override
  List<Object?> get props => [];
}

class InitLeadershipChatEvent extends LeadershipChatEvent {
  final String circleId;
  final String? circleName;

  const InitLeadershipChatEvent({required this.circleId, this.circleName});

  @override
  List<Object?> get props => [circleId, circleName];
}

class LoadLeadershipMessagesEvent extends LeadershipChatEvent {
  final bool isInitial;
  const LoadLeadershipMessagesEvent({this.isInitial = false});

  @override
  List<Object?> get props => [isInitial];
}

class SendLeadershipMessageEvent extends LeadershipChatEvent {
  final String messageText;
  final String messageType;
  final String? replyToMessageId;
  final String? filePath;

  const SendLeadershipMessageEvent({
    required this.messageText,
    this.messageType = 'text',
    this.replyToMessageId,
    this.filePath,
  });

  @override
  List<Object?> get props => [messageText, messageType, replyToMessageId, filePath];
}

class SetLeadershipQuotedReplyEvent extends LeadershipChatEvent {
  final ChatMessageEntity? quotedMessage;
  const SetLeadershipQuotedReplyEvent(this.quotedMessage);

  @override
  List<Object?> get props => [quotedMessage];
}

class DeleteLeadershipMessageItemEvent extends LeadershipChatEvent {
  final String messageId;
  final bool forEveryone;

  const DeleteLeadershipMessageItemEvent({
    required this.messageId,
    required this.forEveryone,
  });

  @override
  List<Object?> get props => [messageId, forEveryone];
}

class SyncLeadershipMessagesEvent extends LeadershipChatEvent {
  const SyncLeadershipMessagesEvent();
}
