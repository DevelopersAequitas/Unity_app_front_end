import '../entities/last_month_activity_entity.dart';
import '../repositories/last_month_activity_repository.dart';

class GetLastMonthActivityUseCase {
  final LastMonthActivityRepository repository;
  const GetLastMonthActivityUseCase(this.repository);

  Future<LastMonthActivityEntity> call() =>
      repository.getLastMonthActivity();
}
