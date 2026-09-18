import '../../domain/entities/p2p_reschedule_request_entity.dart';

class P2pRescheduleRequestModel {
  final String id;
  final String? p2pMeetingRequestId;
  final String? oldScheduledAt;
  final String? newScheduledAt;
  final String? oldPlace;
  final String? newPlace;
  final String? reason;
  final String status;
  final String? requestedByUserId;
  final String? requestedToUserId;
  final String? requesterName;
  final String? requesterPhotoUrl;
  final String? createdAt;

  const P2pRescheduleRequestModel({
    required this.id,
    this.p2pMeetingRequestId,
    this.oldScheduledAt,
    this.newScheduledAt,
    this.oldPlace,
    this.newPlace,
    this.reason,
    this.status = 'pending',
    this.requestedByUserId,
    this.requestedToUserId,
    this.requesterName,
    this.requesterPhotoUrl,
    this.createdAt,
  });

  factory P2pRescheduleRequestModel.fromJson(Map<String, dynamic> json) {
    String rName = '';
    String? rPhoto;
    if (json['requester'] is Map) {
      rName = (json['requester']['display_name'] ?? json['requester']['name'] ?? '').toString();
      rPhoto = json['requester']['profile_photo_url']?.toString();
    } else if (json['requested_by'] is Map) {
      rName = (json['requested_by']['display_name'] ?? json['requested_by']['name'] ?? '').toString();
      rPhoto = json['requested_by']['profile_photo_url']?.toString();
    }

    return P2pRescheduleRequestModel(
      id: (json['reschedule_request_id'] ?? json['id'] ?? '').toString(),
      p2pMeetingRequestId: (json['p2p_meeting_request_id'] ?? json['meeting_request_id'])?.toString(),
      oldScheduledAt: json['old_scheduled_at']?.toString(),
      newScheduledAt: json['new_scheduled_at']?.toString(),
      oldPlace: json['old_place']?.toString(),
      newPlace: json['new_place']?.toString(),
      reason: json['reason']?.toString(),
      status: (json['status'] ?? 'pending').toString(),
      requestedByUserId: json['requested_by_user_id']?.toString(),
      requestedToUserId: json['requested_to_user_id']?.toString(),
      requesterName: rName.isNotEmpty ? rName : null,
      requesterPhotoUrl: rPhoto,
      createdAt: json['created_at']?.toString(),
    );
  }

  P2pRescheduleRequestEntity toEntity() => P2pRescheduleRequestEntity(
        id: id,
        p2pMeetingRequestId: p2pMeetingRequestId,
        oldScheduledAt: oldScheduledAt,
        newScheduledAt: newScheduledAt,
        oldPlace: oldPlace,
        newPlace: newPlace,
        reason: reason,
        status: status,
        requestedByUserId: requestedByUserId,
        requestedToUserId: requestedToUserId,
        requesterName: requesterName,
        requesterPhotoUrl: requesterPhotoUrl,
        createdAt: createdAt,
      );
}
