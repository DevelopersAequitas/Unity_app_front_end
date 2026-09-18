import '../../domain/entities/p2p_meeting_request_entity.dart';
import 'p2p_reschedule_request_model.dart';

class P2pMeetingRequestModel {
  final String id;
  final String status;
  final String? scheduledAt;
  final String? place;
  final String? message;
  final String? respondedAt;
  final String? createdAt;
  final String? requesterId;
  final String requesterName;
  final String? requesterPhotoUrl;
  final String? requesterDesignation;
  final String? requesterCompany;
  final String? requesterCity;
  final String? requesterCategory;
  final bool isRequesterPro;
  final String? inviteeId;
  final String inviteeName;
  final String? inviteePhotoUrl;
  final String? inviteeDesignation;
  final String? inviteeCompany;
  final String? inviteeCity;
  final String? inviteeCategory;
  final bool isInviteePro;
  final List<P2pRescheduleRequestModel> rescheduleRequests;

  const P2pMeetingRequestModel({
    required this.id,
    required this.status,
    this.scheduledAt,
    this.place,
    this.message,
    this.respondedAt,
    this.createdAt,
    this.requesterId,
    required this.requesterName,
    this.requesterPhotoUrl,
    this.requesterDesignation,
    this.requesterCompany,
    this.requesterCity,
    this.requesterCategory,
    this.isRequesterPro = false,
    this.inviteeId,
    required this.inviteeName,
    this.inviteePhotoUrl,
    this.inviteeDesignation,
    this.inviteeCompany,
    this.inviteeCity,
    this.inviteeCategory,
    this.isInviteePro = false,
    this.rescheduleRequests = const [],
  });

  factory P2pMeetingRequestModel.fromJson(Map<String, dynamic> json) {
    final reqObj = json['requester'] is Map ? json['requester'] : null;
    final invObj = json['invitee'] is Map ? json['invitee'] : null;

    final reqName =
        (reqObj?['display_name'] ??
                reqObj?['name'] ??
                json['requester_name'] ??
                'Requester')
            .toString();
    final invName =
        (invObj?['display_name'] ??
                invObj?['name'] ??
                json['invitee_name'] ??
                'Invitee')
            .toString();

    final reschedList = <P2pRescheduleRequestModel>[];
    if (json['reschedule_requests'] is List) {
      for (final r in json['reschedule_requests']) {
        if (r is Map<String, dynamic>) {
          reschedList.add(P2pRescheduleRequestModel.fromJson(r));
        }
      }
    }

    return P2pMeetingRequestModel(
      id: (json['id'] ?? '').toString(),
      status: (json['status'] ?? 'pending').toString(),
      scheduledAt: (json['scheduled_at'] ?? json['date_time'])?.toString(),
      place: (json['place'] ?? json['location'])?.toString(),
      message: json['message']?.toString(),
      respondedAt: json['responded_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      requesterId: (reqObj?['id'] ?? json['from_user_id'])?.toString(),
      requesterName: reqName,
      requesterPhotoUrl: reqObj?['profile_photo_url']?.toString(),
      requesterDesignation: reqObj?['designation']?.toString(),
      requesterCompany: reqObj?['company_name']?.toString(),
      requesterCity: (reqObj?['city'] ?? reqObj?['location'])?.toString(),
      requesterCategory:
          (reqObj?['category'] ??
                  reqObj?['business_category'] ??
                  reqObj?['main_business_category'])
              ?.toString(),
      isRequesterPro: reqObj?['is_pro'] == true,
      inviteeId: (invObj?['id'] ?? json['to_user_id'])?.toString(),
      inviteeName: invName,
      inviteePhotoUrl: invObj?['profile_photo_url']?.toString(),
      inviteeDesignation: invObj?['designation']?.toString(),
      inviteeCompany: invObj?['company_name']?.toString(),
      inviteeCity: (invObj?['city'] ?? invObj?['location'])?.toString(),
      inviteeCategory:
          (invObj?['category'] ??
                  invObj?['level4_category'] ??
                  invObj?['main_business_category'])
              ?.toString(),
      isInviteePro: invObj?['is_pro'] == true,
      rescheduleRequests: reschedList,
    );
  }

  P2pMeetingRequestEntity toEntity() => P2pMeetingRequestEntity(
    id: id,
    status: status,
    scheduledAt: scheduledAt,
    place: place,
    message: message,
    respondedAt: respondedAt,
    createdAt: createdAt,
    requesterId: requesterId,
    requesterName: requesterName,
    requesterPhotoUrl: requesterPhotoUrl,
    requesterDesignation: requesterDesignation,
    requesterCompany: requesterCompany,
    requesterCity: requesterCity,
    requesterCategory: requesterCategory,
    isRequesterPro: isRequesterPro,
    inviteeId: inviteeId,
    inviteeName: inviteeName,
    inviteePhotoUrl: inviteePhotoUrl,
    inviteeDesignation: inviteeDesignation,
    inviteeCompany: inviteeCompany,
    inviteeCity: inviteeCity,
    inviteeCategory: inviteeCategory,
    isInviteePro: isInviteePro,
    rescheduleRequests: rescheduleRequests.map((r) => r.toEntity()).toList(),
  );
}
