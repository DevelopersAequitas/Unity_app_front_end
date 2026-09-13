import 'package:equatable/equatable.dart';
import '../../domain/entities/brand_partner_entity.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/entities/timeline_pagination_entity.dart';

enum HomeFeedStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeFeedStatus status;
  // Raw items from API (full list, never filtered)
  final List<TimelineItemEntity> allItems;
  final List<BrandPartnerEntity> brandPartners;
  final TimelinePaginationEntity pagination;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String activeFilter;
  final String searchQuery;
  final String? errorMessage;

  const HomeState({
    this.status = HomeFeedStatus.initial,
    this.allItems = const [],
    this.brandPartners = const [],
    this.pagination = const TimelinePaginationEntity(),
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.activeFilter = 'All',
    this.searchQuery = '',
    this.errorMessage,
  });

  /// Returns client-side filtered items based on searchQuery.
  List<TimelineItemEntity> get items {
    final q = searchQuery.trim().toLowerCase();
    if (q.isEmpty) return allItems;
    return allItems.where((item) {
      final name = (item.author?.displayName ?? '').toLowerCase();
      final company = (item.author?.companyName ?? '').toLowerCase();
      final designation = (item.author?.designation ?? '').toLowerCase();
      final category = (item.author?.level4Category ?? '').toLowerCase();
      final content = item.contentText.toLowerCase();
      return name.contains(q) ||
          company.contains(q) ||
          designation.contains(q) ||
          category.contains(q) ||
          content.contains(q);
    }).toList();
  }

  HomeState copyWith({
    HomeFeedStatus? status,
    List<TimelineItemEntity>? allItems,
    List<BrandPartnerEntity>? brandPartners,
    TimelinePaginationEntity? pagination,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? activeFilter,
    String? searchQuery,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      allItems: allItems ?? this.allItems,
      brandPartners: brandPartners ?? this.brandPartners,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      activeFilter: activeFilter ?? this.activeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    allItems,
    brandPartners,
    pagination,
    isLoadingMore,
    isRefreshing,
    activeFilter,
    searchQuery,
    errorMessage,
  ];
}
