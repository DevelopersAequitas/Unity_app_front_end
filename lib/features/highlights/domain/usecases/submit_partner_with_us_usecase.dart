import '../entities/partner_with_us_entity.dart';
import '../repositories/partner_with_us_repository.dart';

class SubmitPartnerWithUsUseCase {
  final PartnerWithUsRepository repository;

  const SubmitPartnerWithUsUseCase(this.repository);

  Future<String> call(PartnerWithUsEntity entity) async {
    return await repository.submitPartnerWithUs(entity);
  }
}
