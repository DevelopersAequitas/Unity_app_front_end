import '../../domain/entities/paginated_referrals_entity.dart';
import 'referral_model.dart';
import 'referral_pagination_model.dart';

class PaginatedReferralsModel extends PaginatedReferralsEntity {
  const PaginatedReferralsModel({
    super.items = const [],
    super.pagination = const ReferralPaginationModel(),
  });

  factory PaginatedReferralsModel.fromJson(dynamic data) {
    List<ReferralModel> items = [];
    ReferralPaginationModel pagination = const ReferralPaginationModel();

    if (data is Map<String, dynamic>) {
      // 1. Direct 'data' key or inner object
      final innerData = data['data'];

      if (innerData is Map<String, dynamic>) {
        // e.g. { data: { referrals_given: { data: [...], meta: {...} } } } or { data: { items: [...], pagination: {...} } }
        if (innerData['items'] is List) {
          items = (innerData['items'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => ReferralModel.fromJson(m))
              .toList();
        } else if (innerData['referrals'] is List) {
          items = (innerData['referrals'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => ReferralModel.fromJson(m))
              .toList();
        } else if (innerData['data'] is List) {
          items = (innerData['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((m) => ReferralModel.fromJson(m))
              .toList();
        }

        if (innerData['pagination'] is Map<String, dynamic>) {
          pagination = ReferralPaginationModel.fromJson(
              innerData['pagination'] as Map<String, dynamic>);
        } else if (innerData['meta'] is Map<String, dynamic>) {
          pagination = ReferralPaginationModel.fromJson(
              innerData['meta'] as Map<String, dynamic>);
        }
      } else if (innerData is List) {
        items = innerData
            .whereType<Map<String, dynamic>>()
            .map((m) => ReferralModel.fromJson(m))
            .toList();
      }

      // Check if root has pagination / meta
      if (data['pagination'] is Map<String, dynamic>) {
        pagination = ReferralPaginationModel.fromJson(
            data['pagination'] as Map<String, dynamic>);
      } else if (data['meta'] is Map<String, dynamic>) {
        pagination = ReferralPaginationModel.fromJson(
            data['meta'] as Map<String, dynamic>);
      }
    } else if (data is List) {
      items = data
          .whereType<Map<String, dynamic>>()
          .map((m) => ReferralModel.fromJson(m))
          .toList();
    }

    if (pagination.total == 0 && items.isNotEmpty) {
      pagination = ReferralPaginationModel(
        currentPage: 1,
        lastPage: 1,
        perPage: items.length,
        total: items.length,
      );
    }

    return PaginatedReferralsModel(
      items: items,
      pagination: pagination,
    );
  }

  factory PaginatedReferralsModel.fromGivenOrReceivedSection(
      Map<String, dynamic> sectionJson) {
    List<ReferralModel> items = [];
    ReferralPaginationModel pagination = const ReferralPaginationModel();

    if (sectionJson['data'] is List) {
      items = (sectionJson['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((m) => ReferralModel.fromJson(m))
          .toList();
    }

    if (sectionJson['meta'] is Map<String, dynamic>) {
      pagination = ReferralPaginationModel.fromJson(
          sectionJson['meta'] as Map<String, dynamic>);
    } else if (sectionJson['pagination'] is Map<String, dynamic>) {
      pagination = ReferralPaginationModel.fromJson(
          sectionJson['pagination'] as Map<String, dynamic>);
    }

    if (pagination.total == 0 && items.isNotEmpty) {
      pagination = ReferralPaginationModel(
        currentPage: 1,
        lastPage: 1,
        perPage: items.length,
        total: items.length,
      );
    }

    return PaginatedReferralsModel(
      items: items,
      pagination: pagination,
    );
  }
}
