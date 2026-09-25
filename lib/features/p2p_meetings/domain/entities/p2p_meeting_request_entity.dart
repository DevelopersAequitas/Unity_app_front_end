import 'package:equatable/equatable.dart';
import 'p2p_reschedule_request_entity.dart';

class P2pMeetingRequestEntity extends Equatable {
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
  final List<P2pRescheduleRequestEntity> rescheduleRequests;
  final bool? canLogMeeting;
  final bool? isLogged;

  const P2pMeetingRequestEntity({
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
    this.canLogMeeting,
    this.isLogged,
  });

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isAccepted =>
      status.toLowerCase() == 'accepted' || status.toLowerCase() == 'approved';
  bool get isScheduled =>
      status.toLowerCase() == 'scheduled' || status.toLowerCase() == 'confirmed';
  bool get isCompleted =>
      status.toLowerCase() == 'completed' || status.toLowerCase() == 'done';
  bool get shouldShowLogMeeting =>
      canLogMeeting == true ||
      (isLogged != true && (isAccepted || isScheduled));

  @override
  List<Object?> get props => [
        id,
        status,
        scheduledAt,
        place,
        message,
        respondedAt,
        createdAt,
        requesterId,
        requesterName,
        requesterPhotoUrl,
        requesterDesignation,
        requesterCompany,
        requesterCity,
        requesterCategory,
        isRequesterPro,
        inviteeId,
        inviteeName,
        inviteePhotoUrl,
        inviteeDesignation,
        inviteeCompany,
        inviteeCity,
        inviteeCategory,
        isInviteePro,
        rescheduleRequests,
        canLogMeeting,
        isLogged,
      ];
}
