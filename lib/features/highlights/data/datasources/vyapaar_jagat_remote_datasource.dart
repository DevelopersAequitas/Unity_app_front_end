import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/vyapaar_jagat_story_model.dart';
import '../models/vyapaar_jagat_story_status_model.dart';

abstract class VyapaarJagatRemoteDataSource {
  Future<VyapaarJagatStoryStatusModel> getStoryStatus();
  Future<String> submitStory(VyapaarJagatStoryModel model);
}

class VyapaarJagatRemoteDataSourceImpl implements VyapaarJagatRemoteDataSource {
  final DioClient dioClient;

  const VyapaarJagatRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<VyapaarJagatStoryStatusModel> getStoryStatus() async {
    try {
      final response = await dioClient.dio.get(ApiEndpoints.storyStatus);
      if (response.data is Map<String, dynamic>) {
        return VyapaarJagatStoryStatusModel.fromJson(response.data);
      }
    } catch (_) {}
    return const VyapaarJagatStoryStatusModel();
  }

  @override
  Future<String> submitStory(VyapaarJagatStoryModel model) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.storySubmission,
      data: model.toJson(),
    );

    if (response.data is Map<String, dynamic>) {
      final msg = response.data['message']?.toString();
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return 'Your story has been submitted successfully for editorial review.';
  }
}
