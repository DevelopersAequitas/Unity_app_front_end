import '../entities/business_deal_entity.dart';
import '../repositories/business_deals_repository.dart';

class GetBusinessDealDetailUseCase {
  final BusinessDealsRepository repository;

  GetBusinessDealDetailUseCase(this.repository);

  Future<BusinessDealEntity> call(String id) {
    return repository.getBusinessDealDetail(id);
  }
}
