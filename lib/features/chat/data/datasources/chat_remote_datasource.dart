import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/chat_conversation_model.dart';
import '../models/chat_message_model.dart';
import '../models/leadership_roster_model.dart';
import '../models/message_reader_model.dart';

abstract class ChatRemoteDataSource {
  // Direct Chat
  Future<List<ChatConversationModel>> getDirectChats();
  Future<ChatConversationModel> getOrCreateDirectChat(String userId);
  Future<ChatConversationModel> getDirectChatDetail(String chatId);
  Future<List<ChatMessageModel>> getDirectMessages(
    String chatId, {
    int page = 1,
    int perPage = 50,
  });
  Future<ChatMessageModel> sendDirectMessage(
    String chatId, {
    required String content,
    String? filePath,
    String? fileType,
  });
  Future<bool> markDirectChatRead(String chatId);
  Future<bool> setTypingStatus(String chatId, {required bool isTyping});
  Future<bool> deleteDirectMessage(
    String messageId, {
    required bool forEveryone,
  });

  // Circle Chat
  Future<List<ChatMessageModel>> getCircleMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
    String? beforeMessageId,
  });
  Future<ChatMessageModel> sendCircleMessage(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  });
  Future<bool> markCircleMessagesRead(
    String circleId,
    List<String> messageIds,
  );
  Future<List<MessageReaderModel>> getCircleMessageReads(
    String circleId,
    String messageId,
  );
  Future<bool> deleteCircleMessage(
    String circleId,
    String messageId, {
    required bool forEveryone,
  });

  // Leadership Chat
  Future<LeadershipRosterModel> getLeadershipRoster(String circleId);
  Future<List<ChatMessageModel>> getLeadershipMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
  });
  Future<ChatMessageModel> sendLeadershipMessage(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  });
  Future<bool> markLeadershipMessagesRead(
    String circleId,
    List<String> messageIds,
  );
  Future<bool> deleteLeadershipMessage(
    String circleId,
    String messageId, {
    required bool forEveryone,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;
  final AuthLocalDataSource? authLocalDataSource;

  ChatRemoteDataSourceImpl({
    required this.dioClient,
    this.authLocalDataSource,
  });

  Future<String?> _getCurrentUserId() async {
    try {
      if (authLocalDataSource == null) return null;
      final authData = await authLocalDataSource!.getAuthData();
      return authData.user?.id;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<ChatConversationModel>> getDirectChats() async {
    final currentUserId = await _getCurrentUserId();
    final response = await dioClient.dio.get(ApiEndpoints.chats);
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['chats'] is List) {
        list = data['chats'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) =>
            ChatConversationModel.fromJson(e, currentUserId: currentUserId))
        .where((c) =>
            c.otherUser != null &&
            (c.lastMessage != null || c.unreadCount > 0))
        .toList();
  }

  @override
  Future<ChatConversationModel> getOrCreateDirectChat(String userId) async {
    final currentUserId = await _getCurrentUserId();
    final response = await dioClient.dio.post(
      ApiEndpoints.chats,
      data: {'user_id': userId},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return ChatConversationModel.fromJson(
          data['data'] as Map<String, dynamic>,
          currentUserId: currentUserId,
        );
      }
      return ChatConversationModel.fromJson(
        data,
        currentUserId: currentUserId,
      );
    }
    throw Exception('Failed to create/open direct chat');
  }

  @override
  Future<ChatConversationModel> getDirectChatDetail(String chatId) async {
    final currentUserId = await _getCurrentUserId();
    final response = await dioClient.dio.get(ApiEndpoints.chatDetail(chatId));
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return ChatConversationModel.fromJson(
          data['data'] as Map<String, dynamic>,
          currentUserId: currentUserId,
        );
      }
      return ChatConversationModel.fromJson(
        data,
        currentUserId: currentUserId,
      );
    }
    throw Exception('Failed to fetch chat details');
  }

  @override
  Future<List<ChatMessageModel>> getDirectMessages(
    String chatId, {
    int page = 1,
    int perPage = 50,
  }) async {
    final currentUserId = await _getCurrentUserId();
    final response = await dioClient.dio.get(
      ApiEndpoints.chatMessages(chatId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic> &&
          data['data']['items'] is List) {
        list = data['data']['items'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['items'] is List) {
        list = data['items'] as List;
      } else if (data['messages'] is List) {
        list = data['messages'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) =>
            ChatMessageModel.fromJson(e, currentUserId: currentUserId))
        .toList();
  }

  // Returns a record of (fileId, fileUrl) after uploading.
  Future<({String id, String url})?> _uploadFile(String? filePath) async {
    if (filePath == null || filePath.isEmpty) return null;
    try {
      final fileName = filePath.split(RegExp(r'[/\\]')).last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });
      final response = await dioClient.dio.post(
        ApiEndpoints.fileUpload,
        data: formData,
        options: Options(
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final d = response.data;
        if (d is Map<String, dynamic>) {
          final inner = d['data'] is Map<String, dynamic>
              ? d['data'] as Map<String, dynamic>
              : d;
          final fileId = (inner['id'] ?? inner['file_id'] ?? '').toString();
          final fileUrl = (inner['url'] ?? inner['file_url'] ?? '').toString();
          if (fileId.isNotEmpty) {
            return (id: fileId, url: fileUrl);
          }
        }
      }
    } catch (_) {}
    return null;
  }

  /// Builds the attachment object the backend expects:
  ///   attachments: [ { "id": "<fileId>", "type": "<type>" } ]
  Map<String, dynamic> _attachmentObj(String fileId, String type) =>
      {'id': fileId, 'type': type};

  @override
  Future<ChatMessageModel> sendDirectMessage(
    String chatId, {
    required String content,
    String? filePath,
    String? fileType,
  }) async {
    final currentUserId = await _getCurrentUserId();
    final resolvedType = fileType ?? 'file';
    final textContent = content.isNotEmpty
        ? content
        : (resolvedType == 'audio'
            ? 'Voice note'
            : (resolvedType == 'image' ? 'Photo' : 'Attachment'));

    dynamic payload;
    String? uploadedUrl;

    if (filePath != null && filePath.isNotEmpty) {
      final uploaded = await _uploadFile(filePath);
      if (uploaded != null) {
        uploadedUrl = uploaded.url.isNotEmpty ? uploaded.url : null;
        // Backend expects: attachments: [ { id, type } ]
        payload = {
          'content': textContent,
          'message_text': textContent,
          'message_type': resolvedType,
          'attachments': [_attachmentObj(uploaded.id, resolvedType)],
        };
      } else {
        // Fallback: multipart direct upload
        final fileName = filePath.split(RegExp(r'[/\\]')).last;
        payload = FormData.fromMap({
          'content': textContent,
          'message_text': textContent,
          'message_type': resolvedType,
          'file': await MultipartFile.fromFile(filePath, filename: fileName),
        });
      }
    } else {
      payload = {
        'content': textContent,
        'message_text': textContent,
        'message_type': 'text',
      };
    }

    final response = await dioClient.dio.post(
      ApiEndpoints.sendChatMessage(chatId),
      data: payload,
    );
    final data = response.data;
    Map<String, dynamic> msgJson = {};
    if (data is Map<String, dynamic>) {
      msgJson = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data;
    } else {
      throw Exception('Failed to send direct message');
    }

    // If server didn't return attachment preview but we have upload URL, inject it
    if (uploadedUrl != null &&
        filePath != null &&
        (msgJson['attachments'] == null ||
            (msgJson['attachments'] is List &&
                (msgJson['attachments'] as List).isEmpty))) {
      msgJson = Map<String, dynamic>.from(msgJson)
        ..['attachments'] = [
          {
            'url': uploadedUrl,
            'file_url': uploadedUrl,
            'type': resolvedType,
            'file_type': resolvedType,
          }
        ];
    } else if (filePath != null &&
        uploadedUrl == null &&
        (msgJson['attachments'] == null ||
            (msgJson['attachments'] is List &&
                (msgJson['attachments'] as List).isEmpty))) {
      // Use local path for immediate preview before server refreshes
      msgJson = Map<String, dynamic>.from(msgJson)
        ..['attachments'] = [
          {
            'url': filePath,
            'file_type': resolvedType,
          }
        ];
    }

    return ChatMessageModel.fromJson(
      msgJson,
      currentUserId: currentUserId,
      isMineOverride: true,
    );
  }

  @override
  Future<bool> markDirectChatRead(String chatId) async {
    final response =
        await dioClient.dio.post(ApiEndpoints.markChatRead(chatId));
    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<bool> setTypingStatus(String chatId, {required bool isTyping}) async {
    final endpoint = isTyping
        ? ApiEndpoints.chatTypingStart(chatId)
        : ApiEndpoints.chatTypingStop(chatId);
    final response = await dioClient.dio.post(endpoint);
    return response.statusCode == 200;
  }

  @override
  Future<bool> deleteDirectMessage(
    String messageId, {
    required bool forEveryone,
  }) async {
    final endpoint = forEveryone
        ? ApiEndpoints.deleteMessageForEveryone(messageId)
        : ApiEndpoints.deleteMessageForMe(messageId);
    final response = await dioClient.dio.post(endpoint);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<List<ChatMessageModel>> getCircleMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
    String? beforeMessageId,
  }) async {
    final currentUserId = await _getCurrentUserId();
    final query = <String, dynamic>{'page': page, 'per_page': perPage};
    if (beforeMessageId != null) query['before_message_id'] = beforeMessageId;

    final response = await dioClient.dio.get(
      ApiEndpoints.circleChatMessages(circleId),
      queryParameters: query,
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic> &&
          data['data']['messages'] is List) {
        list = data['data']['messages'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['messages'] is List) {
        list = data['messages'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) =>
            ChatMessageModel.fromJson(e, currentUserId: currentUserId))
        .toList();
  }

  @override
  Future<ChatMessageModel> sendCircleMessage(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  }) async {
    final currentUserId = await _getCurrentUserId();
    final resolvedText = messageText.isNotEmpty
        ? messageText
        : (messageType == 'audio'
            ? 'Voice note'
            : (messageType == 'image' ? 'Photo' : 'Attachment'));

    dynamic payload;
    String? uploadedUrl;

    if (filePath != null && filePath.isNotEmpty) {
      final uploaded = await _uploadFile(filePath);
      if (uploaded != null) {
        uploadedUrl = uploaded.url.isNotEmpty ? uploaded.url : null;
        final base = <String, dynamic>{
          'message_type': messageType,
          'message_text': resolvedText,
          'content': resolvedText,
          'attachments': [_attachmentObj(uploaded.id, messageType)],
        };
        if (replyToMessageId != null) base['reply_to_message_id'] = replyToMessageId;
        payload = base;
      } else {
        final fileName = filePath.split(RegExp(r'[/\\]')).last;
        final base = <String, dynamic>{
          'message_type': messageType,
          'message_text': resolvedText,
          'content': resolvedText,
        };
        if (replyToMessageId != null) base['reply_to_message_id'] = replyToMessageId;
        payload = FormData.fromMap({
          ...base,
          'file': await MultipartFile.fromFile(filePath, filename: fileName),
        });
      }
    } else {
      final base = <String, dynamic>{
        'message_type': messageType,
        'message_text': resolvedText,
        'content': resolvedText,
      };
      if (replyToMessageId != null) base['reply_to_message_id'] = replyToMessageId;
      payload = base;
    }

    final response = await dioClient.dio.post(
      ApiEndpoints.sendCircleChatMessage(circleId),
      data: payload,
    );
    final data = response.data;
    Map<String, dynamic> msgJson = {};
    if (data is Map<String, dynamic>) {
      msgJson = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data;
    } else {
      throw Exception('Failed to send circle message');
    }

    if (uploadedUrl != null &&
        filePath != null &&
        (msgJson['attachments'] == null ||
            (msgJson['attachments'] is List &&
                (msgJson['attachments'] as List).isEmpty))) {
      msgJson = Map<String, dynamic>.from(msgJson)
        ..['attachments'] = [
          {'url': uploadedUrl, 'file_type': messageType}
        ];
    } else if (filePath != null &&
        uploadedUrl == null &&
        (msgJson['attachments'] == null ||
            (msgJson['attachments'] is List &&
                (msgJson['attachments'] as List).isEmpty))) {
      msgJson = Map<String, dynamic>.from(msgJson)
        ..['attachments'] = [
          {'url': filePath, 'file_type': messageType}
        ];
    }

    return ChatMessageModel.fromJson(
      msgJson,
      currentUserId: currentUserId,
      isMineOverride: true,
    );
  }

  @override
  Future<bool> markCircleMessagesRead(
    String circleId,
    List<String> messageIds,
  ) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.markCircleChatRead(circleId),
      data: {'message_ids': messageIds},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<List<MessageReaderModel>> getCircleMessageReads(
    String circleId,
    String messageId,
  ) async {
    final response = await dioClient.dio
        .get(ApiEndpoints.circleMessageReads(circleId, messageId));
    final data = response.data;
    List<dynamic> list = [];
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic> &&
          data['data']['readers'] is List) {
        list = data['data']['readers'] as List;
      } else if (data['readers'] is List) {
        list = data['readers'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) => MessageReaderModel.fromJson(e))
        .toList();
  }

  @override
  Future<bool> deleteCircleMessage(
    String circleId,
    String messageId, {
    required bool forEveryone,
  }) async {
    if (forEveryone) {
      final response = await dioClient.dio.delete(
        ApiEndpoints.deleteCircleMessageForAll(circleId, messageId),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } else {
      final response = await dioClient.dio.post(
        ApiEndpoints.deleteCircleMessageForMe(circleId, messageId),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    }
  }

  @override
  Future<LeadershipRosterModel> getLeadershipRoster(String circleId) async {
    final response = await dioClient.dio
        .get(ApiEndpoints.circleLeadershipMembers(circleId));
    final data = response.data;
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return LeadershipRosterModel.fromJson(
            data['data'] as Map<String, dynamic>);
      }
      return LeadershipRosterModel.fromJson(data);
    }
    throw Exception('Failed to fetch leadership roster');
  }

  @override
  Future<List<ChatMessageModel>> getLeadershipMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
  }) async {
    final currentUserId = await _getCurrentUserId();
    final response = await dioClient.dio.get(
      ApiEndpoints.circleLeadershipMessages(circleId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final data = response.data;
    List<dynamic> list = [];
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic> &&
          data['data']['items'] is List) {
        list = data['data']['items'] as List;
      } else if (data['data'] is List) {
        list = data['data'] as List;
      } else if (data['items'] is List) {
        list = data['items'] as List;
      }
    }
    return list
        .whereType<Map<String, dynamic>>()
        .map((e) =>
            ChatMessageModel.fromJson(e, currentUserId: currentUserId))
        .toList();
  }

  @override
  Future<ChatMessageModel> sendLeadershipMessage(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  }) async {
    final currentUserId = await _getCurrentUserId();
    final resolvedText = messageText.isNotEmpty
        ? messageText
        : (messageType == 'audio'
            ? 'Voice note'
            : (messageType == 'image' ? 'Photo' : 'Attachment'));

    dynamic payload;
    String? uploadedUrl;

    if (filePath != null && filePath.isNotEmpty) {
      final uploaded = await _uploadFile(filePath);
      if (uploaded != null) {
        uploadedUrl = uploaded.url.isNotEmpty ? uploaded.url : null;
        final base = <String, dynamic>{
          'message_type': messageType,
          'message_text': resolvedText,
          'content': resolvedText,
          'attachments': [_attachmentObj(uploaded.id, messageType)],
        };
        if (replyToMessageId != null) base['reply_to_message_id'] = replyToMessageId;
        payload = base;
      } else {
        final fileName = filePath.split(RegExp(r'[/\\]')).last;
        final base = <String, dynamic>{
          'message_type': messageType,
          'message_text': resolvedText,
          'content': resolvedText,
        };
        if (replyToMessageId != null) base['reply_to_message_id'] = replyToMessageId;
        payload = FormData.fromMap({
          ...base,
          'file': await MultipartFile.fromFile(filePath, filename: fileName),
        });
      }
    } else {
      final base = <String, dynamic>{
        'message_type': messageType,
        'message_text': resolvedText,
        'content': resolvedText,
      };
      if (replyToMessageId != null) base['reply_to_message_id'] = replyToMessageId;
      payload = base;
    }

    final response = await dioClient.dio.post(
      ApiEndpoints.sendCircleLeadershipMessage(circleId),
      data: payload,
    );
    final data = response.data;
    Map<String, dynamic> msgJson = {};
    if (data is Map<String, dynamic>) {
      msgJson = (data['data'] is Map<String, dynamic>)
          ? data['data'] as Map<String, dynamic>
          : data;
    } else {
      throw Exception('Failed to send leadership message');
    }

    if (uploadedUrl != null &&
        filePath != null &&
        (msgJson['attachments'] == null ||
            (msgJson['attachments'] is List &&
                (msgJson['attachments'] as List).isEmpty))) {
      msgJson = Map<String, dynamic>.from(msgJson)
        ..['attachments'] = [
          {'url': uploadedUrl, 'file_type': messageType}
        ];
    } else if (filePath != null &&
        uploadedUrl == null &&
        (msgJson['attachments'] == null ||
            (msgJson['attachments'] is List &&
                (msgJson['attachments'] as List).isEmpty))) {
      msgJson = Map<String, dynamic>.from(msgJson)
        ..['attachments'] = [
          {'url': filePath, 'file_type': messageType}
        ];
    }

    return ChatMessageModel.fromJson(
      msgJson,
      currentUserId: currentUserId,
      isMineOverride: true,
    );
  }

  @override
  Future<bool> markLeadershipMessagesRead(
    String circleId,
    List<String> messageIds,
  ) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.markCircleLeadershipRead(circleId),
      data: {'message_ids': messageIds},
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  @override
  Future<bool> deleteLeadershipMessage(
    String circleId,
    String messageId, {
    required bool forEveryone,
  }) async {
    final endpoint = forEveryone
        ? ApiEndpoints.deleteCircleLeadershipMessageForEveryone(
            circleId, messageId)
        : ApiEndpoints.deleteCircleLeadershipMessageForMe(circleId, messageId);
    final response = await dioClient.dio.post(endpoint);
    return response.statusCode == 200 || response.statusCode == 204;
  }
}
