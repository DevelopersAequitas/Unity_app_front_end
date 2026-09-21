import 'package:equatable/equatable.dart';
import '../../../domain/entities/chat_message_entity.dart';

abstract class CircleChatEvent extends Equatable {
  const CircleChatEvent();

  @override
  List<Object?> get props => [];
}

class InitCircleChatEvent extends CircleChatEvent {
  final String circleId;
  final String? circleName;

  const InitCircleChatEvent({required this.circleId, this.circleName});

  @override
  List<Object?> get props => [circleId, circleName];
}

class LoadCircleMessagesEvent extends CircleChatEvent {
  final bool isInitial;
  const LoadCircleMessagesEvent({this.isInitial = false});

  @override
  List<Object?> get props => [isInitial];
}

class SendCircleMessageEvent extends CircleChatEvent {
  final String messageText;
  final String messageType;
  final String? replyToMessageId;
  final String? filePath;

  const SendCircleMessageEvent({
    required this.messageText,
    this.messageType = 'text',
    this.replyToMessageId,
    this.filePath,
  });

  @override
  List<Object?> get props =>
      [messageText, messageType, replyToMessageId, filePath];
}

class SetQuotedReplyEvent extends CircleChatEvent {
  final ChatMessageEntity? quotedMessage;
  const SetQuotedReplyEvent(this.quotedMessage);

  @override
  List<Object?> get props => [quotedMessage];
}

class FetchMessageReadersEvent extends CircleChatEvent {
  final String messageId;
  const FetchMessageReadersEvent(this.messageId);

  @override
  List<Object?> get props => [messageId];
}

class DeleteCircleMessageItemEvent extends CircleChatEvent {
  final String messageId;
  final bool forEveryone;

  const DeleteCircleMessageItemEvent({
    required this.messageId,
    required this.forEveryone,
  });

  @override
  List<Object?> get props => [messageId, forEveryone];
}

class SyncCircleMessagesEvent extends CircleChatEvent {
  const SyncCircleMessagesEvent();
}
