import '../entities/brand_partner_entity.dart';
import '../repositories/home_repository.dart';

class GetBrandPartnersUseCase {
  final HomeRepository repository;

  const GetBrandPartnersUseCase(this.repository);

  Future<List<BrandPartnerEntity>> call() {
    return repository.getBrandPartners();
  }
}
