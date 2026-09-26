import '../entities/ask_flow_entity.dart';
import '../entities/ask_form_config_entity.dart';
import '../entities/ask_history_item_entity.dart';
import '../entities/ask_item_entity.dart';
import '../entities/ask_match_peer_entity.dart';
import '../entities/ask_response_item_entity.dart';
import '../entities/ask_submission_entity.dart';
import '../entities/ask_type_entity.dart';

abstract class AsksRepository {
  Future<List<AskFlowEntity>> getAskFlows();
  Future<List<AskTypeEntity>> getAskTypes(String flowIdOrCode);
  Future<AskFormConfigEntity> getFormConfig({
    required String flowId,
    required String typeId,
  });
  Future<String?> createAskDraft(AskSubmissionEntity submission);
  Future<bool> saveAskFilters({
    required String askId,
    required AskSubmissionEntity submission,
  });
  Future<bool> publishAsk(
    String askId, {
    bool postToTimeline = true,
    AskSubmissionEntity? submission,
  });
  Future<bool> updateAskTimelinePreference(String askId, bool postToTimeline);
  Future<List<AskMatchPeerEntity>> getAskMatches(String askId);
  Future<bool> submitAskResponse({
    required String askId,
    required String responseType,
    required String message,
    required String timeline,
    Map<String, dynamic>? extraData,
  });
  Future<List<AskResponseItemEntity>> getAskResponses(String askId);
  Future<List<AskHistoryItemEntity>> getAskHistory(String askId);
  Future<List<AskItemEntity>> getMyAsks({
    String? flow,
    String? status,
    int page = 1,
    int perPage = 15,
  });
  Future<List<AskItemEntity>> getPeersFeed({
    String? scope,
    int page = 1,
    int perPage = 15,
  });
  Future<bool> congratulateAsk(String askId, {String? comment});
  Future<bool> toggleSaveAsk(String askId);
  Future<bool> updateAskStatus({
    required String askId,
    required String status,
    int? statusId,
    String? outcomeStatus,
    String? approxValue,
    String? note,
    bool? shareStory,
    bool? anonymousTotal,
  });
}
