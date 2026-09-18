import '../../domain/entities/last_month_activity_entity.dart';
import '../../domain/repositories/last_month_activity_repository.dart';
import '../datasources/last_month_activity_remote_datasource.dart';

class LastMonthActivityRepositoryImpl implements LastMonthActivityRepository {
  final LastMonthActivityRemoteDataSource remoteDataSource;

  const LastMonthActivityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<LastMonthActivityEntity> getLastMonthActivity() async {
    final model = await remoteDataSource.getLastMonthActivity();
    return model.toEntity();
  }
}
