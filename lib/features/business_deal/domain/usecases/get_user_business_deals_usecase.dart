import '../entities/paginated_business_deals_entity.dart';
import '../repositories/business_deals_repository.dart';

class GetUserBusinessDealsUseCase {
  final BusinessDealsRepository repository;

  GetUserBusinessDealsUseCase(this.repository);

  Future<PaginatedBusinessDealsEntity> call(
    String userId, {
    int page = 1,
    int perPage = 20,
  }) {
    return repository.getUserBusinessDeals(userId, page: page, perPage: perPage);
  }
}
