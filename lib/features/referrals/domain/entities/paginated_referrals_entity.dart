import 'package:equatable/equatable.dart';
import 'referral_entity.dart';
import 'referral_pagination_entity.dart';

class PaginatedReferralsEntity extends Equatable {
  final List<ReferralEntity> items;
  final ReferralPaginationEntity pagination;

  const PaginatedReferralsEntity({
    this.items = const [],
    this.pagination = const ReferralPaginationEntity(),
  });

  @override
  List<Object?> get props => [items, pagination];
}
