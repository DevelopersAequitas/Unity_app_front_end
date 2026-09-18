import 'dart:io';
import '../entities/create_p2p_meeting_params.dart';
import '../entities/create_p2p_meeting_request_params.dart';
import '../entities/p2p_meeting_entity.dart';
import '../entities/p2p_meeting_request_entity.dart';
import '../entities/p2p_meeting_user_summary_entity.dart';
import '../entities/p2p_reschedule_request_entity.dart';
import '../entities/reschedule_p2p_meeting_params.dart';

abstract class P2pMeetingsRepository {
  // Flow 1: Completed Meetings
  Future<List<P2pMeetingEntity>> getP2pMeetingsHistory({
    required String filter, // 'given' (I Initiated) or 'received' (Peer Initiated)
  });

  Future<P2pMeetingEntity> getSingleP2pMeeting(String id);

  Future<P2pMeetingUserSummaryEntity> getUserP2pMeetingsSummary(
    String userId, {
    int perPage = 20,
  });

  Future<P2pMeetingEntity> logP2pMeeting(CreateP2pMeetingParams params);

  Future<void> uploadActivityCreative({
    required String activityId,
    required String postId,
    required File creativeImage,
  });

  // Flow 2: Scheduled Requests & Rescheduling
  Future<List<P2pMeetingRequestEntity>> getP2pMeetingRequestsInbox({
    String? status,
  });

  Future<List<P2pMeetingRequestEntity>> getP2pMeetingRequestsSent();

  Future<P2pMeetingRequestEntity> getSingleP2pMeetingRequest(String id);

  Future<P2pMeetingRequestEntity> sendP2pMeetingRequest(
    CreateP2pMeetingRequestParams params,
  );

  Future<void> acceptP2pMeetingRequest(String id);

  Future<void> rejectP2pMeetingRequest(String id);

  Future<void> cancelP2pMeetingRequest(String id);

  Future<P2pRescheduleRequestEntity> requestReschedule(
    String requestId,
    RescheduleP2pMeetingParams params,
  );

  Future<List<P2pRescheduleRequestEntity>>
      getPendingRescheduleRequestsReceived();

  Future<void> approveRescheduleRequest(String id);

  Future<void> rejectRescheduleRequest(String id, {String? reason});
}
