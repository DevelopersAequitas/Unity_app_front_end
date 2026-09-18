import 'package:equatable/equatable.dart';

class RescheduleP2pMeetingParams extends Equatable {
  final String meetingRequestId;
  final String newScheduledAt;
  final String? newPlace;
  final String? reason;

  const RescheduleP2pMeetingParams({
    required this.meetingRequestId,
    required this.newScheduledAt,
    this.newPlace,
    this.reason,
  });

  Map<String, dynamic> toJson() => {
        'new_scheduled_at': newScheduledAt,
        if (newPlace != null && newPlace!.isNotEmpty) 'new_place': newPlace,
        if (reason != null && reason!.isNotEmpty) 'reason': reason,
      };

  @override
  List<Object?> get props => [
        meetingRequestId,
        newScheduledAt,
        newPlace,
        reason,
      ];
}
