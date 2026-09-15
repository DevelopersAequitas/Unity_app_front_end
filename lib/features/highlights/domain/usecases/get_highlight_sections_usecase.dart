import '../entities/highlight_section.dart';
import '../repositories/highlights_repository.dart';

class GetHighlightSectionsUseCase {
  final HighlightsRepository repository;

  GetHighlightSectionsUseCase(this.repository);

  Future<List<HighlightSection>> call() async {
    return await repository.getHighlightSections();
  }
}
