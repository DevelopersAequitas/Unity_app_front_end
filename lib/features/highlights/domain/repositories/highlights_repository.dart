import '../entities/highlight_section.dart';

abstract class HighlightsRepository {
  Future<List<HighlightSection>> getHighlightSections();
}
