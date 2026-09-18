import 'package:equatable/equatable.dart';

class CreateP2pMeetingRequestParams extends Equatable {
  final String toUserId;
  final String scheduledAt; // Y-m-d H:i:s or ISO
  final String place;
  final String? message;

  const CreateP2pMeetingRequestParams({
    required this.toUserId,
    required this.scheduledAt,
    required this.place,
    this.message,
  });

  Map<String, dynamic> toJson() => {
        'to_user_id': toUserId,
        'scheduled_at': scheduledAt,
        'place': place,
        if (message != null && message!.isNotEmpty) 'message': message,
      };

  @override
  List<Object?> get props => [
        toUserId,
        scheduledAt,
        place,
        message,
      ];
}
