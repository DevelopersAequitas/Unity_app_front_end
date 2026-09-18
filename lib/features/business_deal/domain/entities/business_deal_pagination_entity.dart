import 'package:equatable/equatable.dart';

class BusinessDealPaginationEntity extends Equatable {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final int? businessDealsGiven;
  final int? businessDealsReceived;
  final int? totalBusinessDeals;

  const BusinessDealPaginationEntity({
    this.currentPage = 1,
    this.lastPage = 1,
    this.perPage = 10,
    this.total = 0,
    this.businessDealsGiven,
    this.businessDealsReceived,
    this.totalBusinessDeals,
  });

  bool get hasMore => currentPage < lastPage;

  @override
  List<Object?> get props => [
        currentPage,
        lastPage,
        perPage,
        total,
        businessDealsGiven,
        businessDealsReceived,
        totalBusinessDeals,
      ];
}
