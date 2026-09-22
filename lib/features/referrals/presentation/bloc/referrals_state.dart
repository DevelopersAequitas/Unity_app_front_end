import 'package:equatable/equatable.dart';
import '../../domain/entities/referral_entity.dart';
import '../../domain/entities/referral_leaderboard_entity.dart';
import '../../domain/entities/referral_pagination_entity.dart';
import '../../domain/entities/referral_stats_entity.dart';
import '../../domain/entities/referral_status_entity.dart';
import 'referrals_event.dart';

enum ReferralsStatus { initial, loading, success, failure }

class ReferralsState extends Equatable {
  final ReferralTab activeTab;
  final ReferralsStatus receivedStatus;
  final ReferralsStatus givenStatus;
  final ReferralsStatus leaderboardStatus;
  final List<ReferralEntity> receivedReferrals;
  final List<ReferralEntity> givenReferrals;
  final List<ReferralLeaderboardEntity> leaderboardList;
  final ReferralPaginationEntity receivedPagination;
  final ReferralPaginationEntity givenPagination;
  final ReferralStatsEntity stats;
  final List<ReferralStatusEntity> availableStatuses;
  final bool isLoadingMore;
  final String searchQuery;
  final String? statusFilter;
  final String? errorMessage;
  final bool isUpdatingStatus;

  const ReferralsState({
    this.activeTab = ReferralTab.leaderboard,
    this.receivedStatus = ReferralsStatus.initial,
    this.givenStatus = ReferralsStatus.initial,
    this.leaderboardStatus = ReferralsStatus.initial,
    this.receivedReferrals = const [],
    this.givenReferrals = const [],
    this.leaderboardList = const [],
    this.receivedPagination = const ReferralPaginationEntity(),
    this.givenPagination = const ReferralPaginationEntity(),
    this.stats = const ReferralStatsEntity(),
    this.availableStatuses = const [
      ReferralStatusEntity(id: 1, name: 'Pending'),
      ReferralStatusEntity(id: 2, name: 'Contacted'),
      ReferralStatusEntity(id: 3, name: 'Got Business'),
      ReferralStatusEntity(id: 4, name: 'Not Qualified'),
    ],
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.statusFilter,
    this.errorMessage,
    this.isUpdatingStatus = false,
  });

  bool _matchesFilter(ReferralEntity item) {
    if (statusFilter != null && statusFilter!.isNotEmpty) {
      if (item.statusName.toLowerCase() != statusFilter!.toLowerCase()) {
        return false;
      }
    }

    if (searchQuery.trim().isEmpty) return true;
    final q = searchQuery.trim().toLowerCase();
    final name = item.peerName.toLowerCase();
    final refOf = item.referralOf.toLowerCase();
    final city = (item.city ?? item.peerLocation ?? '').toLowerCase();
    final company = (item.peerCompany ?? '').toLowerCase();
    final designation = (item.peerDesignation ?? '').toLowerCase();
    final category = (item.category ?? '').toLowerCase();
    final phone = (item.phone ?? '').toLowerCase();
    final email = (item.email ?? '').toLowerCase();
    final address = (item.address ?? '').toLowerCase();
    final remarks = (item.remarks ?? '').toLowerCase();
    final refType = item.referralTypeLabel.toLowerCase();

    return name.contains(q) ||
        refOf.contains(q) ||
        city.contains(q) ||
        company.contains(q) ||
        designation.contains(q) ||
        category.contains(q) ||
        phone.contains(q) ||
        email.contains(q) ||
        address.contains(q) ||
        remarks.contains(q) ||
        refType.contains(q);
  }

  List<ReferralEntity> get currentList {
    final list = activeTab == ReferralTab.received
        ? receivedReferrals
        : givenReferrals;
    return list.where(_matchesFilter).toList();
  }

  List<ReferralLeaderboardEntity> get filteredLeaderboardList {
    if (searchQuery.trim().isEmpty) return leaderboardList;
    final q = searchQuery.trim().toLowerCase();
    return leaderboardList.where((b) {
      return b.displayName.toLowerCase().contains(q) ||
          (b.companyName ?? '').toLowerCase().contains(q) ||
          (b.designation ?? '').toLowerCase().contains(q) ||
          (b.city ?? '').toLowerCase().contains(q) ||
          (b.category ?? '').toLowerCase().contains(q);
    }).toList();
  }

  ReferralsStatus get currentStatus {
    if (activeTab == ReferralTab.leaderboard) return leaderboardStatus;
    return activeTab == ReferralTab.received ? receivedStatus : givenStatus;
  }

  ReferralPaginationEntity get currentPagination =>
      activeTab == ReferralTab.received ? receivedPagination : givenPagination;

  ReferralsState copyWith({
    ReferralTab? activeTab,
    ReferralsStatus? receivedStatus,
    ReferralsStatus? givenStatus,
    ReferralsStatus? leaderboardStatus,
    List<ReferralEntity>? receivedReferrals,
    List<ReferralEntity>? givenReferrals,
    List<ReferralLeaderboardEntity>? leaderboardList,
    ReferralPaginationEntity? receivedPagination,
    ReferralPaginationEntity? givenPagination,
    ReferralStatsEntity? stats,
    List<ReferralStatusEntity>? availableStatuses,
    bool? isLoadingMore,
    String? searchQuery,
    String? statusFilter,
    bool clearStatusFilter = false,
    String? errorMessage,
    bool? isUpdatingStatus,
  }) {
    return ReferralsState(
      activeTab: activeTab ?? this.activeTab,
      receivedStatus: receivedStatus ?? this.receivedStatus,
      givenStatus: givenStatus ?? this.givenStatus,
      leaderboardStatus: leaderboardStatus ?? this.leaderboardStatus,
      receivedReferrals: receivedReferrals ?? this.receivedReferrals,
      givenReferrals: givenReferrals ?? this.givenReferrals,
      leaderboardList: leaderboardList ?? this.leaderboardList,
      receivedPagination: receivedPagination ?? this.receivedPagination,
      givenPagination: givenPagination ?? this.givenPagination,
      stats: stats ?? this.stats,
      availableStatuses: availableStatuses ?? this.availableStatuses,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      errorMessage: errorMessage,
      isUpdatingStatus: isUpdatingStatus ?? this.isUpdatingStatus,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        receivedStatus,
        givenStatus,
        leaderboardStatus,
        receivedReferrals,
        givenReferrals,
        leaderboardList,
        receivedPagination,
        givenPagination,
        stats,
        availableStatuses,
        isLoadingMore,
        searchQuery,
        statusFilter,
        errorMessage,
        isUpdatingStatus,
      ];
}
