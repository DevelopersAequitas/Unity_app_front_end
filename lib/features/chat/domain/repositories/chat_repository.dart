import '../entities/chat_conversation_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/leadership_roster_entity.dart';
import '../entities/message_reader_entity.dart';

abstract class ChatRepository {
  // Direct Chat
  Future<List<ChatConversationEntity>> getDirectChats();
  Future<ChatConversationEntity> getOrCreateDirectChat(String userId);
  Future<ChatConversationEntity> getDirectChatDetail(String chatId);
  Future<List<ChatMessageEntity>> getDirectMessages(
    String chatId, {
    int page = 1,
    int perPage = 50,
  });
  Future<ChatMessageEntity> sendDirectMessage(
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

  // Circle Group Chat
  Future<List<ChatMessageEntity>> getCircleMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
    String? beforeMessageId,
  });
  Future<ChatMessageEntity> sendCircleMessage(
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
  Future<List<MessageReaderEntity>> getCircleMessageReads(
    String circleId,
    String messageId,
  );
  Future<bool> deleteCircleMessage(
    String circleId,
    String messageId, {
    required bool forEveryone,
  });

  // Circle Leadership Chat
  Future<LeadershipRosterEntity> getLeadershipRoster(String circleId);
  Future<List<ChatMessageEntity>> getLeadershipMessages(
    String circleId, {
    int page = 1,
    int perPage = 20,
  });
  Future<ChatMessageEntity> sendLeadershipMessage(
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
