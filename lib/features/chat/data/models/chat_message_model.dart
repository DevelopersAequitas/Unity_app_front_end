import '../../../../core/utils/app_date_formatter.dart';
import '../../domain/entities/chat_attachment_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/chat_user_entity.dart';
import 'chat_attachment_model.dart';
import 'chat_user_model.dart';

class ChatMessageModel extends ChatMessageEntity {
  const ChatMessageModel({
    required super.id,
    super.chatId,
    super.circleId,
    required super.senderId,
    required super.content,
    super.preview,
    super.messageType = 'text',
    super.attachments = const [],
    super.sender,
    super.replyToMessage,
    super.replyToMessageId,
    super.isMine = false,
    super.isRead = false,
    super.isReadByMe = false,
    super.readCount = 0,
    required super.createdAt,
    super.updatedAt,
  });

  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
    bool? isMineOverride,
  }) {
    final id = (json['id'] ?? json['_id'] ?? '').toString();
    final chatId = json['chat_id']?.toString();
    final circleId = json['circle_id']?.toString();

    // Sender resolution
    ChatUserModel? sender;
    String senderId = (json['sender_id'] ?? '').toString();

    if (json['sender'] is Map<String, dynamic>) {
      sender = ChatUserModel.fromJson(json['sender'] as Map<String, dynamic>);
      if (senderId.isEmpty) {
        senderId = sender.id;
      }
    } else if (json['user'] is Map<String, dynamic>) {
      sender = ChatUserModel.fromJson(json['user'] as Map<String, dynamic>);
      if (senderId.isEmpty) {
        senderId = sender.id;
      }
    }

    // Content resolution
    final content = (json['content'] ??
            json['message_text'] ??
            json['text'] ??
            json['message'] ??
            '')
        .toString();
    final preview = json['preview']?.toString() ?? content;
    final messageType =
        (json['message_type'] ?? json['type'] ?? 'text').toString();

    // Attachments resolution
    List<ChatAttachmentModel> attachments = [];
    if (json['attachments'] is List) {
      for (final item in (json['attachments'] as List)) {
        if (item is Map<String, dynamic>) {
          attachments.add(ChatAttachmentModel.fromJson(item));
        } else if (item is String && item.trim().isNotEmpty) {
          attachments.add(
            ChatAttachmentModel.fromJson({
              'id': item.trim(),
              'url': item.trim(),
              'file_type': messageType,
            }),
          );
        }
      }
    } else if (json['attachment'] != null) {
      if (json['attachment'] is Map<String, dynamic>) {
        attachments.add(
          ChatAttachmentModel.fromJson(
              json['attachment'] as Map<String, dynamic>),
        );
      } else if (json['attachment'] is String &&
          (json['attachment'] as String).trim().isNotEmpty) {
        attachments.add(
          ChatAttachmentModel.fromJson({
            'url': (json['attachment'] as String).trim(),
            'file_type': messageType,
          }),
        );
      }
    } else if (json['file'] != null || json['file_url'] != null || json['audio_url'] != null) {
      final rawUrl = (json['file_url'] ?? json['audio_url'] ?? json['file'])?.toString().trim();
      if (rawUrl != null && rawUrl.isNotEmpty) {
        attachments.add(
          ChatAttachmentModel.fromJson({
            'url': rawUrl,
            'file_type': json['audio_url'] != null ? 'audio' : messageType,
          }),
        );
      }
    }

    // Quoted Reply resolution
    ChatMessageModel? replyToMessage;
    if (json['reply_to_message'] is Map<String, dynamic>) {
      replyToMessage = ChatMessageModel.fromJson(
        json['reply_to_message'] as Map<String, dynamic>,
        currentUserId: currentUserId,
      );
    }
    final replyToMessageId = json['reply_to_message_id']?.toString() ??
        replyToMessage?.id;

    // Read flags
    final readCount = json['read_count'] is int
        ? json['read_count'] as int
        : (int.tryParse(json['read_count']?.toString() ?? '0') ?? 0);

    final statusStr = (json['status'] ?? json['delivery_status'] ?? '')
        .toString()
        .toLowerCase()
        .trim();

    final isRead = json['is_read'] == true ||
        (json['is_read'] is int && (json['is_read'] as int) > 0) ||
        (json['is_read'] is String &&
            (json['is_read'] == '1' || json['is_read'] == 'true')) ||
        json['read_at'] != null ||
        json['seen'] == true ||
        json['seen_at'] != null ||
        statusStr == 'read' ||
        statusStr == 'seen' ||
        readCount > 0;

    final isReadByMe = json['is_read_by_me'] == true ||
        (json['read_by_me'] == true) ||
        isRead;

    final isMine = isMineOverride ??
        (json['is_mine'] == true ||
            (currentUserId != null &&
                currentUserId.isNotEmpty &&
                senderId == currentUserId));

    // Timestamps
    final createdAt = AppDateFormatter.parseUtc(json['created_at']) ?? DateTime.now();
    final updatedAt = AppDateFormatter.parseUtc(json['updated_at']);

    return ChatMessageModel(
      id: id,
      chatId: chatId,
      circleId: circleId,
      senderId: senderId,
      content: content,
      preview: preview,
      messageType: messageType,
      attachments: attachments,
      sender: sender,
      replyToMessage: replyToMessage,
      replyToMessageId: replyToMessageId,
      isMine: isMine,
      isRead: isRead,
      isReadByMe: isReadByMe,
      readCount: readCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  ChatMessageModel copyWith({
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
    return ChatMessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      circleId: circleId ?? this.circleId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      preview: preview ?? this.preview,
      messageType: messageType ?? this.messageType,
      attachments: (attachments ?? this.attachments).map((e) {
        if (e is ChatAttachmentModel) return e;
        return ChatAttachmentModel(
          id: e.id,
          url: e.url,
          fileType: e.fileType,
          fileName: e.fileName,
          fileSize: e.fileSize,
          thumbnailUrl: e.thumbnailUrl,
        );
      }).toList(),
      sender: sender != null
          ? (sender is ChatUserModel
              ? sender
              : ChatUserModel(
                  id: sender.id,
                  displayName: sender.displayName,
                  firstName: sender.firstName,
                  lastName: sender.lastName,
                  profilePhotoUrl: sender.profilePhotoUrl,
                  companyName: sender.companyName,
                  leaderRole: sender.leaderRole,
                  title: sender.title,
                  isOnline: sender.isOnline,
                  isVerified: sender.isVerified,
                  isPro: sender.isPro,
                  category: sender.category,
                ))
          : this.sender,
      replyToMessage: replyToMessage,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      isMine: isMine ?? this.isMine,
      isRead: isRead ?? this.isRead,
      isReadByMe: isReadByMe ?? this.isReadByMe,
      readCount: readCount ?? this.readCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'circle_id': circleId,
      'sender_id': senderId,
      'content': content,
      'preview': preview,
      'message_type': messageType,
      'attachments':
          attachments.map((a) => (a as ChatAttachmentModel).toJson()).toList(),
      'sender': (sender as ChatUserModel?)?.toJson(),
      'reply_to_message': (replyToMessage as ChatMessageModel?)?.toJson(),
      'reply_to_message_id': replyToMessageId,
      'is_mine': isMine,
      'is_read': isRead,
      'is_read_by_me': isReadByMe,
      'read_count': readCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
