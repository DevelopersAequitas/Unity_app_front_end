import 'package:equatable/equatable.dart';
import '../../domain/entities/business_deal_entity.dart';
import '../../domain/entities/business_deal_pagination_entity.dart';
import 'business_deals_event.dart';

enum BusinessDealsStatus { initial, loading, success, failure }

class BusinessDealsState extends Equatable {
  final BusinessDealTab activeTab;
  final BusinessDealsStatus receivedStatus;
  final BusinessDealsStatus givenStatus;
  final List<BusinessDealEntity> receivedDeals;
  final List<BusinessDealEntity> givenDeals;
  final List<BusinessDealEntity> userDeals;
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
    this.receivedDeals = const [],
    this.givenDeals = const [],
    this.userDeals = const [],
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
    final name = deal.peerName.toLowerCase();
    final city = (deal.city ?? deal.peerLocation ?? '').toLowerCase();
    final company = (deal.peerCompany ?? '').toLowerCase();
    final designation = (deal.peerDesignation ?? '').toLowerCase();
    final category = (deal.category ?? '').toLowerCase();
    final comment = (deal.comment ?? '').toLowerCase();
    final amount = deal.dealAmount.toString();
    final businessType = deal.businessTypeLabel.toLowerCase();

    return name.contains(q) ||
        city.contains(q) ||
        company.contains(q) ||
        designation.contains(q) ||
        category.contains(q) ||
        comment.contains(q) ||
        amount.contains(q) ||
        businessType.contains(q);
  }

  List<BusinessDealEntity> get currentList {
    final list = activeTab == BusinessDealTab.received
        ? receivedDeals
        : givenDeals;
    if (searchQuery.trim().isEmpty) return list;
    return list.where((d) => _matchesQuery(d, searchQuery)).toList();
  }

  BusinessDealsStatus get currentStatus =>
      activeTab == BusinessDealTab.received ? receivedStatus : givenStatus;

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
    List<BusinessDealEntity>? receivedDeals,
    List<BusinessDealEntity>? givenDeals,
    List<BusinessDealEntity>? userDeals,
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
      receivedDeals: receivedDeals ?? this.receivedDeals,
      givenDeals: givenDeals ?? this.givenDeals,
      userDeals: userDeals ?? this.userDeals,
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
        receivedDeals,
        givenDeals,
        userDeals,
        receivedPagination,
        givenPagination,
        userPagination,
        isLoadingMore,
        searchQuery,
        errorMessage,
      ];
}
