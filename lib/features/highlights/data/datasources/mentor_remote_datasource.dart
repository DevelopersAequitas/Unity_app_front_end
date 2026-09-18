import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/mentor_submission_model.dart';

abstract class MentorRemoteDataSource {
  Future<List<MentorSubmissionModel>> getSubmissions();
  Future<String> submitApplication(MentorSubmissionModel model);
}

class MentorRemoteDataSourceImpl implements MentorRemoteDataSource {
  final DioClient dioClient;

  const MentorRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<MentorSubmissionModel>> getSubmissions() async {
    final response = await dioClient.dio.get(ApiEndpoints.becomeAMentor);
    final data = response.data;
    final list = <MentorSubmissionModel>[];

    dynamic itemsData = data;
    if (data is Map<String, dynamic>) {
      itemsData = data['data'] ?? data['items'] ?? data;
    }

    if (itemsData is List) {
      for (final item in itemsData) {
        if (item is Map<String, dynamic>) {
          list.add(MentorSubmissionModel.fromJson(item));
        }
      }
    } else if (itemsData is Map<String, dynamic>) {
      final innerItems = itemsData['items'] ?? itemsData['data'];
      if (innerItems is List) {
        for (final item in innerItems) {
          if (item is Map<String, dynamic>) {
            list.add(MentorSubmissionModel.fromJson(item));
          }
        }
      } else {
        list.add(MentorSubmissionModel.fromJson(itemsData));
      }
    }

    return list;
  }

  @override
  Future<String> submitApplication(MentorSubmissionModel model) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.becomeAMentor,
      data: model.toJson(),
    );

    if (response.data is Map<String, dynamic>) {
      final msg = response.data['message']?.toString();
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return 'Mentor application submitted successfully.';
  }
}
