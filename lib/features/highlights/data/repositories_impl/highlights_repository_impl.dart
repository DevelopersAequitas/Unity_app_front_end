import '../../domain/entities/highlight_section.dart';
import '../../domain/repositories/highlights_repository.dart';
import '../datasources/highlights_local_datasource.dart';

class HighlightsRepositoryImpl implements HighlightsRepository {
  final HighlightsLocalDataSource localDataSource;

  HighlightsRepositoryImpl(this.localDataSource);

  @override
  Future<List<HighlightSection>> getHighlightSections() async {
    return await localDataSource.getHighlightSections();
  }
}
