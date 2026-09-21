import '../../domain/entities/leadership_submissions_response_entity.dart';
import 'leadership_certification_result_model.dart';

class LeadershipSubmissionsResponseModel extends LeadershipSubmissionsResponseEntity {
  const LeadershipSubmissionsResponseModel({
    super.items = const [],
    super.currentPage = 1,
    super.lastPage = 1,
    super.perPage = 15,
    super.total = 0,
  });

  factory LeadershipSubmissionsResponseModel.fromJson(Map<String, dynamic> json) {
    List<LeadershipCertificationResultModel> parsedItems = [];
    final dynamic rawData = json['data'];
    if (rawData is List) {
      parsedItems = rawData
          .map((e) => LeadershipCertificationResultModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    }

    final meta = json['meta'] as Map<String, dynamic>?;
    final currentPage = int.tryParse(meta?['current_page']?.toString() ?? '') ?? 1;
    final lastPage = int.tryParse(meta?['last_page']?.toString() ?? '') ?? 1;
    final perPage = int.tryParse(meta?['per_page']?.toString() ?? '') ?? 15;
    final total = int.tryParse(meta?['total']?.toString() ?? '') ?? parsedItems.length;

    return LeadershipSubmissionsResponseModel(
      items: parsedItems,
      currentPage: currentPage,
      lastPage: lastPage,
      perPage: perPage,
      total: total,
    );
  }
}
