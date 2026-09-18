import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/gratitude_script_model.dart';

abstract class GratitudeScriptRemoteDataSource {
  Future<GratitudeScriptModel> getGratitudeScript();
  Future<GratitudeScriptModel> saveGratitudeScript({
    required String progressWord,
    required String nextMonthGoal,
    String experienceStory = '',
  });
}

class GratitudeScriptRemoteDataSourceImpl implements GratitudeScriptRemoteDataSource {
  final DioClient dioClient;
  const GratitudeScriptRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<GratitudeScriptModel> getGratitudeScript() async {
    final response = await dioClient.dio.get(ApiEndpoints.peerMonthlyImpactScript);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return GratitudeScriptModel.fromJson(data);
  }

  @override
  Future<GratitudeScriptModel> saveGratitudeScript({
    required String progressWord,
    required String nextMonthGoal,
    String experienceStory = '',
  }) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.peerMonthlyImpactScript,
      data: {
        'meaningful_progress_this_month': progressWord,
        'meaningful_progress': progressWord,
        'goal_for_next_month': nextMonthGoal,
        'experience_or_story_optional': experienceStory,
        'story': experienceStory,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return GratitudeScriptModel.fromJson(data);
  }
}

