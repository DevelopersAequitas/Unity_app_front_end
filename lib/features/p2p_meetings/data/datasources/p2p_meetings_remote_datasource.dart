import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/p2p_meeting_leaderboard_model.dart';
import '../models/p2p_meeting_model.dart';
import '../models/p2p_meeting_request_model.dart';
import '../models/p2p_meeting_user_summary_model.dart';
import '../models/p2p_reschedule_request_model.dart';

abstract class P2pMeetingsRemoteDataSource {
  Future<List<P2pMeetingLeaderboardModel>> getP2pMeetingsLeaderboard();

  Future<List<P2pMeetingModel>> getP2pMeetingsHistory({
    required String filter,
  });

  Future<P2pMeetingModel> getSingleP2pMeeting(String id);

  Future<P2pMeetingUserSummaryModel> getUserP2pMeetingsSummary(
    String userId, {
    int perPage = 20,
  });

  Future<P2pMeetingModel> logP2pMeeting(Map<String, dynamic> data);

  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  });

  Future<List<P2pMeetingRequestModel>> getP2pMeetingRequestsInbox({
    String? status,
  });

  Future<List<P2pMeetingRequestModel>> getP2pMeetingRequestsSent();

  Future<P2pMeetingRequestModel> getSingleP2pMeetingRequest(String id);

  Future<P2pMeetingRequestModel> sendP2pMeetingRequest(
    Map<String, dynamic> data,
  );

  Future<void> acceptP2pMeetingRequest(String id);

  Future<void> rejectP2pMeetingRequest(String id);

  Future<void> cancelP2pMeetingRequest(String id);

  Future<P2pRescheduleRequestModel> requestReschedule(
    String requestId,
    Map<String, dynamic> data,
  );

  Future<List<P2pRescheduleRequestModel>>
      getPendingRescheduleRequestsReceived();

  Future<void> approveRescheduleRequest(String id);

  Future<void> rejectRescheduleRequest(String id, {String? reason});
}

class P2pMeetingsRemoteDataSourceImpl implements P2pMeetingsRemoteDataSource {
  final DioClient _dioClient;

  P2pMeetingsRemoteDataSourceImpl({required DioClient dioClient})
      // ignore: prefer_initializing_formals
      : _dioClient = dioClient;

  @override
  Future<List<P2pMeetingLeaderboardModel>> getP2pMeetingsLeaderboard() async {
    final endpoints = [
      ApiEndpoints.leaderboardP2pMeetings,
      '/leaderboards/p2p-meetings',
      '/leaderboards/p2p_meetings',
      '/leaderboards/p2p',
      '/leaderboards/p2p-meeting',
      '/leaderboard/p2p-meetings',
      '/leaderboard/p2p',
    ];
    dynamic data;
    for (final ep in endpoints) {
      try {
        final response = await _dioClient.dio.get(ep);
        if (response.data != null) {
          data = response.data;
          break;
        }
      } catch (_) {
        // continue
      }
    }
    if (data == null) {
      final response = await _dioClient.dio.get(ApiEndpoints.leaderboardP2pMeetings);
      data = response.data;
    }

    List<dynamic> items = [];
    if (data is List) {
      items = data;
    } else if (data is Map<String, dynamic>) {
      final nestedData = data['data'];
      if (nestedData is Map<String, dynamic>) {
        if (nestedData['peers'] is List) {
          items = nestedData['peers'] as List;
        } else if (nestedData['items'] is List) {
          items = nestedData['items'] as List;
        } else if (nestedData['results'] is List) {
          items = nestedData['results'] as List;
        } else if (nestedData['leaderboard'] is List) {
          items = nestedData['leaderboard'] as List;
        }
      } else if (nestedData is List) {
        items = nestedData;
      } else if (data['peers'] is List) {
        items = data['peers'] as List;
      } else if (data['items'] is List) {
        items = data['items'] as List;
      } else if (data['leaderboard'] is List) {
        items = data['leaderboard'] as List;
      } else if (data['results'] is List) {
        items = data['results'] as List;
      }
    }
    return items.asMap().entries.map((entry) {
      final item = entry.value as Map<String, dynamic>;
      return P2pMeetingLeaderboardModel.fromJson(
        item,
        fallbackRank: entry.key + 1,
      );
    }).toList();
  }

  @override
  Future<List<P2pMeetingModel>> getP2pMeetingsHistory({
    required String filter,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.activitiesP2pMeetings,
      queryParameters: {'filter': filter},
    );

    final rawData = response.data;
    List items = [];
    if (rawData is Map) {
      if (rawData['data'] is Map && rawData['data']['items'] is List) {
        items = rawData['data']['items'];
      } else if (rawData['data'] is List) {
        items = rawData['data'];
      } else if (rawData['items'] is List) {
        items = rawData['items'];
      }
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((j) => P2pMeetingModel.fromJson(j))
        .toList();
  }

  @override
  Future<P2pMeetingModel> getSingleP2pMeeting(String id) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.singleP2pMeeting(id),
    );
    final rawData = response.data;
    final map = rawData is Map && rawData['data'] is Map
        ? rawData['data'] as Map<String, dynamic>
        : (rawData as Map<String, dynamic>);
    return P2pMeetingModel.fromJson(map);
  }

  @override
  Future<P2pMeetingUserSummaryModel> getUserP2pMeetingsSummary(
    String userId, {
    int perPage = 20,
  }) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.userP2pMeetings(userId),
      queryParameters: {'per_page': perPage},
    );
    final rawData = response.data;
    final map = rawData is Map && rawData['data'] is Map
        ? rawData['data'] as Map<String, dynamic>
        : (rawData as Map<String, dynamic>);
    return P2pMeetingUserSummaryModel.fromJson(map);
  }

  @override
  Future<P2pMeetingModel> logP2pMeeting(Map<String, dynamic> data) async {
    dynamic lastError;
    final endpoints = [
      ApiEndpoints.activitiesP2pMeetings,
      '/p2p-meetings',
    ];

    for (final endpoint in endpoints) {
      try {
        final response = await _dioClient.dio.post(
          endpoint,
          data: data,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          final rawData = response.data;
          Map<String, dynamic> map = {};
          if (rawData is Map<String, dynamic>) {
            if (rawData['data'] is Map<String, dynamic>) {
              map = Map<String, dynamic>.from(rawData['data'] as Map<String, dynamic>);
              if (map['meeting'] is Map<String, dynamic>) {
                final meetingMap = Map<String, dynamic>.from(map['meeting'] as Map<String, dynamic>);
                if (map['coins'] != null && meetingMap['coins'] == null) meetingMap['coins'] = map['coins'];
                if (map['life_impact'] != null && meetingMap['life_impact'] == null) meetingMap['life_impact'] = map['life_impact'];
                if (map['post_id'] != null && meetingMap['post_id'] == null) meetingMap['post_id'] = map['post_id'];
                map = meetingMap;
              } else if (map['activity'] is Map<String, dynamic>) {
                final activityMap = Map<String, dynamic>.from(map['activity'] as Map<String, dynamic>);
                if (map['coins'] != null && activityMap['coins'] == null) activityMap['coins'] = map['coins'];
                if (map['life_impact'] != null && activityMap['life_impact'] == null) activityMap['life_impact'] = map['life_impact'];
                map = activityMap;
              }
            } else {
              map = Map<String, dynamic>.from(rawData);
            }
          }
          return P2pMeetingModel.fromJson(map);
        }
      } catch (e) {
        lastError = e;
      }
    }

    throw lastError ?? Exception('Failed to log P2P meeting');
  }

  @override
  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  }) async {
    final fileName = creativeImage.path.split(RegExp(r'[\\/]')).last;
    final effectivePostId = postId.isNotEmpty ? postId : activityId;
    final effectiveActivityId = activityId.isNotEmpty ? activityId : effectivePostId;

    final endpoints = [
      ApiEndpoints.activityCreatives,
      '/activity-creatives',
      '/my/activity-creatives',
    ];

    dynamic lastError;
    for (final endpoint in endpoints) {
      try {
        final formData = FormData.fromMap({
          'activity_type': 'P2PMeeting',
          'activity_id': effectiveActivityId,
          'post_id': effectivePostId,
          'title': 'P2P Meeting Creative',
          'description': 'Creative generated from Flutter',
          'meta[template]': 'requirement_creative',
          'meta[source]': 'flutter',
          'media_type': 'image',
          'creative_image': await MultipartFile.fromFile(
            creativeImage.path,
            filename: fileName,
          ),
          'creative_media': await MultipartFile.fromFile(
            creativeImage.path,
            filename: fileName,
          ),
        });

        final response = await _dioClient.dio.post(
          endpoint,
          data: formData,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          debugPrint('✅ uploadActivityCreative SUCCESS via $endpoint');
          return;
        }
      } catch (e) {
        lastError = e;
      }
    }

    if (lastError != null) {
      debugPrint('⚠️ uploadActivityCreative error: $lastError');
    }
  }

  @override
  Future<List<P2pMeetingRequestModel>> getP2pMeetingRequestsInbox({
    String? status,
  }) async {
    final query = <String, dynamic>{};
    if (status != null && status.isNotEmpty) query['status'] = status;

    final response = await _dioClient.dio.get(
      ApiEndpoints.p2pMeetingRequestsInbox,
      queryParameters: query,
    );

    final rawData = response.data;
    List items = [];
    if (rawData is Map) {
      if (rawData['data'] is Map && rawData['data']['items'] is List) {
        items = rawData['data']['items'];
      } else if (rawData['data'] is List) {
        items = rawData['data'];
      } else if (rawData['items'] is List) {
        items = rawData['items'];
      }
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((j) => P2pMeetingRequestModel.fromJson(j))
        .toList();
  }

  @override
  Future<List<P2pMeetingRequestModel>> getP2pMeetingRequestsSent() async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.p2pMeetingRequestsSent,
    );

    final rawData = response.data;
    List items = [];
    if (rawData is Map) {
      if (rawData['data'] is Map && rawData['data']['items'] is List) {
        items = rawData['data']['items'];
      } else if (rawData['data'] is List) {
        items = rawData['data'];
      } else if (rawData['items'] is List) {
        items = rawData['items'];
      }
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((j) => P2pMeetingRequestModel.fromJson(j))
        .toList();
  }

  @override
  Future<P2pMeetingRequestModel> getSingleP2pMeetingRequest(String id) async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.singleP2pMeetingRequest(id),
    );
    final rawData = response.data;
    final map = rawData is Map && rawData['data'] is Map
        ? rawData['data'] as Map<String, dynamic>
        : (rawData as Map<String, dynamic>);
    return P2pMeetingRequestModel.fromJson(map);
  }

  @override
  Future<P2pMeetingRequestModel> sendP2pMeetingRequest(
    Map<String, dynamic> data,
  ) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.p2pMeetingRequests,
      data: data,
    );
    final rawData = response.data;
    final map = rawData is Map && rawData['data'] is Map
        ? rawData['data'] as Map<String, dynamic>
        : (rawData as Map<String, dynamic>);
    return P2pMeetingRequestModel.fromJson(map);
  }

  @override
  Future<void> acceptP2pMeetingRequest(String id) async {
    await _dioClient.dio.post(
      ApiEndpoints.acceptP2pMeetingRequest(id),
      data: {},
    );
  }

  @override
  Future<void> rejectP2pMeetingRequest(String id) async {
    await _dioClient.dio.post(
      ApiEndpoints.rejectP2pMeetingRequest(id),
      data: {},
    );
  }

  @override
  Future<void> cancelP2pMeetingRequest(String id) async {
    await _dioClient.dio.post(
      ApiEndpoints.cancelP2pMeetingRequest(id),
      data: {},
    );
  }

  @override
  Future<P2pRescheduleRequestModel> requestReschedule(
    String requestId,
    Map<String, dynamic> data,
  ) async {
    final response = await _dioClient.dio.post(
      ApiEndpoints.rescheduleP2pMeetingRequest(requestId),
      data: data,
    );
    final rawData = response.data;
    final map = rawData is Map && rawData['data'] is Map
        ? rawData['data'] as Map<String, dynamic>
        : (rawData as Map<String, dynamic>);
    return P2pRescheduleRequestModel.fromJson(map);
  }

  @override
  Future<List<P2pRescheduleRequestModel>>
      getPendingRescheduleRequestsReceived() async {
    final response = await _dioClient.dio.get(
      ApiEndpoints.pendingRescheduleRequestsReceived,
    );

    final rawData = response.data;
    List items = [];
    if (rawData is Map) {
      if (rawData['data'] is Map && rawData['data']['items'] is List) {
        items = rawData['data']['items'];
      } else if (rawData['data'] is List) {
        items = rawData['data'];
      } else if (rawData['items'] is List) {
        items = rawData['items'];
      }
    } else if (rawData is List) {
      items = rawData;
    }

    return items
        .whereType<Map<String, dynamic>>()
        .map((j) => P2pRescheduleRequestModel.fromJson(j))
        .toList();
  }

  @override
  Future<void> approveRescheduleRequest(String id) async {
    await _dioClient.dio.post(
      ApiEndpoints.approveRescheduleRequest(id),
      data: {},
    );
  }

  @override
  Future<void> rejectRescheduleRequest(String id, {String? reason}) async {
    await _dioClient.dio.post(
      ApiEndpoints.rejectRescheduleRequest(id),
      data: {
        if (reason != null && reason.isNotEmpty) 'reason': reason,
      },
    );
  }
}
