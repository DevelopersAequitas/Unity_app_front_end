import '../entities/business_deal_entity.dart';
import '../entities/create_business_deal_params.dart';
import '../repositories/business_deals_repository.dart';

class CreateBusinessDealUseCase {
  final BusinessDealsRepository repository;

  CreateBusinessDealUseCase(this.repository);

  Future<BusinessDealEntity> call(CreateBusinessDealParams params) {
    return repository.createBusinessDeal(params);
  }
}
