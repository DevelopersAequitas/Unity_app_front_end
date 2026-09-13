import '../entities/brand_partner_entity.dart';
import '../repositories/home_repository.dart';

class GetCachedBrandPartnersUseCase {
  final HomeRepository repository;

  GetCachedBrandPartnersUseCase(this.repository);

  Future<List<BrandPartnerEntity>> call() {
    return repository.getCachedBrandPartners();
  }
}
