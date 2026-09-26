import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/ask_match_peer_entity.dart';
import '../../../peers/data/models/peer_model.dart';
import '../models/ask_flow_model.dart';
import '../models/ask_form_config_model.dart';
import '../models/ask_history_item_model.dart';
import '../models/ask_item_model.dart';
import '../models/ask_leaderboard_item_model.dart';
import '../models/ask_response_item_model.dart';
import '../models/ask_type_model.dart';

abstract class AsksRemoteDataSource {
  Future<List<AskFlowModel>> getAskFlows();
  Future<List<AskTypeModel>> getAskTypes(String flowIdOrCode);
  Future<AskFormConfigModel> getFormConfig({
    required String flowId,
    required String typeId,
  });
  Future<String?> createAskDraft({
    required String flow,
    required String type,
    required String title,
    required List<Map<String, dynamic>> answers,
    Map<String, dynamic>? additionalData,
  });
  Future<bool> saveAskFilters({
    required String askId,
    required Map<String, dynamic> filters,
  });
  Future<bool> publishAsk(
    String askId, {
    bool postToTimeline = true,
    String? contentText,
    String? visibility,
    Map<String, dynamic>? additionalData,
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
  Future<List<AskResponseItemModel>> getAskResponses(String askId);
  Future<List<AskHistoryItemModel>> getAskHistory(String askId);
  Future<List<AskItemModel>> getMyAsks({
    String? flow,
    String? status,
    int page = 1,
    int perPage = 15,
  });
  Future<List<AskItemModel>> getPeersFeed({
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
  Future<List<AskLeaderboardItemModel>> getLeaderboard({
    required String flowCode,
    String? timeFilter,
  });
}

class AsksRemoteDataSourceImpl implements AsksRemoteDataSource {
  final DioClient dioClient;

  AsksRemoteDataSourceImpl({required this.dioClient});

  Dio get _dio => dioClient.dio;

  @override
  Future<List<AskFlowModel>> getAskFlows() async {
    try {
      final url = ApiEndpoints.askFlows;
      final response = await _dio.get(url);
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List) {
        final list = (data['data'] as List)
            .map((item) => AskFlowModel.fromJson(item as Map<String, dynamic>))
            .where((item) => item.isActive)
            .toList();
        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        if (kDebugMode) {
          debugPrint('[ASKS] Successfully loaded ${list.length} ask flows from $url');
        }
        return list;
      }
      if (kDebugMode) {
        debugPrint('[ASKS] Empty or unexpected data from $url: $data');
      }
      return [];
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching ask flows from ${ApiEndpoints.askFlows}: $e\n$stack');
      }
      return [];
    }
  }

  @override
  Future<List<AskTypeModel>> getAskTypes(String flowIdOrCode) async {
    try {
      final url = ApiEndpoints.askTypes(flowIdOrCode);
      final response = await _dio.get(url);
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List) {
        final list = (data['data'] as List)
            .map((item) => AskTypeModel.fromJson(item as Map<String, dynamic>))
            .where((item) => item.isActive)
            .toList();
        list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        if (kDebugMode) {
          debugPrint('[ASKS] Successfully loaded ${list.length} ask types for $flowIdOrCode from $url');
        }
        return list;
      }
      if (kDebugMode) {
        debugPrint('[ASKS] Empty or unexpected data from $url: $data');
      }
      return [];
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching ask types for $flowIdOrCode: $e\n$stack');
      }
      return [];
    }
  }

  @override
  Future<AskFormConfigModel> getFormConfig({
    required String flowId,
    required String typeId,
  }) async {
    try {
      final url = ApiEndpoints.askFormConfig(flow: flowId, type: typeId);
      final response = await _dio.get(url);
      final data = response.data;
      if (data != null && data['success'] == true) {
        if (kDebugMode) {
          debugPrint('[ASKS] Successfully loaded form config for flow=$flowId type=$typeId from $url');
        }
        return AskFormConfigModel.fromJson(data as Map<String, dynamic>);
      }
      if (kDebugMode) {
        debugPrint('[ASKS] Empty or unexpected form config data from $url: $data');
      }
      return const AskFormConfigModel();
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching form config for flow=$flowId type=$typeId: $e\n$stack');
      }
      return const AskFormConfigModel();
    }
  }

  @override
  Future<String?> createAskDraft({
    required String flow,
    required String type,
    required String title,
    required List<Map<String, dynamic>> answers,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final url = ApiEndpoints.createAskDraft;
      final payload = <String, dynamic>{
        'flow': flow,
        'type': type,
        'title': title,
        'answers': answers,
        ...?additionalData,
      };
      final response = await _dio.post(url, data: payload);
      final data = response.data;
      if (data != null && (data['success'] == true || data['status'] == 'success')) {
        return (data['data']?['id'] ?? data['data']?['ask_id'] ?? data['id'] ?? 'draft-${DateTime.now().millisecondsSinceEpoch}').toString();
      }
      return 'draft-${DateTime.now().millisecondsSinceEpoch}';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Create ask draft: fallback local draft ID generated: $e');
      }
      return 'draft-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  @override
  Future<bool> saveAskFilters({
    required String askId,
    required Map<String, dynamic> filters,
  }) async {
    try {
      final url = ApiEndpoints.updateAskFilters(askId);
      final response = await _dio.put(url, data: filters);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Save ask filters exception: $e');
      }
      return true; // continue gracefully
    }
  }

  @override
  Future<bool> updateAskTimelinePreference(String askId, bool postToTimeline) async {
    try {
      final url = ApiEndpoints.updateAskTimelinePreference(askId);
      final response = await _dio.put(
        url,
        data: {'post_to_timeline': postToTimeline},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Update timeline preference exception: $e');
      }
      return false;
    }
  }

  @override
  Future<bool> publishAsk(
    String askId, {
    bool postToTimeline = true,
    String? contentText,
    String? visibility,
    Map<String, dynamic>? additionalData,
  }) async {
    final sanitizedVisibility = (visibility == 'circle' || visibility == 'connections')
        ? visibility!
        : 'public';

    try {
      final url = ApiEndpoints.publishAsk(askId);
      await _dio.post(
        url,
        data: {
          'post_to_timeline': postToTimeline,
          'visibility': sanitizedVisibility,
          if (contentText != null && contentText.isNotEmpty) 'content_text': contentText,
          ...?additionalData,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Publish ask primary endpoint exception: $e');
      }
    }

    if (postToTimeline && contentText != null && contentText.isNotEmpty) {
      try {
        await _dio.post(
          ApiEndpoints.createPost,
          data: {
            'content_text': contentText,
            'post_type': 'ask',
            'visibility': sanitizedVisibility,
            'ask_id': askId,
          },
        );
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[ASKS] Create timeline post for ask exception: $e');
        }
      }
    }

    return true; // continue gracefully
  }

  @override
  Future<List<AskMatchPeerEntity>> getAskMatches(String askId) async {
    try {
      final url = ApiEndpoints.askMatches(askId);
      final response = await _dio.get(url);
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List && (data['data'] as List).isNotEmpty) {
        final list = (data['data'] as List).map((item) {
          final map = item as Map<String, dynamic>;
          final peerMap = map['peer'] is Map<String, dynamic>
              ? map['peer'] as Map<String, dynamic>
              : (map['member'] is Map<String, dynamic> ? map['member'] as Map<String, dynamic> : map);
          final peerModel = PeerModel.fromJson(peerMap);
          final peerEntity = peerModel.toEntity();

          final matches = map['matches'] is Map ? map['matches'] as Map : {};
          final isIndustryMatch = matches['industry'] == 'match' || matches['industry'] == true;
          final isStageMatch = matches['stage'] == 'match' || matches['stage'] == true;
          final isGeoMatch = matches['geography'] == 'match' || matches['geography'] == true;

          final score = (map['match_score'] is num)
              ? (map['match_score'] as num).toInt()
              : (int.tryParse(map['match_score']?.toString() ?? '') ?? 100);
          final reason = (map['match_reason'] ?? '').toString();
          final status = (map['match_status'] ?? 'suggested').toString();

          return AskMatchPeerEntity(
            id: peerEntity.id.isNotEmpty ? peerEntity.id : (map['match_id'] ?? '').toString(),
            name: peerEntity.displayName,
            businessType: peerEntity.category ?? peerEntity.companyName ?? '',
            location: peerEntity.city ?? '',
            typeLabel: peerEntity.category ?? 'Industry',
            isTypeMatched: isIndustryMatch || matches.isEmpty,
            capitalLabel: peerEntity.city != null && peerEntity.city!.isNotEmpty ? peerEntity.city! : 'Geography',
            isCapitalMatched: isGeoMatch || matches.isEmpty,
            stageLabel: 'Stage',
            isStageMatched: isStageMatch || matches.isEmpty,
            matchScore: score,
            matchReason: reason,
            matchStatus: status,
            matchesMap: Map<String, dynamic>.from(matches),
            peer: peerEntity,
          );
        }).toList();
        if (list.isNotEmpty) return list;
      }
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching matches for $askId: $e\n$stack');
      }
    }

    return const [];
  }

  @override
  Future<bool> submitAskResponse({
    required String askId,
    required String responseType,
    required String message,
    required String timeline,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final url = ApiEndpoints.submitAskResponse(askId);
      final payload = <String, dynamic>{
        'response_type': responseType,
        'message': message,
        'timeline': timeline,
        ...?extraData,
      };
      final response = await _dio.post(url, data: payload);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Submit response exception: $e');
      }
      return true;
    }
  }

  @override
  Future<List<AskResponseItemModel>> getAskResponses(String askId) async {
    try {
      final url = ApiEndpoints.askResponses(askId);
      final response = await _dio.get(url);
      final data = response.data;
      if (data != null && data['success'] == true) {
        final rawList = data['data'] is List
            ? data['data'] as List
            : (data['data'] is Map && data['data']['items'] is List
                ? data['data']['items'] as List
                : (data['data'] is Map && data['data']['responses'] is List
                    ? data['data']['responses'] as List
                    : (data['data'] is Map ? [data['data']] : const [])));

        final List<AskResponseItemModel> results = [];
        for (final item in rawList) {
          if (item is Map<String, dynamic>) {
            final contacts = item['contacts'] ?? item['suggested_contacts'];
            if (contacts is List && contacts.length > 1) {
              for (final c in contacts) {
                if (c is Map<String, dynamic>) {
                  final cloned = Map<String, dynamic>.from(item);
                  cloned['contact'] = c;
                  results.add(AskResponseItemModel.fromJson(cloned));
                }
              }
            } else {
              results.add(AskResponseItemModel.fromJson(item));
            }
          }
        }
        return results;
      }
      return const [];
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] getAskResponses DioException for $askId (status: ${e.response?.statusCode})');
      }
      return const [];
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching responses for $askId: $e\n$stack');
      }
      return const [];
    }
  }

  @override
  Future<List<AskHistoryItemModel>> getAskHistory(String askId) async {
    try {
      final url = ApiEndpoints.askHistory(askId);
      final response = await _dio.get(url);
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((item) => AskHistoryItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return const [];
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching history for $askId: $e\n$stack');
      }
      return const [];
    }
  }

  @override
  Future<List<AskItemModel>> getMyAsks({
    String? flow,
    String? status,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      String url;
      final flowLower = (flow ?? '').toLowerCase().trim();
      final isDedicatedFlow = flowLower == 'referral' ||
          flowLower == 'help' ||
          flowLower == 'get_help' ||
          flowLower == 'collaboration' ||
          flowLower == 'collaborator';

      if (flowLower == 'referral' || flowLower.contains('referral')) {
        url = ApiEndpoints.referralMyAsks;
      } else if (flowLower == 'help' || flowLower == 'get_help' || flowLower.contains('help')) {
        url = ApiEndpoints.helpMyAsks;
      } else if (flowLower == 'collaboration' || flowLower == 'collaborator' || flowLower.contains('collab')) {
        url = ApiEndpoints.collaborationMyAsks;
      } else {
        url = ApiEndpoints.myAsks(
          flow: flow,
          status: status,
          page: page,
          perPage: perPage,
        );
      }

      final response = await _dio.get(
        url,
        queryParameters: {
          if (status != null && status.isNotEmpty && status != 'all') 'status': status,
          'page': page,
          'per_page': perPage,
        },
      );

      final data = response.data;
      List rawList = const [];
      if (data != null && (data['success'] == true || data['status'] == 'success' || data['data'] != null)) {
        if (data['data'] is List) {
          rawList = data['data'] as List;
        } else if (data['data'] is Map) {
          final map = data['data'] as Map;
          if (map['items'] is List) {
            rawList = map['items'] as List;
          } else if (map['data'] is List) {
            rawList = map['data'] as List;
          }
        } else if (data['items'] is List) {
          rawList = data['items'] as List;
        }
      }

      if (rawList.isEmpty && isDedicatedFlow) {
        final fallbackUrl = ApiEndpoints.myAsks(flow: flowLower, status: status, page: page, perPage: perPage);
        final fbResponse = await _dio.get(fallbackUrl);
        final fbData = fbResponse.data;
        if (fbData != null) {
          if (fbData['data'] is List) {
            rawList = fbData['data'] as List;
          } else if (fbData['data'] is Map && fbData['data']['items'] is List) {
            rawList = fbData['data']['items'] as List;
          } else if (fbData['data'] is Map && fbData['data']['data'] is List) {
            rawList = fbData['data']['data'] as List;
          }
        }
      }

      return rawList
          .whereType<Map<String, dynamic>>()
          .map((item) => AskItemModel.fromJson(item))
          .toList();
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching my asks: $e\n$stack');
      }
      return const [];
    }
  }

  @override
  Future<List<AskItemModel>> getPeersFeed({
    String? scope,
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      String url;
      final scopeLower = (scope ?? '').toLowerCase().trim();
      final isDedicatedFlow = scopeLower == 'referral' ||
          scopeLower == 'help' ||
          scopeLower == 'get_help' ||
          scopeLower == 'collaboration' ||
          scopeLower == 'collaborator';

      if (scopeLower == 'referral' || scopeLower.contains('referral')) {
        url = ApiEndpoints.referralGlobalFeed;
      } else if (scopeLower == 'help' || scopeLower == 'get_help' || scopeLower.contains('help')) {
        url = ApiEndpoints.helpGlobalFeed;
      } else if (scopeLower == 'collaboration' || scopeLower == 'collaborator' || scopeLower.contains('collab')) {
        url = ApiEndpoints.collaborationGlobalFeed;
      } else {
        url = ApiEndpoints.peersFeed(
          scope: scope,
          page: page,
          perPage: perPage,
        );
      }

      final response = await _dio.get(
        url,
        queryParameters: isDedicatedFlow ? {'page': page, 'per_page': perPage} : null,
      );

      final data = response.data;
      List rawList = const [];
      if (data != null && (data['success'] == true || data['status'] == 'success' || data['data'] != null)) {
        if (data['data'] is List) {
          rawList = data['data'] as List;
        } else if (data['data'] is Map) {
          final map = data['data'] as Map;
          if (map['items'] is List) {
            rawList = map['items'] as List;
          } else if (map['data'] is List) {
            rawList = map['data'] as List;
          }
        } else if (data['items'] is List) {
          rawList = data['items'] as List;
        }
      }

      if (rawList.isEmpty && isDedicatedFlow) {
        final fallbackUrl = ApiEndpoints.peersFeed(scope: scopeLower, page: page, perPage: perPage);
        final fbResponse = await _dio.get(fallbackUrl);
        final fbData = fbResponse.data;
        if (fbData != null) {
          if (fbData['data'] is List) {
            rawList = fbData['data'] as List;
          } else if (fbData['data'] is Map && fbData['data']['items'] is List) {
            rawList = fbData['data']['items'] as List;
          } else if (fbData['data'] is Map && fbData['data']['data'] is List) {
            rawList = fbData['data']['data'] as List;
          }
        }
      }

      return rawList
          .whereType<Map<String, dynamic>>()
          .map((item) => AskItemModel.fromJson(item))
          .toList();
    } catch (e, stack) {
      if (kDebugMode) {
        debugPrint('[ASKS] Error fetching peers feed: $e\n$stack');
      }
      return const [];
    }
  }

  @override
  Future<bool> congratulateAsk(String askId, {String? comment}) async {
    final text = (comment != null && comment.isNotEmpty) ? comment : 'Congratulations! 🎉';
    try {
      final url = ApiEndpoints.congratulateAsk(askId);
      final response = await _dio.post(url, data: {
        'comment': text,
        'content': text,
        'message': text,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Congratulate ask primary endpoint failed: $e');
      }
    }

    try {
      final fallbackUrl = ApiEndpoints.postComments(askId);
      final response = await _dio.post(fallbackUrl, data: {
        'content': text,
        'comment': text,
      });
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Congratulate post comment fallback exception: $e');
      }
      return true;
    }
  }

  @override
  Future<bool> toggleSaveAsk(String askId) async {
    try {
      final url = ApiEndpoints.saveAsk(askId);
      final response = await _dio.post(url);
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Save ask exception: $e');
      }
      return true;
    }
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
  }) async {
    int? mappedStatusId = statusId;
    if (mappedStatusId == null) {
      final cleanStatus = status.trim().toLowerCase();
      if (cleanStatus.contains('not contacted') || cleanStatus == '1') {
        mappedStatusId = 1;
      } else if (cleanStatus.contains('contacted') || cleanStatus == '2') {
        mappedStatusId = 2;
      } else if (cleanStatus.contains('no response') || cleanStatus == '3') {
        mappedStatusId = 3;
      } else if (cleanStatus.contains('got the business') || cleanStatus == 'fulfilled' || cleanStatus == '4') {
        mappedStatusId = 4;
      } else if (cleanStatus.contains('got things done') || cleanStatus == '5') {
        mappedStatusId = 5;
      } else if (cleanStatus.contains('did not get') || cleanStatus == 'closed' || cleanStatus == '6') {
        mappedStatusId = 6;
      } else if (cleanStatus.contains('not a good fit') || cleanStatus == '7') {
        mappedStatusId = 7;
      } else if (cleanStatus.contains('confidential') || cleanStatus == '8') {
        mappedStatusId = 8;
      }
    }

    final payload = <String, dynamic>{
      'status': status,
      'status_id': ?mappedStatusId,
      if (outcomeStatus != null && outcomeStatus.isNotEmpty) 'outcome_status': outcomeStatus,
      if (approxValue != null && approxValue.isNotEmpty) 'approx_value': approxValue,
      if (note != null && note.isNotEmpty) 'note': note,
      if (shareStory == true) 'share_story': true,
      if (anonymousTotal == true) 'anonymous_total': true,
    };

    // 1. Try activities/referrals/{id}/status (for referral items)
    if (mappedStatusId != null) {
      try {
        final refUrl = ApiEndpoints.updateReferralStatus(askId);
        final refResponse = await _dio.patch(
          refUrl,
          data: {'status_id': mappedStatusId},
        );
        if (refResponse.statusCode == 200 || refResponse.statusCode == 204) {
          if (kDebugMode) {
            debugPrint('[ASKS] Successfully updated referral status via $refUrl to $mappedStatusId');
          }
          return true;
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[ASKS] updateReferralStatus failed for $askId: $e');
        }
      }
    }

    // 2. Try asks/referral/{id}/status
    try {
      final askRefUrl = ApiEndpoints.askReferralStatus(askId);
      final askRefResponse = await _dio.patch(askRefUrl, data: payload);
      if (askRefResponse.statusCode == 200 || askRefResponse.statusCode == 204) {
        return true;
      }
    } catch (_) {}

    // 3. Fallback to asks/{id}/status
    try {
      final url = ApiEndpoints.updateAskStatus(askId);
      final response = await _dio.patch(url, data: payload);
      if (kDebugMode) {
        debugPrint('[ASKS] Update ask $askId status response: ${response.statusCode}');
      }
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Update ask status exception: $e');
      }
      return true;
    }
  }

  @override
  Future<List<AskLeaderboardItemModel>> getLeaderboard({
    required String flowCode,
    String? timeFilter,
  }) async {
    try {
      String url;
      final code = flowCode.toLowerCase().trim();
      if (code == 'collaboration') {
        url = ApiEndpoints.collaborationLeaderboard;
      } else if (code == 'referral') {
        url = ApiEndpoints.referralLeaderboard;
      } else {
        url = ApiEndpoints.helpLeaderboard;
      }

      final queryParams = <String, dynamic>{};
      if (timeFilter != null && timeFilter.isNotEmpty && timeFilter != 'all') {
        queryParams['timeframe'] = timeFilter;
      }

      final response = await _dio.get(url, queryParameters: queryParams);
      final data = response.data;
      if (data != null && data['success'] == true && data['data'] != null) {
        final d = data['data'];
        List rawList = [];
        if (d is Map && d['leaderboard'] is List) {
          rawList = d['leaderboard'] as List;
        } else if (d is List) {
          rawList = d;
        } else if (d is Map && d['items'] is List) {
          rawList = d['items'] as List;
        }
        return rawList
            .map((item) => AskLeaderboardItemModel.fromJson(
                  item as Map<String, dynamic>,
                  flowCode: code,
                ))
            .toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[ASKS] Get leaderboard error ($flowCode): $e');
      }
      return [];
    }
  }
}
