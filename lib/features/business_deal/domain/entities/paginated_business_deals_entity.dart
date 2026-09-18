import 'package:equatable/equatable.dart';
import 'business_deal_entity.dart';
import 'business_deal_pagination_entity.dart';

class PaginatedBusinessDealsEntity extends Equatable {
  final List<BusinessDealEntity> items;
  final BusinessDealPaginationEntity pagination;

  const PaginatedBusinessDealsEntity({
    this.items = const [],
    this.pagination = const BusinessDealPaginationEntity(),
  });

  @override
  List<Object?> get props => [items, pagination];
}
