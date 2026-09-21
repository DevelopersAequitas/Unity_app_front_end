import '../../../../core/cache/app_cache_keys.dart';
import '../../../../core/cache/cache_store.dart';
import '../models/chat_conversation_model.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheDirectConversations(List<Map<String, dynamic>> list);
  Future<List<ChatConversationModel>> getCachedDirectConversations({String? currentUserId});

  Future<void> cacheDirectMessages(String chatId, List<Map<String, dynamic>> list);
  Future<List<ChatMessageModel>> getCachedDirectMessages(String chatId, {String? currentUserId});

  Future<void> cacheCircleMessages(String circleId, List<Map<String, dynamic>> list);
  Future<List<ChatMessageModel>> getCachedCircleMessages(String circleId, {String? currentUserId});

  Future<void> cacheLeadershipMessages(String circleId, List<Map<String, dynamic>> list);
  Future<List<ChatMessageModel>> getCachedLeadershipMessages(String circleId, {String? currentUserId});

  Future<void> clearChatCache();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final CacheStore cacheStore;

  ChatLocalDataSourceImpl({required this.cacheStore});

  @override
  Future<void> cacheDirectConversations(List<Map<String, dynamic>> list) async {
    await cacheStore.set(
      AppCacheBoxes.chatBox,
      AppCacheKeys.directConversations,
      list,
    );
  }

  @override
  Future<List<ChatConversationModel>> getCachedDirectConversations({
    String? currentUserId,
  }) async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.chatBox,
      AppCacheKeys.directConversations,
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => ChatConversationModel.fromJson(e, currentUserId: currentUserId))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheDirectMessages(
    String chatId,
    List<Map<String, dynamic>> list,
  ) async {
    await cacheStore.set(
      AppCacheBoxes.chatBox,
      AppCacheKeys.directMessages(chatId),
      list,
    );
  }

  @override
  Future<List<ChatMessageModel>> getCachedDirectMessages(
    String chatId, {
    String? currentUserId,
  }) async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.chatBox,
      AppCacheKeys.directMessages(chatId),
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => ChatMessageModel.fromJson(e, currentUserId: currentUserId))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheCircleMessages(
    String circleId,
    List<Map<String, dynamic>> list,
  ) async {
    await cacheStore.set(
      AppCacheBoxes.chatBox,
      AppCacheKeys.circleMessages(circleId),
      list,
    );
  }

  @override
  Future<List<ChatMessageModel>> getCachedCircleMessages(
    String circleId, {
    String? currentUserId,
  }) async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.chatBox,
      AppCacheKeys.circleMessages(circleId),
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => ChatMessageModel.fromJson(e, currentUserId: currentUserId))
          .toList();
    }
    return [];
  }

  @override
  Future<void> cacheLeadershipMessages(
    String circleId,
    List<Map<String, dynamic>> list,
  ) async {
    await cacheStore.set(
      AppCacheBoxes.chatBox,
      AppCacheKeys.leadershipMessages(circleId),
      list,
    );
  }

  @override
  Future<List<ChatMessageModel>> getCachedLeadershipMessages(
    String circleId, {
    String? currentUserId,
  }) async {
    final cached = await cacheStore.get<List<dynamic>>(
      AppCacheBoxes.chatBox,
      AppCacheKeys.leadershipMessages(circleId),
    );
    if (cached != null) {
      return cached
          .whereType<Map<String, dynamic>>()
          .map((e) => ChatMessageModel.fromJson(e, currentUserId: currentUserId))
          .toList();
    }
    return [];
  }

  @override
  Future<void> clearChatCache() async {
    await cacheStore.clear(AppCacheBoxes.chatBox);
  }
}
