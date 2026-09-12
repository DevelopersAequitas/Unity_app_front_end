import 'package:equatable/equatable.dart';
import '../../domain/entities/brand_partner_entity.dart';
import '../../domain/entities/timeline_item_entity.dart';
import '../../domain/entities/timeline_pagination_entity.dart';

enum HomeFeedStatus { initial, loading, success, error }

class HomeState extends Equatable {
  final HomeFeedStatus status;
  final List<TimelineItemEntity> items;
  final List<BrandPartnerEntity> brandPartners;
  final TimelinePaginationEntity pagination;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String activeFilter;
  final String? errorMessage;

  const HomeState({
    this.status = HomeFeedStatus.initial,
    this.items = const [],
    this.brandPartners = const [],
    this.pagination = const TimelinePaginationEntity(),
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.activeFilter = 'All',
    this.errorMessage,
  });

  HomeState copyWith({
    HomeFeedStatus? status,
    List<TimelineItemEntity>? items,
    List<BrandPartnerEntity>? brandPartners,
    TimelinePaginationEntity? pagination,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? activeFilter,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      items: items ?? this.items,
      brandPartners: brandPartners ?? this.brandPartners,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    items,
    brandPartners,
    pagination,
    isLoadingMore,
    isRefreshing,
    activeFilter,
    errorMessage,
  ];
}
