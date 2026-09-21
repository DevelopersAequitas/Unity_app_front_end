import 'package:equatable/equatable.dart';

abstract class DirectChatEvent extends Equatable {
  const DirectChatEvent();

  @override
  List<Object?> get props => [];
}

class InitDirectChatEvent extends DirectChatEvent {
  final String? chatId;
  final String? peerUserId;
  final String? peerName;
  final String? peerAvatar;

  const InitDirectChatEvent({
    this.chatId,
    this.peerUserId,
    this.peerName,
    this.peerAvatar,
  });

  @override
  List<Object?> get props => [chatId, peerUserId, peerName, peerAvatar];
}

class LoadDirectMessagesEvent extends DirectChatEvent {
  final bool isInitial;
  const LoadDirectMessagesEvent({this.isInitial = false});

  @override
  List<Object?> get props => [isInitial];
}

class SendDirectMessageEvent extends DirectChatEvent {
  final String content;
  final String? filePath;
  final String? fileType;

  const SendDirectMessageEvent({
    required this.content,
    this.filePath,
    this.fileType,
  });

  @override
  List<Object?> get props => [content, filePath, fileType];
}

class MarkDirectReadEvent extends DirectChatEvent {
  const MarkDirectReadEvent();
}

class SetTypingIndicatorEvent extends DirectChatEvent {
  final bool isTyping;
  const SetTypingIndicatorEvent({this.isTyping = true});

  @override
  List<Object?> get props => [isTyping];
}

class DeleteDirectMessageItemEvent extends DirectChatEvent {
  final String messageId;
  final bool forEveryone;

  const DeleteDirectMessageItemEvent({
    required this.messageId,
    required this.forEveryone,
  });

  @override
  List<Object?> get props => [messageId, forEveryone];
}

class SyncDirectMessagesEvent extends DirectChatEvent {
  const SyncDirectMessagesEvent();
}

class ResetDirectChatEvent extends DirectChatEvent {
  const ResetDirectChatEvent();
}

