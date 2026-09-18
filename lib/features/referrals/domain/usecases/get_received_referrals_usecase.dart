import '../entities/paginated_referrals_entity.dart';
import '../repositories/referrals_repository.dart';

class GetReceivedReferralsUseCase {
  final ReferralsRepository repository;

  GetReceivedReferralsUseCase(this.repository);

  Future<PaginatedReferralsEntity> call({int page = 1, int perPage = 15}) {
    return repository.getReceivedReferrals(page: page, perPage: perPage);
  }
}
