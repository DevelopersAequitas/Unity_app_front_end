import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/partner_with_us_model.dart';

abstract class PartnerWithUsRemoteDataSource {
  Future<List<PartnerWithUsModel>> getSubmissions();
  Future<String> submitApplication(PartnerWithUsModel model);
}

class PartnerWithUsRemoteDataSourceImpl implements PartnerWithUsRemoteDataSource {
  final DioClient dioClient;

  const PartnerWithUsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<PartnerWithUsModel>> getSubmissions() async {
    final response = await dioClient.dio.get(ApiEndpoints.partnerWithUs);
    final data = response.data;
    final list = <PartnerWithUsModel>[];

    dynamic itemsData = data;
    if (data is Map<String, dynamic>) {
      itemsData = data['data'] ?? data['items'] ?? data;
    }

    if (itemsData is List) {
      for (final item in itemsData) {
        if (item is Map<String, dynamic>) {
          list.add(PartnerWithUsModel.fromJson(item));
        }
      }
    } else if (itemsData is Map<String, dynamic>) {
      final innerItems = itemsData['items'] ?? itemsData['data'];
      if (innerItems is List) {
        for (final item in innerItems) {
          if (item is Map<String, dynamic>) {
            list.add(PartnerWithUsModel.fromJson(item));
          }
        }
      } else {
        list.add(PartnerWithUsModel.fromJson(itemsData));
      }
    }

    return list;
  }

  @override
  Future<String> submitApplication(PartnerWithUsModel model) async {
    final response = await dioClient.dio.post(
      ApiEndpoints.partnerWithUs,
      data: model.toJson(),
    );

    if (response.data is Map<String, dynamic>) {
      final msg = response.data['message']?.toString();
      if (msg != null && msg.isNotEmpty) return msg;
    }
    return 'Partner with us application submitted successfully.';
  }
}
