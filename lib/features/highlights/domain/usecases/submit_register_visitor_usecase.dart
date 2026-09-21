import '../entities/register_visitor_entity.dart';
import '../repositories/register_visitor_repository.dart';

class SubmitRegisterVisitorUseCase {
  final RegisterVisitorRepository repository;
  const SubmitRegisterVisitorUseCase(this.repository);

  Future<void> call(RegisterVisitorEntity entity) =>
      repository.submitRegisterVisitor(entity);
}
