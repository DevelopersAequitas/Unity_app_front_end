import 'package:unity_app/features/asks/domain/entities/ask_response_item_entity.dart';

import '../../domain/entities/ask_flow_entity.dart';
import '../../domain/entities/ask_form_config_entity.dart';
import '../../domain/entities/ask_history_item_entity.dart';
import '../../domain/entities/ask_item_entity.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../domain/entities/ask_submission_entity.dart';
import '../../domain/entities/ask_type_entity.dart';
import '../../domain/repositories/asks_repository.dart';
import '../datasources/asks_remote_datasource.dart';

class AsksRepositoryImpl implements AsksRepository {
  final AsksRemoteDataSource remoteDataSource;

  AsksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<AskFlowEntity>> getAskFlows() async {
    final models = await remoteDataSource.getAskFlows();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AskTypeEntity>> getAskTypes(String flowIdOrCode) async {
    final models = await remoteDataSource.getAskTypes(flowIdOrCode);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AskFormConfigEntity> getFormConfig({
    required String flowId,
    required String typeId,
  }) async {
    final model = await remoteDataSource.getFormConfig(
      flowId: flowId,
      typeId: typeId,
    );
    return model.toEntity();
  }

  @override
  Future<String?> createAskDraft(AskSubmissionEntity submission) {
    final flowKey = submission.flow.code.isNotEmpty ? submission.flow.code : submission.flow.id;
    final typeKey = submission.type.code.isNotEmpty ? submission.type.code : submission.type.id;
    final answers = <Map<String, dynamic>>[
      if (submission.goal.isNotEmpty)
        {'field_key': 'goal', 'value_text': submission.goal},
      if (submission.whatIBring.isNotEmpty)
        {'field_key': 'collaboration_bring', 'value_options': submission.whatIBring},
      if (submission.whatINeed.isNotEmpty)
        {'field_key': 'collaboration_need', 'value_options': submission.whatINeed},
      ...submission.customAnswers.entries
          .where((e) =>
              e.key != 'goal' &&
              e.key != 'collaboration_bring' &&
              e.key != 'collaboration_need' &&
              e.value != null &&
              e.value.toString().trim().isNotEmpty)
          .map((e) {
        if (e.value is List) {
          return {'field_key': e.key, 'value_options': e.value};
        } else {
          return {'field_key': e.key, 'value_text': e.value.toString()};
        }
      }),
    ];

    final titleText = submission.effectiveGoal.isNotEmpty
        ? submission.effectiveGoal
        : (submission.goal.isNotEmpty ? submission.goal : submission.type.name);

    final filters = <String, dynamic>{
      if (submission.industry != null) 'industry': submission.industry,
      if (submission.geography != null) 'geography': submission.geography,
      if (submission.businessStage != null) 'business_stage': submission.businessStage,
      if (submission.timeline != null) 'timeline': submission.timeline,
      if (submission.expectedOutcome.isNotEmpty) 'expected_outcome': submission.expectedOutcome,
      if (submission.customAnswers['referral_industry'] != null)
        'industry': submission.customAnswers['referral_industry'],
      if (submission.customAnswers['referral_geography'] != null)
        'geography': submission.customAnswers['referral_geography'],
    };

    final sanitizedVisibility = (submission.visibility == 'circle' || submission.visibility == 'connections')
        ? submission.visibility
        : 'public';

    final additionalData = <String, dynamic>{
      'flow_id': submission.flow.id,
      'type_id': submission.type.id,
      if (submission.flow.code.isNotEmpty) 'flow_code': submission.flow.code,
      if (submission.type.code.isNotEmpty) 'type_code': submission.type.code,
      'title': titleText,
      'goal': submission.effectiveGoal,
      'description': submission.effectiveGoal,
      'details': submission.effectiveGoal,
      'visibility': sanitizedVisibility,
      'post_to_timeline': submission.postToTimeline,
      if (submission.customAnswers['who_to_meet'] != null)
        'who_to_meet': submission.customAnswers['who_to_meet'],
      if (submission.customAnswers['ideal_profile'] != null)
        'ideal_profile': submission.customAnswers['ideal_profile'],
      if (submission.customAnswers['referral_reason'] != null)
        'referral_reason': submission.customAnswers['referral_reason'],
      if (submission.customAnswers['what_i_offer'] != null)
        'what_i_offer': submission.customAnswers['what_i_offer'],
      if (filters.isNotEmpty) 'filters': filters,
      ...filters,
    };

    return remoteDataSource.createAskDraft(
      flow: flowKey,
      type: typeKey,
      title: titleText,
      answers: answers,
      additionalData: additionalData,
    );
  }

  @override
  Future<bool> saveAskFilters({
    required String askId,
    required AskSubmissionEntity submission,
  }) {
    final filters = <String, dynamic>{
      if (submission.industry != null) 'industry': submission.industry,
      if (submission.geography != null) 'geography': submission.geography,
      if (submission.businessStage != null) 'business_stage': submission.businessStage,
      if (submission.timeline != null) 'timeline': submission.timeline,
      if (submission.expectedOutcome.isNotEmpty) 'expected_outcome': submission.expectedOutcome,
      if (submission.customAnswers['referral_industry'] != null)
        'industry': submission.customAnswers['referral_industry'],
      if (submission.customAnswers['referral_geography'] != null)
        'geography': submission.customAnswers['referral_geography'],
    };
    return remoteDataSource.saveAskFilters(askId: askId, filters: filters);
  }

  @override
  Future<bool> updateAskTimelinePreference(String askId, bool postToTimeline) {
    return remoteDataSource.updateAskTimelinePreference(askId, postToTimeline);
  }

  @override
  Future<bool> publishAsk(
    String askId, {
    bool postToTimeline = true,
    AskSubmissionEntity? submission,
  }) {
    String? contentText;
    Map<String, dynamic>? additionalData;

    if (submission != null) {
      final goal = submission.effectiveGoal;
      final fName = submission.flow.name;
      final tName = submission.type.name;
      contentText = '$goal\n\n$fName: $tName';

      final filters = <String, dynamic>{
        if (submission.industry != null) 'industry': submission.industry,
        if (submission.geography != null) 'geography': submission.geography,
        if (submission.businessStage != null) 'business_stage': submission.businessStage,
        if (submission.timeline != null) 'timeline': submission.timeline,
        if (submission.expectedOutcome.isNotEmpty) 'expected_outcome': submission.expectedOutcome,
      };

      final sanitizedVisibility = (submission.visibility == 'circle' || submission.visibility == 'connections')
          ? submission.visibility
          : 'public';

      additionalData = <String, dynamic>{
        'flow_id': submission.flow.id,
        'type_id': submission.type.id,
        'title': goal,
        'goal': goal,
        'description': goal,
        'details': goal,
        'visibility': sanitizedVisibility,
        'post_to_timeline': postToTimeline,
        if (filters.isNotEmpty) 'filters': filters,
        ...filters,
      };
    }

    return remoteDataSource.publishAsk(
      askId,
      postToTimeline: postToTimeline,
      contentText: contentText,
      visibility: submission?.visibility,
      additionalData: additionalData,
    );
  }

  @override
  Future<List<AskMatchPeerEntity>> getAskMatches(String askId) {
    return remoteDataSource.getAskMatches(askId);
  }

  @override
  Future<bool> submitAskResponse({
    required String askId,
    required String responseType,
    required String message,
    required String timeline,
    Map<String, dynamic>? extraData,
  }) {
    return remoteDataSource.submitAskResponse(
      askId: askId,
      responseType: responseType,
      message: message,
      timeline: timeline,
      extraData: extraData,
    );
  }

  @override
  Future<List<AskResponseItemEntity>> getAskResponses(String askId) async {
    final models = await remoteDataSource.getAskResponses(askId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AskHistoryItemEntity>> getAskHistory(String askId) async {
    final models = await remoteDataSource.getAskHistory(askId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AskItemEntity>> getMyAsks({
    String? flow,
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    final models = await remoteDataSource.getMyAsks(
      flow: flow,
      status: status,
      page: page,
      perPage: perPage,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<AskItemEntity>> getPeersFeed({
    String? scope,
    int page = 1,
    int perPage = 15,
  }) async {
    final models = await remoteDataSource.getPeersFeed(
      scope: scope,
      page: page,
      perPage: perPage,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<bool> congratulateAsk(String askId, {String? comment}) {
    return remoteDataSource.congratulateAsk(askId, comment: comment);
  }

  @override
  Future<bool> toggleSaveAsk(String askId) {
    return remoteDataSource.toggleSaveAsk(askId);
  }

  @override
  Future<bool> updateAskStatus({
    required String askId,
    required String status,
    int? statusId,
    String? outcomeStatus,
    String? approxValue,
    String? note,
    bool? shareStory,
    bool? anonymousTotal,
  }) {
    return remoteDataSource.updateAskStatus(
      askId: askId,
      status: status,
      statusId: statusId,
      outcomeStatus: outcomeStatus,
      approxValue: approxValue,
      note: note,
      shareStory: shareStory,
      anonymousTotal: anonymousTotal,
    );
  }
}
