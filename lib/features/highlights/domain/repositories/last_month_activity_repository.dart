import '../entities/last_month_activity_entity.dart';

abstract class LastMonthActivityRepository {
  Future<LastMonthActivityEntity> getLastMonthActivity();
}
