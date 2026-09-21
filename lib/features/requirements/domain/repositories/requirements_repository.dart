import '../entities/requirement.dart';

abstract class RequirementsRepository {
  Future<List<Requirement>> getOpenRequirements();
  Future<List<Requirement>> getMyRequirements();
  Future<void> createRequirement({
    required String subject,
    required String description,
    required String category,
    required String regionLabel,
    required String cityName,
    String? mediaId,
  });
  Future<void> completeRequirement(String id);
  Future<void> fulfillRequirement(String id, String message);
}
