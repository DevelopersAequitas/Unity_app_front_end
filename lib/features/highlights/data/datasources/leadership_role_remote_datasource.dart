import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/leadership_interest_model.dart';

abstract class LeadershipRoleRemoteDataSource {
  Future<void> submitLeadershipInterest(LeadershipInterestModel model);
}

class LeadershipRoleRemoteDataSourceImpl implements LeadershipRoleRemoteDataSource {
  final DioClient dioClient;

  const LeadershipRoleRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> submitLeadershipInterest(LeadershipInterestModel model) async {
    await dioClient.dio.post(ApiEndpoints.leaderInterest, data: model.toJson());
  }
}
