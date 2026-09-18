import '../../domain/entities/referral_pagination_entity.dart';

class ReferralPaginationModel extends ReferralPaginationEntity {
  const ReferralPaginationModel({
    super.currentPage = 1,
    super.lastPage = 1,
    super.perPage = 15,
    super.total = 0,
  });

  factory ReferralPaginationModel.fromJson(Map<String, dynamic> json) {
    return ReferralPaginationModel(
      currentPage: int.tryParse(json['current_page']?.toString() ??
              json['currentPage']?.toString() ??
              json['page']?.toString() ??
              '') ??
          1,
      lastPage: int.tryParse(json['last_page']?.toString() ??
              json['lastPage']?.toString() ??
              json['total_pages']?.toString() ??
              '') ??
          1,
      perPage: int.tryParse(json['per_page']?.toString() ??
              json['perPage']?.toString() ??
              json['limit']?.toString() ??
              '') ??
          15,
      total: int.tryParse(json['total']?.toString() ??
              json['total_records']?.toString() ??
              json['count']?.toString() ??
              '') ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}
