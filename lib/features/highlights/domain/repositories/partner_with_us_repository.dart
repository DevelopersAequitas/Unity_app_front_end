import '../entities/partner_with_us_entity.dart';

abstract class PartnerWithUsRepository {
  Future<List<PartnerWithUsEntity>> getPartnerWithUsSubmissions();
  Future<String> submitPartnerWithUs(PartnerWithUsEntity entity);
}
