import 'package:equatable/equatable.dart';
import 'chat_attachment_entity.dart';
import 'chat_user_entity.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String? chatId;
  final String? circleId;
  final String senderId;
  final String content;
  final String? preview;
  final String messageType; // 'text', 'image', 'file', 'video'
  final List<ChatAttachmentEntity> attachments;
  final ChatUserEntity? sender;
  final ChatMessageEntity? replyToMessage;
  final String? replyToMessageId;
  final bool isMine;
  final bool isRead;
  final bool isReadByMe;
  final int readCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ChatMessageEntity({
    required this.id,
    this.chatId,
    this.circleId,
    required this.senderId,
    required this.content,
    this.preview,
    this.messageType = 'text',
    this.attachments = const [],
    this.sender,
    this.replyToMessage,
    this.replyToMessageId,
    this.isMine = false,
    this.isRead = false,
    this.isReadByMe = false,
    this.readCount = 0,
    required this.createdAt,
    this.updatedAt,
  });

  ChatMessageEntity copyWith({
    String? id,
    String? chatId,
    String? circleId,
    String? senderId,
    String? content,
    String? preview,
    String? messageType,
    List<ChatAttachmentEntity>? attachments,
    ChatUserEntity? sender,
    ChatMessageEntity? replyToMessage,
    String? replyToMessageId,
    bool? isMine,
    bool? isRead,
    bool? isReadByMe,
    int? readCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      circleId: circleId ?? this.circleId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      preview: preview ?? this.preview,
      messageType: messageType ?? this.messageType,
      attachments: attachments ?? this.attachments,
      sender: sender ?? this.sender,
      replyToMessage: replyToMessage ?? this.replyToMessage,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isMine: isMine ?? this.isMine,
      isRead: isRead ?? this.isRead,
      isReadByMe: isReadByMe ?? this.isReadByMe,
      readCount: readCount ?? this.readCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        chatId,
        circleId,
        senderId,
        content,
        preview,
        messageType,
        attachments,
        sender,
        replyToMessage,
        replyToMessageId,
        isMine,
        isRead,
        isReadByMe,
        readCount,
        createdAt,
        updatedAt,
      ];
}
