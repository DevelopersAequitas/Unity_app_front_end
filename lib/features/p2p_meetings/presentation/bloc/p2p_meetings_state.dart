import 'package:equatable/equatable.dart';
import '../../domain/entities/p2p_meeting_entity.dart';
import '../../domain/entities/p2p_meeting_leaderboard_entity.dart';
import '../../domain/entities/p2p_meeting_request_entity.dart';
import '../../domain/entities/p2p_reschedule_request_entity.dart';

enum P2pMeetingsStatus { initial, loading, success, failure, actionSuccess }

class P2pMeetingsState extends Equatable {
  final P2pMeetingsStatus status;
  final P2pMeetingsStatus leaderboardStatus;
  final String topTab; // 'leaderboard', 'completed', or 'scheduled'
  final String completedSubTab; // 'i_initiated' or 'peer_initiated'
  final String scheduledSubTab; // 'received', 'sent', 'reschedules'
  final String searchQuery;
  final List<P2pMeetingEntity> iInitiatedMeetings;
  final List<P2pMeetingEntity> peerInitiatedMeetings;
  final List<P2pMeetingRequestEntity> receivedRequests;
  final List<P2pMeetingRequestEntity> sentRequests;
  final List<P2pRescheduleRequestEntity> rescheduleRequests;
  final List<P2pMeetingLeaderboardEntity> leaderboardList;
  final String? errorMessage;
  final String? successMessage;

  const P2pMeetingsState({
    this.status = P2pMeetingsStatus.initial,
    this.leaderboardStatus = P2pMeetingsStatus.initial,
    this.topTab = 'leaderboard',
    this.completedSubTab = 'i_initiated',
    this.scheduledSubTab = 'received',
    this.searchQuery = '',
    this.iInitiatedMeetings = const [],
    this.peerInitiatedMeetings = const [],
    this.receivedRequests = const [],
    this.sentRequests = const [],
    this.rescheduleRequests = const [],
    this.leaderboardList = const [],
    this.errorMessage,
    this.successMessage,
  });

  List<P2pMeetingEntity> get filteredCompletedMeetings {
    final list = completedSubTab == 'i_initiated'
        ? iInitiatedMeetings
        : peerInitiatedMeetings;
    if (searchQuery.trim().isEmpty) return list;
    final q = searchQuery.trim().toLowerCase();
    return list.where((m) {
      final name = m.peerName.toLowerCase();
      final place = (m.meetingPlace ?? '').toLowerCase();
      final remarks = (m.remarks ?? '').toLowerCase();
      return name.contains(q) || place.contains(q) || remarks.contains(q);
    }).toList();
  }

  List<P2pMeetingRequestEntity> get filteredScheduledRequests {
    final list = scheduledSubTab == 'received' ? receivedRequests : sentRequests;
    final activeList = list.where((r) {
      final s = r.status.toLowerCase();
      return s != 'completed' && s != 'done' && s != 'rejected' && s != 'cancelled';
    }).toList();
    if (searchQuery.trim().isEmpty) return activeList;
    final q = searchQuery.trim().toLowerCase();
    return activeList.where((r) {
      final reqName = r.requesterName.toLowerCase();
      final invName = r.inviteeName.toLowerCase();
      final place = (r.place ?? '').toLowerCase();
      final msg = (r.message ?? '').toLowerCase();
      return reqName.contains(q) ||
          invName.contains(q) ||
          place.contains(q) ||
          msg.contains(q);
    }).toList();
  }

  List<P2pRescheduleRequestEntity> get filteredRescheduleRequests {
    if (searchQuery.trim().isEmpty) return rescheduleRequests;
    final q = searchQuery.trim().toLowerCase();
    return rescheduleRequests.where((r) {
      final name = (r.requesterName ?? '').toLowerCase();
      final reason = (r.reason ?? '').toLowerCase();
      final place = (r.newPlace ?? '').toLowerCase();
      return name.contains(q) || reason.contains(q) || place.contains(q);
    }).toList();
  }

  List<P2pMeetingLeaderboardEntity> get filteredLeaderboardList {
    if (searchQuery.trim().isEmpty) return leaderboardList;
    final q = searchQuery.trim().toLowerCase();
    return leaderboardList.where((b) {
      final name = b.displayName.toLowerCase();
      final company = (b.companyName ?? '').toLowerCase();
      final city = (b.city ?? '').toLowerCase();
      final cat = (b.category ?? '').toLowerCase();
      return name.contains(q) ||
          company.contains(q) ||
          city.contains(q) ||
          cat.contains(q);
    }).toList();
  }

  P2pMeetingsState copyWith({
    P2pMeetingsStatus? status,
    P2pMeetingsStatus? leaderboardStatus,
    String? topTab,
    String? completedSubTab,
    String? scheduledSubTab,
    String? searchQuery,
    List<P2pMeetingEntity>? iInitiatedMeetings,
    List<P2pMeetingEntity>? peerInitiatedMeetings,
    List<P2pMeetingRequestEntity>? receivedRequests,
    List<P2pMeetingRequestEntity>? sentRequests,
    List<P2pRescheduleRequestEntity>? rescheduleRequests,
    List<P2pMeetingLeaderboardEntity>? leaderboardList,
    String? errorMessage,
    String? successMessage,
  }) {
    return P2pMeetingsState(
      status: status ?? this.status,
      leaderboardStatus: leaderboardStatus ?? this.leaderboardStatus,
      topTab: topTab ?? this.topTab,
      completedSubTab: completedSubTab ?? this.completedSubTab,
      scheduledSubTab: scheduledSubTab ?? this.scheduledSubTab,
      searchQuery: searchQuery ?? this.searchQuery,
      iInitiatedMeetings: iInitiatedMeetings ?? this.iInitiatedMeetings,
      peerInitiatedMeetings: peerInitiatedMeetings ?? this.peerInitiatedMeetings,
      receivedRequests: receivedRequests ?? this.receivedRequests,
      sentRequests: sentRequests ?? this.sentRequests,
      rescheduleRequests: rescheduleRequests ?? this.rescheduleRequests,
      leaderboardList: leaderboardList ?? this.leaderboardList,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        leaderboardStatus,
        topTab,
        completedSubTab,
        scheduledSubTab,
        searchQuery,
        iInitiatedMeetings,
        peerInitiatedMeetings,
        receivedRequests,
        sentRequests,
        rescheduleRequests,
        leaderboardList,
        errorMessage,
        successMessage,
      ];
}

