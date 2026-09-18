import '../../domain/entities/vyapaar_jagat_story_entity.dart';
import '../../domain/entities/vyapaar_jagat_story_status_entity.dart';
import '../../domain/repositories/vyapaar_jagat_repository.dart';
import '../datasources/vyapaar_jagat_remote_datasource.dart';
import '../models/vyapaar_jagat_story_model.dart';

class VyapaarJagatRepositoryImpl implements VyapaarJagatRepository {
  final VyapaarJagatRemoteDataSource remoteDataSource;

  const VyapaarJagatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<VyapaarJagatStoryStatusEntity> getStoryStatus() async {
    return await remoteDataSource.getStoryStatus();
  }

  @override
  Future<String> submitStory(VyapaarJagatStoryEntity entity) async {
    final model = VyapaarJagatStoryModel.fromEntity(entity);
    return await remoteDataSource.submitStory(model);
  }
}
