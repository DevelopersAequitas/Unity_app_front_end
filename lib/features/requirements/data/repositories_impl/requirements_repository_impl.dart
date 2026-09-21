import '../../domain/entities/requirement.dart';
import '../../domain/repositories/requirements_repository.dart';
import '../datasources/requirements_remote_datasource.dart';

class RequirementsRepositoryImpl implements RequirementsRepository {
  final RequirementsRemoteDataSource remoteDataSource;

  RequirementsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Requirement>> getOpenRequirements() =>
      remoteDataSource.getOpenRequirements();

  @override
  Future<List<Requirement>> getMyRequirements() =>
      remoteDataSource.getMyRequirements();

  @override
  Future<void> createRequirement({
    required String subject,
    required String description,
    required String category,
    required String regionLabel,
    required String cityName,
    String? mediaId,
  }) =>
      remoteDataSource.createRequirement(
        subject: subject,
        description: description,
        category: category,
        regionLabel: regionLabel,
        cityName: cityName,
        mediaId: mediaId,
      );

  @override
  Future<void> completeRequirement(String id) =>
      remoteDataSource.completeRequirement(id);

  @override
  Future<void> fulfillRequirement(String id, String message) =>
      remoteDataSource.fulfillRequirement(id, message);
}
