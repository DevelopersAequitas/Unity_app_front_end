import '../entities/paginated_business_deals_entity.dart';
import '../repositories/business_deals_repository.dart';

class GetGivenBusinessDealsUseCase {
  final BusinessDealsRepository repository;

  GetGivenBusinessDealsUseCase(this.repository);

  Future<PaginatedBusinessDealsEntity> call({int page = 1, int perPage = 20}) {
    return repository.getGivenBusinessDeals(page: page, perPage: perPage);
  }
}
