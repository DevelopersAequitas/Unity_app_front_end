import '../entities/requirement.dart';
import '../repositories/requirements_repository.dart';

class GetOpenRequirementsUseCase {
  final RequirementsRepository repository;
  GetOpenRequirementsUseCase(this.repository);
  Future<List<Requirement>> call() => repository.getOpenRequirements();
}

class GetMyRequirementsUseCase {
  final RequirementsRepository repository;
  GetMyRequirementsUseCase(this.repository);
  Future<List<Requirement>> call() => repository.getMyRequirements();
}

class CreateRequirementUseCase {
  final RequirementsRepository repository;
  CreateRequirementUseCase(this.repository);
  Future<void> call({
    required String subject,
    required String description,
    required String category,
    required String regionLabel,
    required String cityName,
    String? mediaId,
  }) =>
      repository.createRequirement(
        subject: subject,
        description: description,
        category: category,
        regionLabel: regionLabel,
        cityName: cityName,
        mediaId: mediaId,
      );
}

class CompleteRequirementUseCase {
  final RequirementsRepository repository;
  CompleteRequirementUseCase(this.repository);
  Future<void> call(String id) => repository.completeRequirement(id);
}

class FulfillRequirementUseCase {
  final RequirementsRepository repository;
  FulfillRequirementUseCase(this.repository);
  Future<void> call(String id, String message) => repository.fulfillRequirement(id, message);
}
