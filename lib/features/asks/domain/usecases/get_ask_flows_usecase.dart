import '../entities/ask_flow_entity.dart';
import '../repositories/asks_repository.dart';

class GetAskFlowsUseCase {
  final AsksRepository repository;

  GetAskFlowsUseCase(this.repository);

  Future<List<AskFlowEntity>> call() async {
    return await repository.getAskFlows();
  }
}
