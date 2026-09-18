import '../../domain/entities/business_deal_pagination_entity.dart';

class BusinessDealPaginationModel extends BusinessDealPaginationEntity {
  const BusinessDealPaginationModel({
    super.currentPage = 1,
    super.lastPage = 1,
    super.perPage = 20,
    super.total = 0,
    super.businessDealsGiven,
    super.businessDealsReceived,
    super.totalBusinessDeals,
  });

  factory BusinessDealPaginationModel.fromJson(
    Map<String, dynamic>? json, {
    int? businessDealsGiven,
    int? businessDealsReceived,
    int? totalBusinessDeals,
  }) {
    if (json == null) {
      return BusinessDealPaginationModel(
        businessDealsGiven: businessDealsGiven,
        businessDealsReceived: businessDealsReceived,
        totalBusinessDeals: totalBusinessDeals,
      );
    }
    return BusinessDealPaginationModel(
      currentPage: int.tryParse(json['current_page']?.toString() ?? '') ?? 1,
      lastPage: int.tryParse(json['last_page']?.toString() ?? '') ?? 1,
      perPage: int.tryParse(json['per_page']?.toString() ?? '') ?? 20,
      total: int.tryParse(json['total']?.toString() ?? '') ?? 0,
      businessDealsGiven: businessDealsGiven ??
          int.tryParse(json['business_deals_given']?.toString() ?? ''),
      businessDealsReceived: businessDealsReceived ??
          int.tryParse(json['business_deals_received']?.toString() ?? ''),
      totalBusinessDeals: totalBusinessDeals ??
          int.tryParse(json['total_business_deals']?.toString() ?? ''),
    );
  }
}
