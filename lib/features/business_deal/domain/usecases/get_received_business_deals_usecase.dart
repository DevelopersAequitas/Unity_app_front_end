import '../entities/paginated_business_deals_entity.dart';
import '../repositories/business_deals_repository.dart';

class GetReceivedBusinessDealsUseCase {
  final BusinessDealsRepository repository;

  GetReceivedBusinessDealsUseCase(this.repository);

  Future<PaginatedBusinessDealsEntity> call({int page = 1, int perPage = 20}) {
    return repository.getReceivedBusinessDeals(page: page, perPage: perPage);
  }
}
