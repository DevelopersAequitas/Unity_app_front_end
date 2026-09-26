import '../entities/ask_form_config_entity.dart';
import '../repositories/asks_repository.dart';

class GetAskFormConfigUseCase {
  final AsksRepository repository;

  GetAskFormConfigUseCase(this.repository);

  Future<AskFormConfigEntity> call({
    required String flowId,
    required String typeId,
  }) async {
    return await repository.getFormConfig(
      flowId: flowId,
      typeId: typeId,
    );
  }
}
