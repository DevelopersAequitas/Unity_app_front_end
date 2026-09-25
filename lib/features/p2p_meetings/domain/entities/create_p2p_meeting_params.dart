import 'package:equatable/equatable.dart';

class CreateP2pMeetingParams extends Equatable {
  final String peerUserId;
  final String? peerName;
  final String meetingDate; // Y-m-d
  final String meetingPlace;
  final String remarks;
  final List<String> mediaFileIds;
  final String? p2pMeetingRequestId;

  const CreateP2pMeetingParams({
    required this.peerUserId,
    this.peerName,
    required this.meetingDate,
    required this.meetingPlace,
    required this.remarks,
    this.mediaFileIds = const [],
    this.p2pMeetingRequestId,
  });

  Map<String, dynamic> toJson() => {
        'to_user_id': peerUserId,       // Required by Laravel activities table
        'peer_user_id': peerUserId,     // Required by P2P meeting relation
        if (peerName != null && peerName!.isNotEmpty) 'peer_name': peerName,
        'meeting_date': meetingDate,
        'date': meetingDate,
        'meeting_place': meetingPlace,
        'place': meetingPlace,
        'remarks': remarks,
        'notes': remarks,
        if (p2pMeetingRequestId != null && p2pMeetingRequestId!.isNotEmpty) ...{
          'p2p_meeting_request_id': p2pMeetingRequestId,
          'meeting_request_id': p2pMeetingRequestId,
        },
        if (mediaFileIds.isNotEmpty) ...{
          'media': mediaFileIds.map((id) => {'file_id': id}).toList(),
          'media_file_ids': mediaFileIds,
          'media_file_id': mediaFileIds.first,
          'media_type': 'image',
        },
      };

  @override
  List<Object?> get props => [
        peerUserId,
        peerName,
        meetingDate,
        meetingPlace,
        remarks,
        mediaFileIds,
        p2pMeetingRequestId,
      ];
}
