import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/speaker_submission_model.dart';

abstract class SpeakerRemoteDataSource {
  Future<List<SpeakerSubmissionModel>> getSubmissions();
  Future<String> submitApplication({
    required SpeakerSubmissionModel model,
    File? imageFile,
  });
}

class SpeakerRemoteDataSourceImpl implements SpeakerRemoteDataSource {
  final DioClient dioClient;

  const SpeakerRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SpeakerSubmissionModel>> getSubmissions() async {
    final response = await dioClient.dio.get(ApiEndpoints.becomeASpeaker);
    final data = response.data;
    final list = <SpeakerSubmissionModel>[];

    dynamic itemsData = data;
    if (data is Map<String, dynamic>) {
      itemsData = data['data'] ?? data['items'] ?? data;
    }

    if (itemsData is List) {
      for (final item in itemsData) {
        if (item is Map<String, dynamic>) {
          list.add(SpeakerSubmissionModel.fromJson(item));
        }
      }
    } else if (itemsData is Map<String, dynamic>) {
      final innerItems = itemsData['items'] ?? itemsData['data'];
      if (innerItems is List) {
        for (final item in innerItems) {
          if (item is Map<String, dynamic>) {
            list.add(SpeakerSubmissionModel.fromJson(item));
          }
        }
      } else {
        list.add(SpeakerSubmissionModel.fromJson(itemsData));
      }
    }

    return list;
  }

  @override
  Future<String> submitApplication({
    required SpeakerSubmissionModel model,
    File? imageFile,
  }) async {
    dynamic requestData;
    if (imageFile != null) {
      final map = model.toJson();
      final formDataMap = Map<String, dynamic>.from(map);
      formDataMap['image'] = await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.path.split(Platform.pathSeparator).last,
      );
      requestData = FormData.fromMap(formDataMap);
    } else {
      requestData = model.toJson();
    }

    final response = await dioClient.dio.post(
      ApiEndpoints.becomeASpeaker,
      data: requestData,
    );

    if (response.data is Map<String, dynamic>) {
      final msg = response.data['message']?.toString();
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return 'Speaker application submitted successfully.';
  }
}
