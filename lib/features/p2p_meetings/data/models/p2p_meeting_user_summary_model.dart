import '../../domain/entities/p2p_meeting_user_summary_entity.dart';
import 'p2p_meeting_model.dart';

class P2pMeetingUserSummaryModel {
  final String userId;
  final int total;
  final int iInitiated;
  final int peerInitiated;
  final List<P2pMeetingModel> items;

  const P2pMeetingUserSummaryModel({
    required this.userId,
    this.total = 0,
    this.iInitiated = 0,
    this.peerInitiated = 0,
    this.items = const [],
  });

  factory P2pMeetingUserSummaryModel.fromJson(Map<String, dynamic> json) {
    final list = <P2pMeetingModel>[];
    if (json['items'] is List) {
      for (final item in json['items']) {
        if (item is Map<String, dynamic>) {
          list.add(P2pMeetingModel.fromJson(item));
        }
      }
    }

    return P2pMeetingUserSummaryModel(
      userId: (json['user_id'] ?? '').toString(),
      total: (json['total'] as num?)?.toInt() ?? 0,
      iInitiated: (json['i_initiated'] as num?)?.toInt() ?? 0,
      peerInitiated: (json['peer_initiated'] as num?)?.toInt() ?? 0,
      items: list,
    );
  }

  P2pMeetingUserSummaryEntity toEntity() => P2pMeetingUserSummaryEntity(
        userId: userId,
        total: total,
        iInitiated: iInitiated,
        peerInitiated: peerInitiated,
        items: items.map((m) => m.toEntity()).toList(),
      );
}
