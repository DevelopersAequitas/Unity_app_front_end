import 'package:equatable/equatable.dart';

class P2pRescheduleRequestEntity extends Equatable {
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

  const P2pRescheduleRequestEntity({
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

  @override
  List<Object?> get props => [
        id,
        p2pMeetingRequestId,
        oldScheduledAt,
        newScheduledAt,
        oldPlace,
        newPlace,
        reason,
        status,
        requestedByUserId,
        requestedToUserId,
        requesterName,
        requesterPhotoUrl,
        createdAt,
      ];
}
