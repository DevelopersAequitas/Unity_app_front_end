import '../entities/gratitude_script_entity.dart';
import '../repositories/gratitude_script_repository.dart';

class GetGratitudeScriptUseCase {
  final GratitudeScriptRepository repository;
  const GetGratitudeScriptUseCase(this.repository);

  Future<GratitudeScriptEntity> call() =>
      repository.getGratitudeScript();
}
