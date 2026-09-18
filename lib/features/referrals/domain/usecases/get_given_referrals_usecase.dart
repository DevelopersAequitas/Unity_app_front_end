import '../entities/paginated_referrals_entity.dart';
import '../repositories/referrals_repository.dart';

class GetGivenReferralsUseCase {
  final ReferralsRepository repository;

  GetGivenReferralsUseCase(this.repository);

  Future<PaginatedReferralsEntity> call({int page = 1, int perPage = 15}) {
    return repository.getGivenReferrals(page: page, perPage: perPage);
  }
}
