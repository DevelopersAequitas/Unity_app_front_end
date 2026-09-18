import 'dart:io';
import '../../domain/entities/create_p2p_meeting_params.dart';
import '../../domain/entities/create_p2p_meeting_request_params.dart';
import '../../domain/entities/p2p_meeting_entity.dart';
import '../../domain/entities/p2p_meeting_request_entity.dart';
import '../../domain/entities/p2p_meeting_user_summary_entity.dart';
import '../../domain/entities/p2p_reschedule_request_entity.dart';
import '../../domain/entities/reschedule_p2p_meeting_params.dart';
import '../../domain/repositories/p2p_meetings_repository.dart';
import '../datasources/p2p_meetings_remote_datasource.dart';

class P2pMeetingsRepositoryImpl implements P2pMeetingsRepository {
  final P2pMeetingsRemoteDataSource _remoteDataSource;

  P2pMeetingsRepositoryImpl({
    required this._remoteDataSource,
  });

  @override
  Future<List<P2pMeetingEntity>> getP2pMeetingsHistory({
    required String filter,
  }) async {
    final models = await _remoteDataSource.getP2pMeetingsHistory(
      filter: filter,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<P2pMeetingEntity> getSingleP2pMeeting(String id) async {
    final model = await _remoteDataSource.getSingleP2pMeeting(id);
    return model.toEntity();
  }

  @override
  Future<P2pMeetingUserSummaryEntity> getUserP2pMeetingsSummary(
    String userId, {
    int perPage = 20,
  }) async {
    final model = await _remoteDataSource.getUserP2pMeetingsSummary(
      userId,
      perPage: perPage,
    );
    return model.toEntity();
  }

  @override
  Future<P2pMeetingEntity> logP2pMeeting(CreateP2pMeetingParams params) async {
    final model = await _remoteDataSource.logP2pMeeting(params.toJson());
    return model.toEntity();
  }

  @override
  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  }) {
    return _remoteDataSource.uploadActivityCreative(
      activityId: activityId,
      postId: postId,
      creativeImage: creativeImage,
    );
  }

  @override
  Future<List<P2pMeetingRequestEntity>> getP2pMeetingRequestsInbox({
    String? status,
  }) async {
    final models = await _remoteDataSource.getP2pMeetingRequestsInbox(
      status: status,
    );
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<P2pMeetingRequestEntity>> getP2pMeetingRequestsSent() async {
    final models = await _remoteDataSource.getP2pMeetingRequestsSent();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<P2pMeetingRequestEntity> getSingleP2pMeetingRequest(String id) async {
    final model = await _remoteDataSource.getSingleP2pMeetingRequest(id);
    return model.toEntity();
  }

  @override
  Future<P2pMeetingRequestEntity> sendP2pMeetingRequest(
    CreateP2pMeetingRequestParams params,
  ) async {
    final model = await _remoteDataSource.sendP2pMeetingRequest(params.toJson());
    return model.toEntity();
  }

  @override
  Future<void> acceptP2pMeetingRequest(String id) {
    return _remoteDataSource.acceptP2pMeetingRequest(id);
  }

  @override
  Future<void> rejectP2pMeetingRequest(String id) {
    return _remoteDataSource.rejectP2pMeetingRequest(id);
  }

  @override
  Future<void> cancelP2pMeetingRequest(String id) {
    return _remoteDataSource.cancelP2pMeetingRequest(id);
  }

  @override
  Future<P2pRescheduleRequestEntity> requestReschedule(
    String requestId,
    RescheduleP2pMeetingParams params,
  ) async {
    final model = await _remoteDataSource.requestReschedule(
      requestId,
      params.toJson(),
    );
    return model.toEntity();
  }

  @override
  Future<List<P2pRescheduleRequestEntity>>
      getPendingRescheduleRequestsReceived() async {
    final models =
        await _remoteDataSource.getPendingRescheduleRequestsReceived();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> approveRescheduleRequest(String id) {
    return _remoteDataSource.approveRescheduleRequest(id);
  }

  @override
  Future<void> rejectRescheduleRequest(String id, {String? reason}) {
    return _remoteDataSource.rejectRescheduleRequest(id, reason: reason);
  }
}
