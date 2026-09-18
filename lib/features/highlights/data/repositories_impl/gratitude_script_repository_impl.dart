import '../../domain/entities/gratitude_script_entity.dart';
import '../../domain/repositories/gratitude_script_repository.dart';
import '../datasources/gratitude_script_remote_datasource.dart';

class GratitudeScriptRepositoryImpl implements GratitudeScriptRepository {
  final GratitudeScriptRemoteDataSource remoteDataSource;

  const GratitudeScriptRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GratitudeScriptEntity> getGratitudeScript() async {
    final model = await remoteDataSource.getGratitudeScript();
    return model.toEntity();
  }

  @override
  Future<GratitudeScriptEntity> saveGratitudeScript({
    required String progressWord,
    required String nextMonthGoal,
    String experienceStory = '',
  }) async {
    final model = await remoteDataSource.saveGratitudeScript(
      progressWord: progressWord,
      nextMonthGoal: nextMonthGoal,
      experienceStory: experienceStory,
    );
    return model.toEntity();
  }
}

