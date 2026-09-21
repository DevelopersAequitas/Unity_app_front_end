import 'package:equatable/equatable.dart';
import '../../domain/entities/business_deal_entity.dart';
import '../../domain/entities/business_deal_leaderboard_entity.dart';
import '../../domain/entities/business_deal_pagination_entity.dart';
import 'business_deals_event.dart';

enum BusinessDealsStatus { initial, loading, success, failure }

class BusinessDealsState extends Equatable {
  final BusinessDealTab activeTab;
  final BusinessDealsStatus receivedStatus;
  final BusinessDealsStatus givenStatus;
  final BusinessDealsStatus leaderboardStatus;
  final List<BusinessDealEntity> receivedDeals;
  final List<BusinessDealEntity> givenDeals;
  final List<BusinessDealEntity> userDeals;
  final List<BusinessDealLeaderboardEntity> leaderboardList;
  final BusinessDealPaginationEntity receivedPagination;
  final BusinessDealPaginationEntity givenPagination;
  final BusinessDealPaginationEntity userPagination;
  final bool isLoadingMore;
  final String searchQuery;
  final String? errorMessage;

  const BusinessDealsState({
    this.activeTab = BusinessDealTab.received,
    this.receivedStatus = BusinessDealsStatus.initial,
    this.givenStatus = BusinessDealsStatus.initial,
    this.leaderboardStatus = BusinessDealsStatus.initial,
    this.receivedDeals = const [],
    this.givenDeals = const [],
    this.userDeals = const [],
    this.leaderboardList = const [],
    this.receivedPagination = const BusinessDealPaginationEntity(),
    this.givenPagination = const BusinessDealPaginationEntity(),
    this.userPagination = const BusinessDealPaginationEntity(),
    this.isLoadingMore = false,
    this.searchQuery = '',
    this.errorMessage,
  });

  bool _matchesQuery(BusinessDealEntity deal, String query) {
    if (query.trim().isEmpty) return true;
    final q = query.trim().toLowerCase();
    return deal.peerName.toLowerCase().contains(q) ||
        (deal.city ?? deal.peerLocation ?? '').toLowerCase().contains(q) ||
        (deal.peerCompany ?? '').toLowerCase().contains(q) ||
        (deal.peerDesignation ?? '').toLowerCase().contains(q) ||
        (deal.category ?? '').toLowerCase().contains(q) ||
        (deal.comment ?? '').toLowerCase().contains(q) ||
        deal.dealAmount.toString().contains(q) ||
        deal.businessTypeLabel.toLowerCase().contains(q);
  }

  List<BusinessDealEntity> get currentList {
    final list = activeTab == BusinessDealTab.received
        ? receivedDeals
        : givenDeals;
    if (searchQuery.trim().isEmpty) return list;
    return list.where((d) => _matchesQuery(d, searchQuery)).toList();
  }

  List<BusinessDealLeaderboardEntity> get filteredLeaderboardList {
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

  BusinessDealsStatus get currentStatus {
    switch (activeTab) {
      case BusinessDealTab.received:
        return receivedStatus;
      case BusinessDealTab.given:
        return givenStatus;
      case BusinessDealTab.leaderboard:
        return leaderboardStatus;
    }
  }

  BusinessDealPaginationEntity get currentPagination =>
      activeTab == BusinessDealTab.received ? receivedPagination : givenPagination;

  List<BusinessDealEntity> get filteredUserDeals {
    if (searchQuery.trim().isEmpty) return userDeals;
    return userDeals.where((d) => _matchesQuery(d, searchQuery)).toList();
  }

  BusinessDealsState copyWith({
    BusinessDealTab? activeTab,
    BusinessDealsStatus? receivedStatus,
    BusinessDealsStatus? givenStatus,
    BusinessDealsStatus? leaderboardStatus,
    List<BusinessDealEntity>? receivedDeals,
    List<BusinessDealEntity>? givenDeals,
    List<BusinessDealEntity>? userDeals,
    List<BusinessDealLeaderboardEntity>? leaderboardList,
    BusinessDealPaginationEntity? receivedPagination,
    BusinessDealPaginationEntity? givenPagination,
    BusinessDealPaginationEntity? userPagination,
    bool? isLoadingMore,
    String? searchQuery,
    String? errorMessage,
  }) {
    return BusinessDealsState(
      activeTab: activeTab ?? this.activeTab,
      receivedStatus: receivedStatus ?? this.receivedStatus,
      givenStatus: givenStatus ?? this.givenStatus,
      leaderboardStatus: leaderboardStatus ?? this.leaderboardStatus,
      receivedDeals: receivedDeals ?? this.receivedDeals,
      givenDeals: givenDeals ?? this.givenDeals,
      userDeals: userDeals ?? this.userDeals,
      leaderboardList: leaderboardList ?? this.leaderboardList,
      receivedPagination: receivedPagination ?? this.receivedPagination,
      givenPagination: givenPagination ?? this.givenPagination,
      userPagination: userPagination ?? this.userPagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        activeTab,
        receivedStatus,
        givenStatus,
        leaderboardStatus,
        receivedDeals,
        givenDeals,
        userDeals,
        leaderboardList,
        receivedPagination,
        givenPagination,
        userPagination,
        isLoadingMore,
        searchQuery,
        errorMessage,
      ];
}

