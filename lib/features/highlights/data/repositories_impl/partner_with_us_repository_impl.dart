import '../../domain/entities/partner_with_us_entity.dart';
import '../../domain/repositories/partner_with_us_repository.dart';
import '../datasources/partner_with_us_remote_datasource.dart';
import '../models/partner_with_us_model.dart';

class PartnerWithUsRepositoryImpl implements PartnerWithUsRepository {
  final PartnerWithUsRemoteDataSource remoteDataSource;

  const PartnerWithUsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PartnerWithUsEntity>> getPartnerWithUsSubmissions() async {
    return await remoteDataSource.getSubmissions();
  }

  @override
  Future<String> submitPartnerWithUs(PartnerWithUsEntity entity) async {
    final model = PartnerWithUsModel.fromEntity(entity);
    return await remoteDataSource.submitApplication(model);
  }
}
