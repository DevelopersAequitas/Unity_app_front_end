import 'dart:async';
import '../../domain/entities/chat_conversation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/leadership_roster_entity.dart';
import '../../domain/entities/message_reader_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource? localDataSource;

  ChatRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<List<ChatConversationEntity>> getDirectChats() async {
    try {
      final remote = await remoteDataSource.getDirectChats();
      if (localDataSource != null) {
        unawaited(localDataSource!.cacheDirectConversations(
          remote.map((e) => e.toJson()).toList(),
        ));
      }
      return remote;
    } catch (e) {
      if (localDataSource != null) {
        final cached = await localDataSource!.getCachedDirectConversations();
        if (cached.isNotEmpty) return cached;
      }
      rethrow;
    }
  }

  @override
  Future<ChatConversationEntity> getOrCreateDirectChat(String userId) {
    return remoteDataSource.getOrCreateDirectChat(userId);
  }

  @override
  Future<ChatConversationEntity> getDirectChatDetail(String chatId) {
    return remoteDataSource.getDirectChatDetail(chatId);
  }

  @override
  Future<List<ChatMessageEntity>> getDirectMessages(
    String chatId, {
    int page = 1,
    int perPage = 50,
  }) async {
    try {
      final remote = await remoteDataSource.getDirectMessages(
        chatId,
        page: page,
        perPage: perPage,
      );
      if (page == 1 && localDataSource != null) {
        unawaited(localDataSource!.cacheDirectMessages(
          chatId,
          remote.map((e) => e.toJson()).toList(),
        ));
      }
      return remote;
    } catch (e) {
      if (page == 1 && localDataSource != null) {
        final cached = await localDataSource!.getCachedDirectMessages(chatId);
        if (cached.isNotEmpty) return cached;
      }
      rethrow;
    }
  }

  @override
  Future<ChatMessageEntity> sendDirectMessage(
    String chatId, {
    required String content,
    String? filePath,
    String? fileType,
  }) {
    return remoteDataSource.sendDirectMessage(
      chatId,
      content: content,
      filePath: filePath,
      fileType: fileType,
    );
  }

  @override
  Future<bool> markDirectChatRead(String chatId) {
    return remoteDataSource.markDirectChatRead(chatId);
  }

  @override
  Future<bool> setTypingStatus(String chatId, {required bool isTyping}) {
    return remoteDataSource.setTypingStatus(chatId, isTyping: isTyping);
  }

  @override
  Future<bool> deleteDirectMessage(
    String messageId, {
    required bool forEveryone,
  }) {
    return remoteDataSource.deleteDirectMessage(
      messageId,
      forEveryone: forEveryone,
    );
  }

  @override
  Future<List<ChatMessageEntity>> getCircleMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
    String? beforeMessageId,
  }) async {
    try {
      final remote = await remoteDataSource.getCircleMessages(
        circleId,
        page: page,
        perPage: perPage,
        beforeMessageId: beforeMessageId,
      );
      if (page == 1 && localDataSource != null) {
        unawaited(localDataSource!.cacheCircleMessages(
          circleId,
          remote.map((e) => e.toJson()).toList(),
        ));
      }
      return remote;
    } catch (e) {
      if (page == 1 && localDataSource != null) {
        final cached = await localDataSource!.getCachedCircleMessages(circleId);
        if (cached.isNotEmpty) return cached;
      }
      rethrow;
    }
  }

  @override
  Future<ChatMessageEntity> sendCircleMessage(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  }) {
    return remoteDataSource.sendCircleMessage(
      circleId,
      messageText: messageText,
      messageType: messageType,
      replyToMessageId: replyToMessageId,
      filePath: filePath,
    );
  }

  @override
  Future<bool> markCircleMessagesRead(
    String circleId,
    List<String> messageIds,
  ) {
    return remoteDataSource.markCircleMessagesRead(circleId, messageIds);
  }

  @override
  Future<List<MessageReaderEntity>> getCircleMessageReads(
    String circleId,
    String messageId,
  ) {
    return remoteDataSource.getCircleMessageReads(circleId, messageId);
  }

  @override
  Future<bool> deleteCircleMessage(
    String circleId,
    String messageId, {
    required bool forEveryone,
  }) {
    return remoteDataSource.deleteCircleMessage(
      circleId,
      messageId,
      forEveryone: forEveryone,
    );
  }

  @override
  Future<LeadershipRosterEntity> getLeadershipRoster(String circleId) {
    return remoteDataSource.getLeadershipRoster(circleId);
  }

  @override
  Future<List<ChatMessageEntity>> getLeadershipMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final remote = await remoteDataSource.getLeadershipMessages(
        circleId,
        page: page,
        perPage: perPage,
      );
      if (page == 1 && localDataSource != null) {
        unawaited(localDataSource!.cacheLeadershipMessages(
          circleId,
          remote.map((e) => e.toJson()).toList(),
        ));
      }
      return remote;
    } catch (e) {
      if (page == 1 && localDataSource != null) {
        final cached =
            await localDataSource!.getCachedLeadershipMessages(circleId);
        if (cached.isNotEmpty) return cached;
      }
      rethrow;
    }
  }

  @override
  Future<ChatMessageEntity> sendLeadershipMessage(
    String circleId, {
    required String messageText,
    String messageType = 'text',
    String? replyToMessageId,
    String? filePath,
  }) {
    return remoteDataSource.sendLeadershipMessage(
      circleId,
      messageText: messageText,
      messageType: messageType,
      replyToMessageId: replyToMessageId,
      filePath: filePath,
    );
  }

  @override
  Future<bool> markLeadershipMessagesRead(
    String circleId,
    List<String> messageIds,
  ) {
    return remoteDataSource.markLeadershipMessagesRead(circleId, messageIds);
  }

  @override
  Future<bool> deleteLeadershipMessage(
    String circleId,
    String messageId, {
    required bool forEveryone,
  }) {
    return remoteDataSource.deleteLeadershipMessage(
      circleId,
      messageId,
      forEveryone: forEveryone,
    );
  }
}
