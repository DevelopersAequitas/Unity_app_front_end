import 'package:equatable/equatable.dart';
import '../../domain/entities/referral_entity.dart';
import '../../domain/entities/referral_pagination_entity.dart';
import '../../domain/entities/referral_stats_entity.dart';
import '../../domain/entities/referral_status_entity.dart';
import 'referrals_event.dart';

enum ReferralsStatus { initial, loading, success, failure }

class ReferralsState extends Equatable {
  final ReferralTab activeTab;
  final ReferralsStatus receivedStatus;
  final ReferralsStatus givenStatus;
  final List<ReferralEntity> receivedReferrals;
  final List<ReferralEntity> givenReferrals;
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
    this.activeTab = ReferralTab.received,
    this.receivedStatus = ReferralsStatus.initial,
    this.givenStatus = ReferralsStatus.initial,
    this.receivedReferrals = const [],
    this.givenReferrals = const [],
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
    // 1. Status Filter
    if (statusFilter != null && statusFilter!.isNotEmpty) {
      if (item.statusName.toLowerCase() != statusFilter!.toLowerCase()) {
        return false;
      }
    }

    // 2. Search Query
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

  ReferralsStatus get currentStatus =>
      activeTab == ReferralTab.received ? receivedStatus : givenStatus;

  ReferralPaginationEntity get currentPagination =>
      activeTab == ReferralTab.received ? receivedPagination : givenPagination;

  ReferralsState copyWith({
    ReferralTab? activeTab,
    ReferralsStatus? receivedStatus,
    ReferralsStatus? givenStatus,
    List<ReferralEntity>? receivedReferrals,
    List<ReferralEntity>? givenReferrals,
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
      receivedReferrals: receivedReferrals ?? this.receivedReferrals,
      givenReferrals: givenReferrals ?? this.givenReferrals,
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
        receivedReferrals,
        givenReferrals,
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
