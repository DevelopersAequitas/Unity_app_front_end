import '../../domain/entities/paginated_business_deals_entity.dart';
import 'business_deal_model.dart';
import 'business_deal_pagination_model.dart';

class PaginatedBusinessDealsModel extends PaginatedBusinessDealsEntity {
  const PaginatedBusinessDealsModel({
    super.items = const [],
    super.pagination = const BusinessDealPaginationModel(),
  });

  factory PaginatedBusinessDealsModel.fromJson(dynamic data) {
    List<BusinessDealModel> items = [];
    BusinessDealPaginationModel pagination = const BusinessDealPaginationModel();
    int? dealsGiven;
    int? dealsReceived;
    int? totalDeals;

    if (data is Map<String, dynamic>) {
      final innerData = data['data'];
      if (innerData is Map<String, dynamic>) {
        dealsGiven = int.tryParse(innerData['business_deals_given']?.toString() ?? '');
        dealsReceived = int.tryParse(innerData['business_deals_received']?.toString() ?? '');
        totalDeals = int.tryParse(innerData['total_business_deals']?.toString() ?? '');

        if (innerData['items'] is List) {
          items = (innerData['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => BusinessDealModel.fromJson(m))
              .toList();
        } else if (innerData['business_deals'] is List) {
          items = (innerData['business_deals'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => BusinessDealModel.fromJson(m))
              .toList();
        } else if (innerData['deals'] is List) {
          items = (innerData['deals'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => BusinessDealModel.fromJson(m))
              .toList();
        }

        if (innerData['pagination'] is Map<String, dynamic>) {
          pagination = BusinessDealPaginationModel.fromJson(
            innerData['pagination'] as Map<String, dynamic>,
            businessDealsGiven: dealsGiven,
            businessDealsReceived: dealsReceived,
            totalBusinessDeals: totalDeals,
          );
        }
      } else if (innerData is List) {
        items = innerData
            .whereType<Map<String, dynamic>>()
            .map((m) => BusinessDealModel.fromJson(m))
            .toList();
      }

      if (data['pagination'] is Map<String, dynamic>) {
        pagination = BusinessDealPaginationModel.fromJson(
          data['pagination'] as Map<String, dynamic>,
          businessDealsGiven: dealsGiven,
          businessDealsReceived: dealsReceived,
          totalBusinessDeals: totalDeals,
        );
      }
    } else if (data is List) {
      items = data
          .whereType<Map<String, dynamic>>()
          .map((m) => BusinessDealModel.fromJson(m))
          .toList();
    }

    if (pagination.total == 0 && items.isNotEmpty) {
      pagination = BusinessDealPaginationModel(
        currentPage: 1,
        lastPage: 1,
        perPage: items.length,
        total: items.length,
        businessDealsGiven: dealsGiven,
        businessDealsReceived: dealsReceived,
        totalBusinessDeals: totalDeals,
      );
    }

    return PaginatedBusinessDealsModel(
      items: items,
      pagination: pagination,
    );
  }
}
