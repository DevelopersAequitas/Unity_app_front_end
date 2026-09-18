import '../entities/partner_with_us_entity.dart';
import '../repositories/partner_with_us_repository.dart';

class GetPartnerWithUsSubmissionsUseCase {
  final PartnerWithUsRepository repository;

  const GetPartnerWithUsSubmissionsUseCase(this.repository);

  Future<List<PartnerWithUsEntity>> call() async {
    return await repository.getPartnerWithUsSubmissions();
  }
}
