import '../entities/post_report_reason_entity.dart';
import '../repositories/home_repository.dart';

class GetPostReportReasonsUseCase {
  final HomeRepository repository;

  GetPostReportReasonsUseCase(this.repository);

  Future<List<PostReportReasonEntity>> call() {
    return repository.getPostReportReasons();
  }
}
