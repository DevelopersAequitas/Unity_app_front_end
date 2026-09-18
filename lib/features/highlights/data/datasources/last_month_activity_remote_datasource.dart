import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/last_month_activity_model.dart';

abstract class LastMonthActivityRemoteDataSource {
  Future<LastMonthActivityModel> getLastMonthActivity();
}

class LastMonthActivityRemoteDataSourceImpl implements LastMonthActivityRemoteDataSource {
  final DioClient dioClient;
  const LastMonthActivityRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<LastMonthActivityModel> getLastMonthActivity() async {
    final response = await dioClient.dio.get(ApiEndpoints.lastMonthActivity);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return LastMonthActivityModel.fromJson(data);
  }
}
