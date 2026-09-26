import '../entities/ask_type_entity.dart';
import '../repositories/asks_repository.dart';

class GetAskTypesUseCase {
  final AsksRepository repository;

  GetAskTypesUseCase(this.repository);

  Future<List<AskTypeEntity>> call(String flowIdOrCode) async {
    return await repository.getAskTypes(flowIdOrCode);
  }
}
